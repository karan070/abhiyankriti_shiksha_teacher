import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class upload_quiz extends StatefulWidget {
  @override
  _upload_quizState createState() => _upload_quizState();
}

class _upload_quizState extends State<upload_quiz> {
  bool _tapped;
  int _numberQues;
  final _formkey = GlobalKey<FormState>();

  List<TextEditingController> _questions;
  List<TextEditingController> _answers;
  List<TextEditingController> _options1;
  List<TextEditingController> _options2;
  List<TextEditingController> _options3;
  TextEditingController _subject = new TextEditingController();

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
    _numberQues = 1;
    _questions =
        List.generate(_numberQues, (context) => new TextEditingController());
    _answers =
        List.generate(_numberQues, (context) => new TextEditingController());
    _options1 = List.generate(_numberQues, (context) => new TextEditingController());
    _options2 = List.generate(_numberQues, (context) => new TextEditingController());
    _options3 = List.generate(_numberQues, (context) => new TextEditingController());
  }

  Future _addGame() async{
    var quizz;
    var subjects = _subject.text;

    var _details = Map<String, String>();
    _details["Subject"] = subjects;
    _details["NumberOfQues"] = "$_numberQues";
    for (var i = 0; i < _numberQues; i++) {
      _details["Q${i + 1}"] = "${_questions[i].text}";
      _details["Answer${i + 1}"] = "${_answers[i].text}";
      _details["Option1.${i + 1}"] = "${_options1[i].text}";
      _details["Option2.${i + 1}"] = "${_options2[i].text}";
      _details["Option3.${i + 1}"] = "${_options3[i].text}";
    }

    await Firestore.instance
        .collection("Tests")
        .document(subjects)
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
      backgroundColor: Color.fromRGBO(58,66,86,1.0),
      appBar: AppBar(
        title: Text("Upload Quiz"),
          centerTitle: true,
          elevation: 0.1,
          backgroundColor: Color.fromRGBO(58,66,86,1.0),
      ),
      body:Theme(
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
                height : 20.0
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal,width: 2.0),
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      labelText: "Enter the Subject Code",
                      hintText: "eg. CS01JAVA , CS02C etc."
                    ),
                    cursorColor: Colors.teal,
                    controller: _subject,
                    validator: (value){
                      if(value.isEmpty){
                        return "Cannot be left empty";
                      }
                      else
                      {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _numberQues,
                    itemBuilder: (BuildContext context , index){
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                border: Border.all(
                                    color: Colors.teal, width: 2.0)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: "Question ${index + 1} :",
                                    fillColor: Colors.teal,
                                  ),
                                  validator: (value){
                                    if(value.isEmpty){
                                      return "Cannot be left empty";
                                    }
                                    else
                                    {
                                      return null;
                                    }
                                  },
                                  controller: _questions[index],
                                  maxLines: null,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text("Answer : ",
                                          style: TextStyle(fontSize: 18.0,color: Colors.white),
                                    ),
                                    Container(
                                        child: TextFormField(
                                          cursorColor: Colors.teal,
                                          validator: (value){
                                            if(value.isEmpty){
                                              return "Cannot be left empty";
                                            }
                                            else
                                            {
                                              return null;
                                            }
                                          },
                                          controller: _answers[index],
                                          maxLines: null,
                                          decoration: InputDecoration(
                                              hintStyle:
                                              TextStyle(fontSize: 10.0)),
                                        ),
                                        width: MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.5),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Option 1 : ",
                                      style: TextStyle(fontSize: 18.0,color: Colors.white),
                                    ),
                                    Container(
                                        child: TextFormField(
                                          cursorColor: Colors.teal,
                                          validator: (value){
                                            if(value.isEmpty){
                                              return "Cannot be left empty";
                                            }
                                            else
                                            {
                                              return null;
                                            }
                                          },
                                          controller: _options1[index],
                                          maxLines: null,
                                          decoration: InputDecoration(
                                              hintStyle:
                                              TextStyle(fontSize: 10.0)),
                                        ),
                                        width: MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.5)
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Option 2 : ",
                                      style: TextStyle(fontSize: 18.0,color: Colors.white),
                                    ),
                                    Container(
                                        child: TextFormField(
                                          cursorColor: Colors.teal,
                                          validator: (value){
                                            if(value.isEmpty){
                                              return "Cannot be left empty";
                                            }
                                            else
                                            {
                                              return null;
                                            }
                                          },
                                          controller: _options2[index],
                                          maxLines: null,
                                          decoration: InputDecoration(
                                              hintStyle:
                                              TextStyle(fontSize: 10.0)),
                                        ),
                                        width: MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.5)
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Option 3 : ",
                                      style: TextStyle(fontSize: 18.0,color: Colors.white),
                                    ),
                                    Container(
                                        child: TextFormField(
                                          cursorColor: Colors.teal,
                                          validator: (value){
                                            if(value.isEmpty){
                                              return "Cannot be left empty";
                                            }
                                            else
                                            {
                                              return null;
                                            }
                                          },
                                          controller: _options3[index],
                                          maxLines: null,
                                          decoration: InputDecoration(
                                              hintStyle:
                                              TextStyle(fontSize: 10.0)),
                                        ),
                                        width: MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.5)
                                  ],
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                (_numberQues - 1 == index)
                                    ? Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: <Widget>[
                                    RaisedButton(
                                      color : Colors.teal,
                                      child: Icon(Icons.remove,color: Colors.white),
                                      onPressed: () {
                                        setState(() {
                                          if (_numberQues > 1) {
                                            _numberQues =
                                                _numberQues - 1;
                                            _questions.removeLast();
                                            _answers.removeLast();
                                            _options1.removeLast();
                                            _options2.removeLast();
                                            _options3.removeLast();
                                          }
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    RaisedButton(
                                      color: Colors.teal,
                                      child: Icon(Icons.add,color: Colors.white,),
                                      onPressed: () {
                                        setState(() {
                                          _numberQues = _numberQues + 1;
                                          _questions.add(TextEditingController());
                                          _answers.add(TextEditingController());
                                          _options1.add(TextEditingController());
                                          _options2.add(TextEditingController());
                                          _options3.add(TextEditingController());
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
                    style: TextStyle(color: Colors.white, ),
                  ),
                  onPressed: (!_tapped)
                      ? () {
                    if(_formkey.currentState.validate()){
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
