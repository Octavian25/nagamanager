import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nagamanager/providers/chart_provider.dart';
import 'package:nagamanager/providers/loading_provider.dart';
import 'package:nagamanager/providers/location_provider.dart';
import 'package:nagamanager/providers/providers.dart';
import 'package:nagamanager/providers/tracking_provider.dart';
import 'package:nagamanager/ui/pages/pages.dart';
import 'package:nagamanager/ui/widgets/pdf_creator.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp();
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://8e8149eb0b784b98a9cc96332a2ef76d@o922577.ingest.sentry.io/6413966';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StockingProvider(null)),
        ChangeNotifierProvider(create: (context) => TrackingProvider(null)),
        ChangeNotifierProvider(create: (context) => LoadingProvider()),
        ChangeNotifierProxyProvider<LoadingProvider, AuthProvider?>(
            create: (context) => AuthProvider(),
            update: (context, loading, auth) => auth!..update(loading)),
        ChangeNotifierProxyProvider<LoadingProvider, ItemProvider?>(
            create: (context) => ItemProvider(),
            update: (context, loading, item) => item!..update(loading)),
        ChangeNotifierProxyProvider<LoadingProvider, ChartProvider?>(
            create: (context) => ChartProvider(),
            update: (context, loading, chart) => chart!..update(loading)),
        ChangeNotifierProxyProvider<LoadingProvider, LocationProvider?>(
            create: (context) => LocationProvider(),
            update: (context, loading, location) => location!..update(loading))
      ],
      child: ScreenUtilInit(
          designSize: const Size(1024, 768),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: () => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'NagaManager',
                theme: ThemeData(
                    primarySwatch: Colors.blue,
                    textTheme: GoogleFonts.poppinsTextTheme()),
                builder: (context, widget) {
                  //add this line
                  ScreenUtil.setContext(context);
                  return MediaQuery(
                    //Setting font does not change with system font size
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: widget!,
                  );
                },
                routes: {
                  '/': (context) => BasePage(child: const SplashPage()),
                  '/login': (context) => BasePage(child: const LoginPage()),
                  '/home': (context) => BasePage(child: const HomePage()),
                  '/stocking': (context) =>
                      BasePage(child: const StockingPage()),
                  '/tracking': (context) =>
                      BasePage(child: const TrackingPage()),
                  '/tracking-camera': (context) =>
                      BasePage(child: const TrackingPageCamera()),
                  '/detail-chart': (context) =>
                      BasePage(child: const DetailChartPage()),
                  '/dashboard': (context) =>
                      BasePage(child: const DashboardPage()),
                  '/detail-stock': (context) =>
                      BasePage(child: const DetailStockPage()),
                  "/create-pdf": (context) =>
                      const GeneratePDFWidget("GeneratePDF"),
                  "/location": (context) =>
                      BasePage(child: const LocationPage())
                },
              )),
    );
  }
}
