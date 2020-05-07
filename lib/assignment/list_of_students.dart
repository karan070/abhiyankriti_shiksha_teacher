import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String file = "Assignment Solutions/${subject}_${reg_no}_Solution.pdf";
String fileName = "${subject} ${department} ${semesterr} Questions";
String department;
String semesterr;
String subject;
String pdfurl;
String reg_no ;
GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

class list_of_students extends StatefulWidget {

  final String department;
  final String semesterr;
  final String subject;
  list_of_students(this.department , this.semesterr , this.subject ,{Key key}) : super(key : key);

  @override
  _list_of_studentsState createState() => _list_of_studentsState();
}

class _list_of_studentsState extends State<list_of_students> {

  static String pathPDF = "";
  static String pdfUrl = "";


  bool isTapped = false;
  String url;
  File file2;
  String _uploadedFileURL;
  bool loading = false;
  List wow = [];

  void initState(){
    subject = widget.subject;
    semesterr = widget.semesterr;
    department = widget.department;
    super.initState();
  }

  Future getFile() async {
    var tempfile = await FilePicker.getFile(type: FileType.any);
    setState(() {
      file2 = tempfile;
    });
    (file == null) ? print("Empty") : print("Got it here");

  }

  _getPdf(file , index){
    LaunchFile.loadFromFirebase(context, file).then((pdfurl) {
      setState(() {
        url = pdfurl;
      });
      print("Url for file");
      print(url);
      LaunchFile.createFileFromPdfUrl(url).then((f) {
        setState(() {
          if (f is File) {
            pathPDF = f.path;
          }
        },
        );
      }).whenComplete((){
        setState(() {
          isTapped = false;
          loading = false;
        });
        LaunchFile.launchPDF(
            context, "${subject} ${department} ${semesterr} Questions.pdf", pathPDF, pdfUrl);
      }
      );
    }).catchError((e){
      setState(() {
        isTapped = false;
        loading = false;
      });
      print("Error");
      Fluttertoast.showToast(
          msg: "No File to Display!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.teal,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Submissions"),
        centerTitle: true,
        elevation: 0.1,
      ),
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: ListView(
        children: <Widget>[
          StreamBuilder(
            stream: Firestore.instance.collection("${widget.department}_${widget.semesterr}").document("${widget.subject}").snapshots(),
            builder: (context , snapshot){
              if(!snapshot.hasData){
                return Text("Loading",style: TextStyle(color: Colors.white,fontSize: 20.0),);
              }else{
                wow.length = snapshot.data['Number Of Fields'];
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data['Number Of Fields'],
                    itemBuilder:(context , index){
                      reg_no = snapshot.data["Student ${index} "];
                      wow[index] = false;
                      return Card(
                        color: Color.fromRGBO(58, 66, 86, 1.0),
                        elevation: 10.0,
                        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Color.fromRGBO(64, 75, 96, .9)),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            leading: Container(
                              padding: EdgeInsets.only(right: 12.0),
                              decoration: new BoxDecoration(
                                  border: new Border(
                                      right: new BorderSide(width: 1.0, color: Colors.teal))),
                              child: Icon(Icons.school, color: Colors.teal),
                            ),
                            enabled: true,
                            onTap: () {
                               setState(() {
                                print(index);
                                wow[index] = true;
                                loading = true;
                                print(wow);
                                file = "Assignment Solutions/${subject}_${snapshot.data['Student $index ']}_Solution.pdf";
                              });
                              _getPdf(file , index);
                          },
                            title : Text( reg_no ,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 20.0),
                            ),
                            trailing: (loading) ? SizedBox(
                              height: 40.0,
                              width: 100.0,
                              child: SpinKitPouringHourglass(
                                size: 30.0,
                                color: Colors.teal,
                              ),
                            ) : Icon(Icons.arrow_forward_ios , color: Colors.teal,),
                        ),
                      ),
                      );
                    }
                );
              }
            },
          )
        ],
      ),
    );
  }
}

class LaunchFile {
  static void launchPDF(
      BuildContext context, String title, String pdfPath, String pdfUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFScreen(title,  pdfUrl),
      ),
    );
  }



  static Future<dynamic> loadFromFirebase(
      BuildContext context, String url) async {
    return FireStorageService.loadFromStorage(context, file) ;
  }

  static Future<dynamic> createFileFromPdfUrl(dynamic url) async {
    final filename = "${subject} ${department} ${semesterr} Solution" ; //I did it on purpose to avoid strange naming conflicts
    print(filename);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }
}
class PDFScreen extends StatefulWidget {

  String title;
  String pdurl;
  PDFScreen(this.title ,this.pdurl , {Key key}) : super(key :key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  PDFDocument _doc;
  bool isok = false;

  @override
  void initState() {
    print(pdfurl);
    super.initState();
    loadDocument();
  }

  Future <void> loadDocument() async {
    setState(() {
      isok = true;
    });
    final doc =  await PDFDocument.fromURL(pdfurl);
    setState(() {
      _doc = doc;
      isok = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isok ? Center(child: CircularProgressIndicator(),) :
      PDFViewer(document: _doc,),
    );
  }
}
class FireStorageService extends ChangeNotifier {
  FireStorageService._();
  FireStorageService();

  static Future<dynamic> loadFromStorage(
      BuildContext context, String file) async {
    print(file);
    print( await FirebaseStorage.instance.ref().child(file).getDownloadURL());
    pdfurl = await FirebaseStorage.instance.ref().child(file).getDownloadURL();
    return pdfurl;
  }
}