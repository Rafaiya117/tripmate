import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trip_mate/config/app_route/router.dart';
import 'package:trip_mate/config/connectivity/no_connectivity.dart';
import 'package:trip_mate/features/splash/splash.dart';
import 'package:trip_mate/features/auths/controllers/auth_controller.dart';
import 'package:trip_mate/features/auths/controllers/ui_controller.dart';
import 'package:trip_mate/features/camera/camera.dart';
import 'package:trip_mate/features/history/history.dart';
import 'package:trip_mate/features/profile/profile.dart';
import 'package:trip_mate/features/auths/services/auth_service.dart';
import 'package:trip_mate/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en','US'),Locale('zh','CN'), Locale('zh','TW')],
      path: 'assets/translation',
      fallbackLocale: Locale('en','US'),
      child: MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

   @override
   State<MyApp> createState()=> _MyAppState();
}

class _MyAppState extends State<MyApp>{
  bool hasConnection = true;

  @override
  void initState(){
    super.initState();
    _checkConnectivity();
  Connectivity().onConnectivityChanged.listen((status){
    setState(() {
      hasConnection = status != ConnectivityResult.none;
    });
  });  
  }
 Future<void> _checkConnectivity() async{
  final status =  await Connectivity().checkConnectivity();
  setState(() {
    hasConnection =  status != ConnectivityResult.none;
  });
 }

 @override
 Widget build(BuildContext context){
  return ScreenUtilInit(
    designSize: const Size(375, 812) ,
    minTextAdapt: true,
    builder: (context, child) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SplashController()),
          ChangeNotifierProvider(create: (_) => SplashAnimationController()),
          ChangeNotifierProvider(create: (_) => AuthController()),
          ChangeNotifierProvider(create: (_) => UIController()),
          ChangeNotifierProvider(create: (_) => TripMateCameraController()),
          ChangeNotifierProvider(create: (_) => CameraUIController()),
          ChangeNotifierProvider(create: (_) => HistoryController()),
          ChangeNotifierProvider(create: (_) => HistoryDetailsController()),
          ChangeNotifierProvider(create: (_) => ProfileController()),
          ChangeNotifierProvider(create: (_) => EditProfileController()),
          ChangeNotifierProvider(create: (_) => PrivacyPolicyController()),
          ChangeNotifierProvider(create: (_) => SubscriptionController()),
          ChangeNotifierProvider(create: (_) => AuthService()),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'TripMate',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(
            textTheme: GoogleFonts.interTextTheme(),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          routerConfig: appRouter,
          builder: (context, child) {
            return hasConnection ? child! : const NoInternetConnectivityWidget();
          },
        ),
      );
    },
  );
 }
}