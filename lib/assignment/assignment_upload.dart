import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:teacheralpine/assignment/list_of_subjects.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_downloader/flutter_downloader.dart';

String file = "Assignment/Questions.pdf";
String fileName = "Questions";
String department;
String semesterr;
String subject;
bool isTapped = false;
GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

class assignment extends StatefulWidget {

  final String department;
  final String semesterr;
  final String subject;
  assignment(this.department , this.semesterr , this.subject , {Key key}) : super(key : key);

  @override
  _assignmentState createState() => _assignmentState();
}

class _assignmentState extends State<assignment> {

  static String pathPDF = "";
  static String pdfUrl = "";

  bool spinEnabled = false;
  bool isTapped = false;
  bool isTapped2 = false;
  File file2;
  String _uploadedFileURL;

  void initState(){
    department = widget.department;
    semesterr = widget.semesterr;
    subject = widget.subject;
    print("${department}_${semesterr}_${subject}");
    super.initState();
  }

  Future upload_details() async{
    var _userdetails = Map<String, int>();
    _userdetails["Number Of Fields"] = 0;
      Firestore.instance.collection("${department}_${semesterr}").document(subject).setData(_userdetails);
  }

  Future getFile() async {
    var tempfile = await FilePicker.getFile(type: FileType.any);
    setState(() {
      file2 = tempfile;
    });
    (file2 == null) ? print("Empty") : print("got it here");

  }

  Future uploadFile(File file)  async{
    StorageReference ref = FirebaseStorage.instance.ref().child("Assignment/${subject}_${department}_${semesterr}_Questions.pdf");
    await ref.putFile(file2).onComplete;
    print("OKay done");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: new AppBar(
        title: new Text("Assignment"),
        elevation: 0.1,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                  splashColor: Colors.white,
                  color: Colors.teal,
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder : (context) => list_of_sub(department , semesterr , subject)
                    ));
                  },
                  child: (isTapped)?SizedBox(width:50,child: SpinKitWave(color: Colors.white,size: 16,)):Text("Open Assignment Solutions",style: TextStyle(color: Colors.white),)
              ),
              SizedBox(height: 30.0),
              Row(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(left: 20.0,right: 20.0),),
                  Expanded(
                      child: Divider(color: Colors.white,)
                  ),
                  Padding(padding: EdgeInsets.all(5.0),),
                  Text("OR",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.white),),
                  Padding(padding: EdgeInsets.all(5.0)),
                  Expanded(
                      child: Divider(color: Colors.white,)
                  ),
                  Padding(padding: EdgeInsets.only(left: 20.0,right: 20.0),),
                ],
              ),
              SizedBox(height: 30.0,),
              FlatButton(
                  splashColor: Colors.white,
                  color:Colors.teal,
                  onPressed:() {
                    setState(() {
                      spinEnabled = true;
                    });
                     getFile().whenComplete((){
                       if(file2 == null){
                         setState(() {
                           spinEnabled = false;
                         });
                         Fluttertoast.showToast(
                             msg: "No File Selected!",
                             toastLength: Toast.LENGTH_SHORT,
                             gravity: ToastGravity.BOTTOM,
                             timeInSecForIos: 1,
                             backgroundColor: Colors.teal,
                             textColor: Colors.white,
                             fontSize: 16.0);

                       }
                       else{
                         uploadFile(file2).whenComplete((){
                           upload_details();
                           Fluttertoast.showToast(
                               msg: "File Uploaded!",
                               toastLength: Toast.LENGTH_SHORT,
                               gravity: ToastGravity.BOTTOM,
                               timeInSecForIos: 1,
                               backgroundColor: Colors.teal,
                               textColor: Colors.white,
                               fontSize: 16.0);
                           setState(() {
                             spinEnabled = false;
                           });
                         }
                         );
                       }
                     });
                  },
                  child: (spinEnabled) ? Container(
                    height: 40.0,
                    width: 100.0,
                    color: Colors.teal,
                    child: SpinKitWave(
                      size: 20.0,
                      color: Colors.white,
                    ),
                  ) : Text('Upload Questions',style: TextStyle(color: Colors.white)))
            ],
          ),
        ),
      ),
    );
  }
}
