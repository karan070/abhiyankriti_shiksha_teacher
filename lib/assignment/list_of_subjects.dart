import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacheralpine/assignment/list_of_students.dart';
import 'package:universal_io/io.dart';

String department;
String semesterr;
String subject;

class list_of_sub extends StatefulWidget {

  final String department;
  final String semesterr;
  final String subject;
  list_of_sub(this.department , this.semesterr ,this.subject , {Key key}) : super(key : key);

  @override
  _list_of_subState createState() => _list_of_subState();
}

class _list_of_subState extends State<list_of_sub> {

  void initState(){
    print("${widget.department}_${widget.semesterr}_${widget.subject}") ;
    department = widget.department;
    semesterr = widget.semesterr;
    subject = widget.subject;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Subjects"),
        centerTitle: true,
        elevation: 0.1,
      ),
      backgroundColor: Color.fromRGBO(58,66, 86,1.0),
      body: ListView(
        children: <Widget>[
          StreamBuilder(
            stream: Firestore.instance.collection("${department}_${semesterr}").snapshots(),
            builder: (context , snapshot){
              if(!snapshot.hasData){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(child: Text("Loading..." , style: TextStyle(color: Colors.white,fontSize: 40.0))),
                  ],
                );
              }
              else{
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context , index){
                      DocumentSnapshot ds = snapshot.data.documents[index];
                      return Card(
                        color: Color.fromRGBO(58, 66, 86, 1.0),
                          elevation: 10.0,
                          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Color.fromRGBO(64, 75, 96, .9)),
                          child: ListTile(
                            subtitle: Text("${department}::${semesterr}",style: TextStyle(
                              color: Colors.white
                            ),),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            leading: Container(
                              padding: EdgeInsets.only(right: 12.0),
                              decoration: new BoxDecoration(
                                  border: new Border(
                                      right: new BorderSide(width: 1.0, color: Colors.teal))),
                              child: Icon(Icons.school, color: Colors.teal),
                            ),
                            title: Text( ds.documentID ,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25.0),
                            ),
                            trailing:
                            Icon(Icons.keyboard_arrow_right, color: Colors.teal, size: 30.0),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute (
                                  builder : (context) => list_of_students(department,semesterr,ds.documentID)
                              ));
                            },
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
