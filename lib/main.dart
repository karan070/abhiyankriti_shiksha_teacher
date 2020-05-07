import 'package:teacheralpine/attendance/att_list.dart';
import 'package:teacheralpine/attendance/dept_att.dart';
import 'package:teacheralpine/attendance/sem_att.dart';
import 'package:teacheralpine/profile.dart';
import 'package:teacheralpine/screens/dept.dart';
import 'package:teacheralpine/screens/semester.dart';
import 'package:teacheralpine/screens/upload.dart';
import 'package:flutter/material.dart';
import 'package:teacheralpine/loginpage.dart';
import 'package:teacheralpine/homepage.dart';
import 'package:teacheralpine/signuppage.dart';
import 'package:teacheralpine/syllabus/dept_syllabus.dart';
import 'package:teacheralpine/syllabus/semester_syllabus.dart';
import 'package:teacheralpine/syllabus/uppload_syllabus.dart';
import 'package:teacheralpine/tests/quiz_analysis.dart';
import 'package:teacheralpine/tests/results.dart';
import 'package:teacheralpine/tests/stats_test.dart';
import 'package:teacheralpine/tests/upload_quiz.dart';
import 'package:teacheralpine/video_conferencing/video.dart';

import 'assignment/assignment_upload.dart';
import 'assignment/dept_assign.dart';
import 'assignment/sem_assign.dart';
import 'attendance/attendance.dart';
import 'attendance/upload_attendance.dart';

void main()=>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Color.fromRGBO(58,66,86,1.0)
      ),
      debugShowCheckedModeBanner: false,
      home: login_page(),
      routes: <String , WidgetBuilder>{
        '/landingpage' : (BuildContext context) => new MyApp(),
        '/loginpage' : (BuildContext context) => new login_page(),
        '/signup' : (BuildContext context) => new signup_page(),
        '/homepage' : (BuildContext context) => new HomePage(),
        '/department' : (BuildContext context) => new dept_page(),
        '/dept_syllabus' : (BuildContext context)=> new dept_syl_page(),
        '/upload_quiz' : (BuildContext context) => new upload_quiz(),
        '/quiz_analysis' : (BuildContext context) => new quiz_analysis(),
        '/dept_Assign' : (BuildContext context) => new dept_assign_page(),
        '/result_screen' : (BuildContext context) => new results(),
        '/profile' : (BuildContext context) => new profile(),
        '/dept_att' : (BuildContext context) => new dept_attpage(),
        '/sem_att' : (BuildContext context) => new sem_attscreen(),
        '/upload_att' : (BuildContext context) => new upload_att(),
        '/upload_attendance' : (BuildContext context) => new upload_attendance(),
        '/view_att_list' : (BuildContext context) => new view_list(),
        '/video' : (BuildContext context) => new video(),
        '/stats' : (BuildContext context) => new stats()
      },
    );
  }
}

