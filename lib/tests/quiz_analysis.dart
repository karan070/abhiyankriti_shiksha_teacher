import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class quiz_analysis extends StatefulWidget {
  @override
  _quiz_analysisState createState() => _quiz_analysisState();
}

class _quiz_analysisState extends State<quiz_analysis> {

  getResult() async{
    return await Firestore.instance.collection('Result').getDocuments();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58,66,86,1.0),
      appBar: new AppBar(
        title: Text("Test"),
        centerTitle: true,
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(58,66,86,1.0),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              color: Colors.teal,
              splashColor: Colors.white,
                onPressed: () {
                Navigator.of(context).pushNamed('/upload_quiz');
                },
                child: Text("Upload a test",style: TextStyle(color: Colors.white),)),
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
              color: Colors.teal,
              splashColor: Colors.white,
                onPressed: (){
                  Navigator.of(context).pushNamed('/result_screen');
                },
                child: Text("Result of Test",style: TextStyle(color: Colors.white),)),
            SizedBox(
              height: 30.0,
            ),
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
                color: Colors.teal,
                splashColor: Colors.white,
                onPressed: (){
                  Navigator.of(context).pushNamed('/stats');
                },
                child: Text("Analytics of a Test",style: TextStyle(color: Colors.white),)),

          ],
        ),
      ),
    );
  }
}
