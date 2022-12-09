import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_project/loginscreen.dart';


import 'package:cp_project/model/user.dart';
import 'package:cp_project/pages/home.dart';
import 'package:cp_project/profilescreen.dart';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';



class TodayScreen extends StatefulWidget {
  const TodayScreen({Key? key}) : super(key: key);

  @override
  _TodayScreenState createState() => _TodayScreenState();

}

class _TodayScreenState extends State<TodayScreen> {
  TextEditingController idController = TextEditingController();
  late SharedPreferences sharedPreferences;
  double screenHeight = 0;
  double screenWidth = 0;

  String checkIn = "--/--";
  String checkOut = "--/--";
  String location = " ";

  Color primary = Colors.lightBlue;
  @override
  void initState() {

    super.initState();
    _getLocation();
    _getRecord();
  }

  void _getLocation() async{
    List<Placemark> placemark = await placemarkFromCoordinates(User.lat, User.long);
    setState(() {
      location = "${placemark[0].street}, ${placemark[0].subAdministrativeArea},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}";
    });
  }

  void _getRecord()async{
    try{





      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("student")
          .where('id',isEqualTo: User.studentId)
          .get();



    
      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection("student")
          .doc(snap.docs[0].id)
          .collection("Record")
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .get();



      setState(() {
        checkIn = snap2['checkIn'];
        checkOut = snap2['checkOut'];
      });

    }
    catch(e){
      setState(() {

        checkIn = "--/--";
        checkOut = "--/--";
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [


            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top:32),
              child: Text(
                "Welcome",
                style: TextStyle(
                  color: Colors.black54,
                  fontFamily: "NexaRegular",
                  fontSize: screenWidth/20,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,

              child: Text(
                "Students"+ User.studentId,
                style: TextStyle(
                  color: Colors.black54,
                  fontFamily: "NexaBold",
                  fontSize: screenWidth/18,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top:32),
              child:StreamBuilder(
                stream: FirebaseFirestore.instance.collection("admin").snapshots(),
                builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.hasData){
                    var data = snapshot.data!.docs[0];

                    return    Text("Todays Code "+ data['code'],
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: "NexaBold",
                        fontSize: screenWidth/18,
                      ),
                    );
                  }else{
                    return CircularProgressIndicator();
                  }

                },


              ),





            ),

            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 32),
             height: 150,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Attend In",
                      style: TextStyle(
                        fontFamily: "NexaRegular",
                        fontSize: screenWidth/20,
                        color: Colors.black54,
                      ),

                      ),
                      Text(checkIn,
                        style: TextStyle(
                          fontFamily: "NexaBold",
                          fontSize: screenWidth/18,

                        ),

                      ),
                    ],
                  ),
                  ),

                  Expanded(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Attend Out",
                        style: TextStyle(
                          fontFamily: "NexaRegular",
                          fontSize: screenWidth/20,
                          color: Colors.black54,
                        ),
                      ),
                      Text(checkOut,
                        style: TextStyle(
                          fontFamily: "NexaBold",
                          fontSize: screenWidth/18,

                        ),

                      ),
                    ],
                  ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child:RichText(
               text: TextSpan(
                 text: DateTime.now().day.toString(),
                 style: TextStyle(
                   color:primary,
                   fontSize: screenWidth/18,
                 ),
                 children: [
                   TextSpan(
                     text: DateFormat('  MMMM yyyy').format(DateTime.now()),
                     style: TextStyle(
                       fontFamily: "NexaBold",
                       color: Colors.black,
                       fontSize: screenWidth/20,
                     )
                   )
                 ]
               ),
              )

            ),
            StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot){
                 return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DateFormat('hh:mm:ss a').format(DateTime.now()),
                      style: TextStyle(
                        fontFamily: "NexaRegular",
                        fontSize: screenWidth/18,
                        color: Colors.black54,

                      ),

                    ),

                  );

                }),

            checkOut == "--/--" ? Container(
              margin: const EdgeInsets.only(top: 24,bottom: 12),
              child: Builder(
                builder: (context){
                  final GlobalKey<SlideActionState> key = GlobalKey();
                  return SlideAction(
text:checkIn== "--/--" ? "Slide to Check In":"Slide to Check out",
                    textStyle: TextStyle(
                      color: Colors.black54,
                      fontSize: screenWidth/18,
                      fontFamily: "NexaRegular",

                    ),
                    outerColor: Colors.white,
                    innerColor: primary,
                    key: key,
                    onSubmit: ()async{

                      if(User.lat != 0){
                        _getLocation();
                        QuerySnapshot snap = await FirebaseFirestore.instance
                            .collection("student")
                            .where('id',isEqualTo: User.studentId)
                            .get();
                        print(snap.docs[0].id);

                        DocumentSnapshot snap2 = await FirebaseFirestore.instance
                            .collection("student")
                            .doc(snap.docs[0].id)
                            .collection("Record")
                            .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                            .get();


                        try{


                          String checkIn = snap2['checkIn'];

                          setState(() {
                            checkOut = DateFormat('hh:mm').format(DateTime.now());
                          });

                          await FirebaseFirestore.instance.collection("student")
                              .doc(snap.docs[0].id)
                              .collection("Record").doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                              .update({
                            'checkIn': checkIn,
                            'checkOut': DateFormat('hh:mm').format(DateTime.now()),
                            'checkInLocation' : location,
                          });

                        }
                        catch(e){
                          setState(() {
                            checkIn = DateFormat('hh:mm').format(DateTime.now());
                          });

                          await FirebaseFirestore.instance.collection("student")
                              .doc(snap.docs[0].id)
                              .collection("Record").doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                              .set({
                            'checkIn': DateFormat('hh:mm').format(DateTime.now()),
                            'checkOut': "--/--",
                            'checkOutLocation' : location,
                          });


                        }
                        key.currentState!.reset();



                      }else{
                        Timer(const Duration(seconds: 3),() async {

                          _getLocation();
                          QuerySnapshot snap = await FirebaseFirestore.instance
                              .collection("student")
                              .where('id',isEqualTo: User.studentId)
                              .get();
                          print(snap.docs[0].id);

                          DocumentSnapshot snap2 = await FirebaseFirestore.instance
                              .collection("student")
                              .doc(snap.docs[0].id)
                              .collection("Record")
                              .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                              .get();


                          try{


                            String checkIn = snap2['checkIn'];

                            setState(() {
                              checkOut = DateFormat('hh:mm').format(DateTime.now());
                            });

                            await FirebaseFirestore.instance.collection("student")
                                .doc(snap.docs[0].id)
                                .collection("Record").doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                                .update({
                              'checkIn': checkIn,
                              'checkOut': DateFormat('hh:mm').format(DateTime.now()),
                              'checkInLocation' : location,
                            });

                          }
                          catch(e){
                            setState(() {
                              checkIn = DateFormat('hh:mm').format(DateTime.now());
                            });

                            await FirebaseFirestore.instance.collection("student")
                                .doc(snap.docs[0].id)
                                .collection("Record").doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                                .set({
                              'checkIn': DateFormat('hh:mm').format(DateTime.now()),
                              'checkOut': "--/--",
                              'checkOutLocation' : location,
                            });


                          }
                          key.currentState!.reset();

                        });
                      }


                    },

                  );
                },
              ),
            ): Container(
              margin: const EdgeInsets.only(top: 32,bottom: 32),
              child: Text("You have completed your attandance today"
              ,
              style: TextStyle(fontFamily: "NexaRegular",
              fontSize: screenWidth/20,
                color: Colors.black54,

              ),),

            ),
            location !=" " ? Text(
              "Location: " + location,
            ): const SizedBox(),




            SizedBox(height: screenHeight/15,),

            fieldTitle("Attendance Code"),
            customField("enter unique code",idController,false),
            GestureDetector(
              onTap: ()async{
                FocusScope.of(context).unfocus();
                String id = idController.text.trim();


                if(id.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Enrollment id is empty"),));

                }

                else{
                  QuerySnapshot snap = await FirebaseFirestore.instance
                      .collection("admin").where('code', isEqualTo: id).get();

                  try{
                    if(id == snap.docs[0]['code']){
                      sharedPreferences = await SharedPreferences.getInstance();
                      sharedPreferences.setString('studentscode', id).then((_){

                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) =>ProfileScreen()));
                      });

                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
                        content: const Text("code is not correct"),));
                    }
                  }catch(e){

                    String error = "";

                    if(e.toString() =="RangeError (index): Invalid value: Valid value range is empty: 0"){

                      setState(() {
                        error = "employee id does not exist";
                      });


                    }
                    else {
                      setState(() {
                        error = "error occured !";
                      });

                    }
                    ScaffoldMessenger.of(context).showSnackBar(  SnackBar(
                      content: Text(error),));


                  }
                }
              },
              child: Container(
                height: 60,
                width: screenWidth,
                margin: EdgeInsets.only(top: screenHeight/40),
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                ),
                child: Center(
                  child: Text(
                    "Submit Unique Code",
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



          ],




        ),
      )
    );
  }
  Widget fieldTitle(String title){
    return
      Container(

        margin:const EdgeInsets.only(bottom: 12),
        child: Text(title,
          style:TextStyle(
            fontSize: screenWidth/18,
            fontFamily: "NexaBold",
          ),
        ),
      );
  }


  Widget customField(String hint, TextEditingController controller,bool obscure){
    return   Container(
      width: screenWidth,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(2,2),

          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: screenWidth/6,
            child: Icon(
              Icons.person,
              color: primary,
              size: screenWidth/15,
            ),
          ),
          Expanded(
            child: Padding(
              padding:  EdgeInsets.only(right: screenWidth/12),
              child: TextFormField(
                controller: controller,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight/35,
                  ),
                  border: InputBorder.none,
                  hintText: hint,
                ),
                maxLines: 1,
                obscureText: obscure,
              ),
            ),
          )
        ],

      ),
    );
  }
}
