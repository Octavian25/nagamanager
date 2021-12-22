import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nagamanager/providers/providers.dart';
import 'package:nagamanager/providers/tracking_provider.dart';
import 'package:nagamanager/ui/pages/pages.dart';
import 'package:provider/provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ItemProvider()),
        ChangeNotifierProvider(create: (context) => StockingProvider()),
        ChangeNotifierProvider(create: (context) => TrackingProvider())
      ],
      child: ScreenUtilInit(
          designSize: Size(1024, 768),
          builder: () => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'NagaManager',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                routes: {
                  '/': (context) => const SplashPage(),
                  '/login': (context) => const LoginPage(),
                  '/home': (context) => const HomePage(),
                  '/stocking': (context) => const StockingPage(),
                  '/tracking' : (context) => const TrackingPage()
                },
              )),
    );
  }
}
