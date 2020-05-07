import 'package:flutter/material.dart';
import 'package:teacheralpine/assignment/assignment_upload.dart';

class sub_assign extends StatefulWidget {

  final String department;
  final String semesterr;
  sub_assign(this.department , this.semesterr, {Key key}) : super(key : key);

  @override
  _sub_assignState createState() => _sub_assignState();
}

class _sub_assignState extends State<sub_assign> {


  TextEditingController _subject = new TextEditingController();
  bool _isTapped;
  final _formKey = GlobalKey<FormState>();


  void initState(){
    print(widget.department);
    print(widget.semesterr);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose the Subject"),
        centerTitle: true,
        elevation: 0.1,
      ),
      backgroundColor: Color.fromRGBO(58,66,86,1.0),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
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
                  ),
                ),
              ),
            ),
            RaisedButton(
              elevation: 5.0,
              color: Colors.teal,splashColor: Colors.white,
              child: Text("Submit" , style: TextStyle(color: Colors.white),),
              onPressed: (){
                String Dept = widget.department;
                String semesterr =widget.semesterr;
                String subject = _subject.text;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => assignment(Dept , semesterr , subject)));
              },
            )
          ],
        )
      ),
    );
  }
}
