import 'package:cp_project/loginscreen.dart';
import 'package:cp_project/mainscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  late SharedPreferences sharedPreferences;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(

        child: Padding(
          padding:  EdgeInsets.only(top: screenHeight/5),
          child: Column(


            children: [

              Container(
                child: Center(
                  child: Image.asset('assets/logo.png',
                    scale: 3,),

                ),

              ),
                          Container(
                padding: EdgeInsets.all(30),
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top:32),
                child: Text(
                  "Sucessful Attendance",
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: "NexaBold",
                    fontSize: screenWidth/15,
                  ),
                ),
              ),
SizedBox(height: screenHeight/10,),
              Center(

                child:

                 GestureDetector(
                   onTap: () async {
                     SharedPreferences sharedPreferences =
                     await SharedPreferences.getInstance();
                     sharedPreferences.clear();
                     Navigator.pushReplacement(
                         context,
                         MaterialPageRoute(
                             builder: (context) => const LoginScreen()));
                   },


                   child: Container(

                    height: 60,
                    width: screenWidth/2,
                    margin: EdgeInsets.only(top: screenHeight/40),
                    decoration: BoxDecoration(
                      color:Colors.red,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Center(
                      child: Text(
                        "LogOut",
                        style: TextStyle(
                          fontFamily: "NexaBold",
                          fontSize: screenWidth/26,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                ),
                 ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
