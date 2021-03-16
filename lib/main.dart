import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:subsbooster/constant.dart';
import 'package:subsbooster/screens/MembershipScreen.dart';
import 'package:subsbooster/screens/bottomnavigationbar.dart';
import 'package:subsbooster/screens/buyPoints.dart';
import 'package:subsbooster/screens/campaign.dart';
import 'package:subsbooster/screens/signinwithgoogle.dart';
import 'package:subsbooster/screens/splash_screen.dart';
import 'package:subsbooster/screens/userProfile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: KSecondaryColor,
      statusBarIconBrightness: Brightness.dark,
    ));
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(child: Text('Error ${snapshot.hasError.toString()}'));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: true,
            debugShowMaterialGrid: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              accentColor: KSecondaryColor,
              // fontFamily: "",
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: KPrimaryColor,
              appBarTheme: AppBarTheme(
                color: KSecondaryColor,
              ),
              cardTheme: CardTheme(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              buttonTheme: ButtonThemeData(
                  buttonColor: KSecondaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),
                  )
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            initialRoute: "splash_screen",
            getPages:
            [
              GetPage(name: "splash_screen", page: () => SplashScreen()),
              GetPage(name: "userProfile", page: () => UserProfile()),
              GetPage(name: "signinwithgoogle", page: () => SignWithGoogle()),
              GetPage(name: 'bottomNavigationBar', page: ()=>BottomNavigationBarScreen(),),
              GetPage(name: "buyPoints", page:()=> BuyPointsScreen()),
              GetPage(name: "membership", page: ()=>MembershipScreen()),
              //GetPage(name: "campaign_start", page: ()=>CampaignScreen()),
            ],
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }
}

