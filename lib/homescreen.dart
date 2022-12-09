import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_project/mainscreen.dart';
import 'package:cp_project/profilescreen.dart';
import 'package:cp_project/service/location_service.dart';
import 'package:cp_project/todayscreen.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'model/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  double screenHeight = 0;
  double screenWidth = 0;

  String id = '';
  Color primary = Colors.lightBlue;
  int currentIndex = 1;

  List<IconData> navigationIcons = [
    FontAwesomeIcons.calendar,
    FontAwesomeIcons.check,
    FontAwesomeIcons.user,
  ];
  @override
  void initState() {

    super.initState();
    _startLocationService();
    getId();
  }
  void _startLocationService()async{
    LocationService().initialize();
    LocationService().getLongitude().then((value) {
      setState(() {
        User.long = value!;
      });

      LocationService().getLatitude().then((value){
        setState(() {
          User.lat = value!;
        });
      });

    });
  }



  void getId() async{
    QuerySnapshot snap = await FirebaseFirestore.instance.collection("student")
        .where('id', isEqualTo: User.studentId).get();

    QuerySnapshot snap2 = await FirebaseFirestore.instance.collection("admin")
        .where('code', isEqualTo: User.code).get();

    setState(() {
      User.id = snap.docs[0].id;
      User.code = snap2.docs[0].id;
    });
  }

  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children:  [
          new MainScreen(),
          new TodayScreen(),
          new ProfileScreen(),

        ],
      ),
      bottomNavigationBar:Container(
        height: 70,
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: 24,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(2,2),
            ),
          ],

        ),

        child: ClipRRect(
          borderRadius: const BorderRadius.all( Radius.circular(40)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            for(int i=0; i<navigationIcons.length; i++)...<Expanded>{
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      currentIndex = i;
                    });
                  },
                  child: Container(
                    height: screenHeight,
                    width: screenWidth,
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(navigationIcons[i],
                          color: i== currentIndex? primary: Colors.black54,
                          size: i== currentIndex ? 30:22,),

                          i== currentIndex ? Container(
                            margin: EdgeInsets.only(top: 6),
                            height: 3,
                            width: 22,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(40),


                              ),
                              color: primary,
                            ),

                          ):const SizedBox()
                        ],
                      ),

                    ),
                  ),
                ),
              )
            }


            ],
          ),
        ),
      ) ,
    );
  }
}
