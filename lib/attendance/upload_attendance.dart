import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


List<double> percentage;

class upload_attendance extends StatefulWidget {
  @override
  _upload_attendanceState createState() => _upload_attendanceState();
}

class _upload_attendanceState extends State<upload_attendance> {

  bool _tapped;
  int _no_of_subjects;
  final _formkey = GlobalKey<FormState>();

  List<TextEditingController> _subject;
  List<TextEditingController> _present;
  List<TextEditingController> _absent;
  TextEditingController _reg_no = new TextEditingController();
  TextEditingController _name = new TextEditingController();

  void _shDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Added Successfully"),
            actions: <Widget>[
              FlatButton(
                child: Text("Return"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void initState() {
    super.initState();
    _tapped = false;
    _no_of_subjects = 1;
    _subject =
        List.generate(_no_of_subjects, (context) => new TextEditingController());
    _present =
        List.generate(_no_of_subjects, (context) => new TextEditingController());
    _absent =
        List.generate(_no_of_subjects, (context) => new TextEditingController());
  }

  Future _addGame() async {
    var names = _name.text;
    var reg_no = _reg_no.text;
    var _details = Map<String, String>();
    _details["Name of student"] = names;
    _details["Registration Number"] = reg_no;
    _details["NumberOfSub"] = "$_no_of_subjects";
    for (var i = 0; i < _no_of_subjects; i++) {
      _details["Subject${i + 1}"] = "${_subject[i].text}";
      _details["Present${i + 1}"] = "${_present[i].text}";
      _details["Absent${i + 1}"] = "${_absent[i].text}";
      _details["Percentage${i+1}"] = "${(100 * int.parse(_present[i].text)/(int.parse(_absent[i].text) + int.parse(_present[i].text))).toStringAsFixed(2) }";
    }

    await Firestore.instance
        .collection("Attendance")
        .document(reg_no)
        .setData(_details)
        .whenComplete(() {
      setState(() {
        _tapped = false;
      });
      _shDialog();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        appBar: AppBar(
          title: Text("Upload Attendance"),
          centerTitle: true,
          elevation: 0.1,
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        ),
        body: Theme(
          data: new ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.teal,
              splashColor: Colors.teal,
              inputDecorationTheme: new InputDecorationTheme(
                  labelStyle: new TextStyle(
                      color: Colors.white,
                      fontSize: 20.0
                  )
              )
          ),
          child: Form(
            key: _formkey,
            child: ListView(
              children: <Widget>[
                SizedBox(
                    height: 20.0
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: TextFormField(
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          labelText: "Enter the Name of the Student",
                          hintText: "Enter Full name"
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Cannot be left empty";
                        }
                        else {
                          return null;
                        }
                      },
                      cursorColor: Colors.teal,
                      controller: _name,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: TextFormField(
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          labelText: "Enter the Registration Number",
                          hintText: "eg. 179301178"
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Cannot be left empty";
                        }
                        else {
                          return null;
                        }
                      },
                      cursorColor: Colors.teal,
                      controller: _reg_no,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _no_of_subjects,
                      itemBuilder: (BuildContext context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10.0)),
                                  border: Border.all(
                                      color: Colors.teal, width: 2.0)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TextFormField(
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.teal,
                                              width: 2.0),
                                          borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0)),
                                      labelText: "Enter the name of the Subject :",
                                      fillColor: Colors.teal,
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Cannot be left empty";
                                      }
                                      else {
                                        return null;
                                      }
                                    },
                                    controller: _subject[index],
                                    maxLines: null,
                                  ),
                                  SizedBox(height:10.0),
                                  Row(
                                    children: <Widget>[
                                      Text("Number of Presents : ",
                                        style: TextStyle(fontSize: 18.0,
                                            color: Colors.white),
                                      ),
                                      Container(
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.teal,
                                                    width: 2.0),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10.0)),
                                              labelText: "Enter Presents ",
                                              fillColor: Colors.teal,
                                            ),
                                            cursorColor: Colors.teal,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "Cannot be left empty";
                                              }
                                              else {
                                                return null;
                                              }
                                            },
                                            controller: _present[index],
                                            maxLines: null,
                                          ),
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width *
                                              0.4),
                                    ],
                                  ),
                                  SizedBox(height: 10.0,),
                                  Row(
                                    children: <Widget>[
                                      Text("Number of Absents : ",
                                        style: TextStyle(fontSize: 18.0,
                                            color: Colors.white),
                                      ),
                                      Container(
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.teal,
                                                    width: 2.0),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10.0)),
                                              labelText: "Enter Absents ",
                                              fillColor: Colors.teal,
                                            ),
                                            cursorColor: Colors.teal,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "Cannot be left empty";
                                              }
                                              else {
                                                return null;
                                              }
                                            },
                                            controller: _absent[index],
                                            maxLines: null,
                                          ),
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width *
                                              0.4),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  (_no_of_subjects - 1 == index)
                                      ? Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      RaisedButton(
                                        color: Colors.teal,
                                        child: Icon(
                                            Icons.remove, color: Colors.white),
                                        onPressed: () {
                                          setState(() {
                                            if (_no_of_subjects > 1) {
                                              _no_of_subjects =
                                                  _no_of_subjects - 1;
                                              _subject.removeLast();
                                              _present.removeLast();
                                              _absent.removeLast();
                                            }
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        width: 20.0,
                                      ),
                                      RaisedButton(
                                        color: Colors.teal,
                                        child: Icon(
                                          Icons.add, color: Colors.white,),
                                        onPressed: () {
                                          setState(() {
                                            _no_of_subjects = _no_of_subjects + 1;
                                            _subject.add(
                                                TextEditingController());
                                            _present.add(
                                                TextEditingController());
                                            _absent.add(
                                                TextEditingController());
                                          });
                                        },
                                      ),
                                    ],
                                  )
                                      : SizedBox(),
                                ],
                              )),
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: RaisedButton(
                    elevation: 2.0,
                    splashColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    disabledColor: Colors.teal,
                    color: Colors.teal,
                    child: (_tapped)
                        ? SpinKitWave(
                      size: 20.0,
                      color: Colors.white,
                    )
                        : Text(
                      "Submit",
                      style: TextStyle(color: Colors.white,),
                    ),
                    onPressed: (!_tapped)
                        ? () {
                      if (_formkey.currentState.validate()) {
                        setState(() {
                          _tapped = true;
                        });
                        _addGame();
                      }
                    }
                        : null,
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
