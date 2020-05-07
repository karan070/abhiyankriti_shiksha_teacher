import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class upload_page extends StatefulWidget {

  final String dept;
  final String semesterr;
  upload_page(this.dept, this.semesterr , {Key key}) : super(key: key);


  @override
  _upload_pageState createState() => _upload_pageState();
}

class _upload_pageState extends State<upload_page> {
  bool isTapped = false;
  bool isTapped2 = false;
  File file;
  String _uploadedFileURL;

  @override
  void initState(){
    print("Time Table/${widget.dept}_${widget.semesterr}_TimeTable.pdf");
    super.initState();
  }

  Future getFile() async {
    var tempfile = await FilePicker.getFile(type: FileType.any);
    setState(() {
      file = tempfile;
    });
    (file == null) ? print("Empty") : print("got it here");

  }

  Future uploadFile(File file)  async{
    StorageReference ref = FirebaseStorage.instance.ref().child("Time Table/${widget.dept}_${widget.semesterr}_TimeTable.pdf");
     await ref.putFile(file).onComplete;
     print("OKay done");
  }

  Future<void> deleteFile(File file) async {
    var delFile = FirebaseStorage.instance.ref().child("Time Table/${widget.dept}_${widget.semesterr}_TimeTable.pdf");
    delFile.getName().then((onValue){
      print(onValue);
    });
    delFile.delete().whenComplete(() {
      setState(() {
        isTapped = false;
      });
      Fluttertoast.showToast(
          msg: "File Deleted Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.teal,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: new AppBar(
        title: new Text("Time Table"),
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
                  onPressed:() async{
                    await getFile().whenComplete((){
                      setState(() {
                        isTapped2 = true;
                      });
                    });
                    if(file == null){
                      setState(() {
                        isTapped2 = false;
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
                      uploadFile(file).whenComplete((){
                        setState(() {
                          isTapped2 = false;
                        });
                        Fluttertoast.showToast(
                            msg: "File Uploaded!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.teal,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                      );
                    }
                  },
                  child:(isTapped2)
                      ? SizedBox(
                    child: SpinKitWave(
                      color: Colors.white,
                      size: 16.0,
                    ),
                    width: 100.0,
                  )
                      : Text('Upload the Time Table',
                      style: TextStyle(color: Colors.white))),
              SizedBox(height: 30.0),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  ),
                  Expanded(
                      child: Divider(
                    color: Colors.white,
                  )),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  Text(
                    "OR",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Padding(padding: EdgeInsets.all(5.0)),
                  Expanded(
                      child: Divider(
                    color: Colors.white,
                  )),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  ),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              FlatButton(
                  splashColor: Colors.white,
                  color: Colors.teal,
                  onPressed: (isTapped)
                      ? () {}
                      : () {
                          setState(() {
                            isTapped = true;
                          });
                          deleteFile(file);
                        },
                  child: (isTapped)
                      ? SizedBox(
                          child: SpinKitWave(
                            color: Colors.white,
                            size: 16.0,
                          ),
                          width: 100.0,
                        )
                      : Text('Delete the Uploaded Time Table',
                          style: TextStyle(color: Colors.white)))
            ],
          ),
        ),
      ),
    );
  }
}
