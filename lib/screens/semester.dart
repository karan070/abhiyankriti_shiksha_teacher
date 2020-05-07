import 'package:flutter/material.dart';
import 'package:teacheralpine/model/Semester.dart';
import 'package:teacheralpine/screens/upload.dart';

class sem_screen extends StatefulWidget {

  final String dept;
  sem_screen(this.dept , {Key key}) : super(key: key);

  @override
  _sem_screenState createState() => _sem_screenState();
}

class _sem_screenState extends State<sem_screen> {

  List sem;

  @override
  void initState() {
    sem = getsem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ListTile makeListTile(Semester semester) =>
        ListTile(
          contentPadding: EdgeInsets.symmetric(
              horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.teal))),
            child: Icon(Icons.school, color: Colors.teal),
          ),
          title: Text(
            semester.title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
          ),

          trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.teal, size: 30.0),
          onTap: () {
            String Dept = widget.dept;
            String semesterr = semester.title;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => upload_page(Dept , semesterr)));
          },
        );


    Card makeCard(Semester semester) =>
        Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            child: makeListTile(semester),
          ),
        );

    return Scaffold(
      appBar: new AppBar(
        title: Text("Semesters"),
        elevation: 0.1,
      ),
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: Container(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: sem.length ,
              itemBuilder: (BuildContext context , int index) {
                return makeCard(sem[index]);
              }
          )
      ),
    );
  }
}

List getsem(){
  return[
    Semester( title: "Semester 1"),
    Semester( title: "Semester 2"),
    Semester( title: "Semester 3"),
    Semester( title: "Semester 4"),
    Semester( title: "Semester 5"),
    Semester( title: "Semester 6"),
    Semester( title: "Semester 7"),
    Semester(title : "Semester 8"),
  ];
}