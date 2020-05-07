import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class results extends StatefulWidget {
  @override
  _resultsState createState() => _resultsState();
}


class _resultsState extends State<results> {

  QuerySnapshot result;
  TextEditingController sub_code = new TextEditingController();
  bool isTapped = false;
  bool spinEnabled = false;
  bool isError = false ;

  @override
  void initState(){
    super.initState();
  }

  getData(sub_code) async {
    result =  await Firestore.instance.collection('Result_$sub_code').getDocuments();
    if(result.documents.isNotEmpty){
      return result;
    }else{
      return null;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58,66,86,1.0),
      appBar: AppBar(
        title: Text("Results"),
        backgroundColor: Color.fromRGBO(58,66,86,1.0),
        centerTitle: true,
        elevation: 0.1,
      ),
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
        child:ListView(
          children: <Widget>[
             Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding : EdgeInsets.all(15.0),
                      child: TextFormField(
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
                    ),
                     RaisedButton(
                          color: Colors.teal,
                          elevation: 3.0,
                          splashColor: Colors.white,
                          child: (spinEnabled) ? SizedBox(width: 40.0,child: SpinKitWave(
                            color: Colors.white,
                            size: 16.0,
                          ),)
                              :Text("Get Results",style: TextStyle(color: Colors.white),),
                          onPressed: (){
                            setState(() {
                              spinEnabled = true;
                            });
                            getData(sub_code.text).then((results){
                              setState(() {
                                if(results ==  null){
                                  setState(() {
                                    spinEnabled = false;
                                    isError = true;
                                    isTapped = false;
                                  });
                                }else{
                                  setState(() {
                                    spinEnabled = false;
                                    isError = false;
                                    isTapped = true;
                                  });
                                }
                              });
                            });
                          }
                      ),
                    SizedBox(height: 12.0,),
                    (isTapped) ? _resultList() : SizedBox(
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
          ],
        ),
      )
    );
  }

  Widget _resultList(){
    if (result != null) {
      return Padding(
        padding: EdgeInsets.all(4.0),
        child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: result.documents.length,
          padding: EdgeInsets.all(5.0),
          itemBuilder: (context, i) {
            return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 7.0,
                    horizontal: 7.0,
                  ),
                height: 120.0,
                child: Stack(
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints.expand(),
                      child: new Card(
                        margin: new EdgeInsets.only(left: 25.0),
                          shape : RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(
                              color: Colors.teal,
                              width: 3.0,
                            ),
                          ),
                        color: Color.fromRGBO(58, 66, 86, 1.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 17.0),
                              Text("${result.documents[i].data['Name']}" ,style: TextStyle(
                                  color: Colors.white,fontSize: 22.0,fontWeight: FontWeight.w500
                              ),),
                              SizedBox(height: 8.0,),
                              Text("Marks : ${result.documents[i].data['Marks'].toString()}/${result.documents[i].data['Total Questions'].toString()}" ,style: TextStyle(
                                  color: Colors.white,fontSize: 17.0,fontWeight: FontWeight.w300 , fontStyle: FontStyle.italic
                              )),
                              SizedBox(height: 8.0,),
                              Text("Percentage : ${result.documents[i].data['Percentage'].toString()}%" ,style: TextStyle(
                                  color: Colors.white,fontSize: 17.0,fontWeight: FontWeight.w300 , fontStyle: FontStyle.italic
                              )),
                            ],
                          )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 25.0 , bottom: 20.0),
                      child: ClipOval(
                        child: Material(
                          color: Colors.teal, // button color
                          child:  SizedBox(width: 68, height: 68, child: Icon(Icons.person)),
                        ),
                      ),
                    )
                  ],
                )
              );
          },
        ),
      );
    } else {
      return Center(child: Text('Loading, Please wait..',style: TextStyle(
          color: Colors.white,fontSize: 17.0,fontWeight: FontWeight.bold
      ),),);
    }
  }
}
