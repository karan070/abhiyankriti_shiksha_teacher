import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_animations/simple_animations.dart';

class stats extends StatefulWidget {
  @override
  _statsState createState() => _statsState();
}

class _statsState extends State<stats> {

  TextEditingController sub_code = new TextEditingController();
  bool isTapped = false;
  bool spinEnabled = false;
  bool isError = false;
  List<double> perc = [];
  QuerySnapshot result;
  var first;
  var sec;
  var third;
  var fourth;
  var first_perc;
  var sec_perc;
  var third_perc;
  var fourth_perc;
  var no_of_students;


  Future getData(sub_code) async {
    first=0;
    sec=0;
    third=0;
    fourth=0;
     result =  await Firestore.instance.collection('Result_$sub_code').getDocuments();
     if(result.documents.isNotEmpty) {
       for (int x = 0; x < result.documents.length; x++) {
         if (0.0 <= double.parse(result.documents[x].data['Percentage']) &&
             double.parse(result.documents[x].data['Percentage']) <= 25.0) {
           first++;
         }
         else if (25.0 < double.parse(result.documents[x].data['Percentage']) &&
             double.parse(result.documents[x].data['Percentage']) <= 50.0) {
           sec++;
         }
         else if (50.0 < double.parse(result.documents[x].data['Percentage']) &&
             double.parse(result.documents[x].data['Percentage']) <= 75.0) {
           third ++;
         }
         else {
           fourth++;
         }
       }
       no_of_students = result.documents.length;
       first_perc = first / no_of_students;
       sec_perc = sec / no_of_students;
       third_perc = third / no_of_students;
       fourth_perc = fourth / no_of_students;
       return result;
     }else{
       return null;
     }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Result"),
        centerTitle: true,
        elevation: 0.1,
      ),
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: Theme(
        data: new ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.teal,
            splashColor: Colors.teal,
            inputDecorationTheme: new InputDecorationTheme(
                labelStyle: new TextStyle(
                    color: Colors.white,
                    fontSize: 18.0
                )
            )
        ),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      cursorColor: Colors.teal,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal,width: 2.0),
                              borderRadius: BorderRadius.circular(10.0)
                          ),border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Enter the Subject Code",
                          hintText: "eg. JAVA,C etc."
                      ),
                      controller: sub_code,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:10.0),
                      child: RaisedButton(
                          color: Colors.teal,
                          elevation: 3.0,
                          splashColor: Colors.white,
                          child: (spinEnabled) ? SizedBox(width: 40.0,child: SpinKitWave(
                            color: Colors.white,
                            size: 16.0,
                          ),)
                              :Text("Get Statistics",style: TextStyle(color: Colors.white),),
                          onPressed: () {
                            setState(() {
                              spinEnabled = true;
                            });
                            getData(sub_code.text).then((onValue) {
                              if(onValue == null){
                                print("error");
                                setState(() {
                                  isError = true;
                                  isTapped = false;
                                  spinEnabled = false;
                                });
                              }
                              else{
                                print("Success");
                                setState(() {
                                  isError = false;
                                  isTapped = true;
                                  spinEnabled = false;
                                });
                              }
                            });
                          }
                      ),
                    ),
                   SizedBox(height: 20.0,),
                   (isTapped) ? BarChartApplication(first_perc , sec_perc , third_perc , fourth_perc) : SizedBox(
                     child: (isError) ? AlertDialog(
                       elevation: 15.0,
                       backgroundColor: Color.fromRGBO(58,66,86,1.0),
                       title: Text("WARNING : Subject Code entered is either wrong or doesn't exist."),
                       actions: <Widget>[],
                     ) : SizedBox()
                   )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class Bar extends StatelessWidget {
  // ...
  final double height;
  final String label;
  final double perc;

  final int _baseDurationMs = 1000;
  final double _maxElementHeight = 500;

  Bar(this.height, this.label, this.perc);

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return ControlledAnimation(
      duration: Duration(milliseconds: (height * _baseDurationMs).round()),
      tween: Tween(begin: 0.0, end: height),
      builder: (context, animatedHeight) {
        return Column(
          children: <Widget>[
            Container(
              color: Colors.pink,
              height: (1 - animatedHeight) * _maxElementHeight,
            ),
            Text("${double.parse((perc*100).toStringAsFixed(2))}%" , style: TextStyle(color: Colors.white),),
            SizedBox(height : 5.0),
            Container(
              width: 50,
              height: animatedHeight * _maxElementHeight,
              color: Colors.teal[400],
            ),
            SizedBox(height: 11.0,),
            Text(label,style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),)
          ],
        );
      },
    );
  }
}


class BarChartApplication extends StatelessWidget {

  final double one;
  final double two;
  final double three;
  final double four;
  BarChartApplication(
  this.one , this.two , this.three ,this.four
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Color.fromRGBO(58, 66, 86, 1.0),
        elevation: 8.0,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Bar(one, "0-25%" , one),
              Bar(two, "25-50%" , two),
              Bar(three, "50-75%" , three),
              Bar(four, "75-100%" , four),
            ],
          ),
        ),
      ),
    );
  }
}