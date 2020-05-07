import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class upload_notes extends StatefulWidget {

  final String dept;
  final String sub;
  upload_notes(this.dept, this.sub , {Key key}) : super(key: key);

  @override
  _upload_notesState createState() => _upload_notesState();
}

class _upload_notesState extends State<upload_notes> {
  bool isTapped = false;
  bool isTapped2 = false;
  File file;

  @override
  void initState(){
    print("Notes/${widget.dept}_${widget.sub}_Notes.pdf");
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
    StorageReference ref = FirebaseStorage.instance.ref().child("Notes/${widget.dept}_${widget.sub}_Notes.pdf");
    await ref.putFile(file).onComplete;
    print("OKay done");
  }

  Future<void> deleteFile(File file) async {
    var delFile = FirebaseStorage.instance.ref().child("Notes/${widget.dept}_${widget.sub}_Notes.pdf");
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
      appBar: AppBar(
        title: Text("Upload Notes"),
        centerTitle: true,
        elevation: 0.1,
      ),
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
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
                      : Text('Upload Notes',
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
                      : Text('Delete Notes',
                      style: TextStyle(color: Colors.white)))
            ],
          ),
        ),
      ),
    );
  }
}
