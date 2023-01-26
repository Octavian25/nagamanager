import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nagamanager/models/item_model.dart';
import 'package:nagamanager/models/stocking_argumen_model.dart';
import 'package:nagamanager/providers/category_provider.dart';
import 'package:nagamanager/providers/chart_provider.dart';
import 'package:nagamanager/providers/loading_provider.dart';
import 'package:nagamanager/providers/location_provider.dart';
import 'package:nagamanager/providers/providers.dart';
import 'package:nagamanager/providers/sub_category_provider.dart';
import 'package:nagamanager/providers/tracking_provider.dart';
import 'package:nagamanager/ui/pages/pages.dart';
import 'package:nagamanager/ui/widgets/pdf_creator.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://8e8149eb0b784b98a9cc96332a2ef76d@o922577.ingest.sentry.io/6413966';
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
    var goroutes = GoRouter(initialLocation: '/', urlPathStrategy: UrlPathStrategy.path, routes: [
      GoRoute(path: "/", builder: (context, state) => BasePage(child: const SplashPage()), routes: [
        GoRoute(
          path: 'login',
          builder: (context, state) => BasePage(child: const LoginPage()),
        ),
        GoRoute(
            path: 'dashboard',
            builder: (context, state) => BasePage(child: const DashboardPage()),
            routes: [
              GoRoute(
                path: 'detail-chart',
                builder: (context, state) => BasePage(child: const DetailChartPage()),
              ),
              GoRoute(
                path: 'detail-stock',
                builder: (context, state) =>
                    BasePage(child: DetailStockPage(isStockIn: state.extra as bool)),
              ),
              GoRoute(
                  path: 'home',
                  builder: (context, state) => BasePage(child: const HomePage()),
                  routes: [
                    GoRoute(
                      path: 'tracking-camera',
                      builder: (context, state) => BasePage(
                          child: TrackingPageCamera(
                        trackingIn: state.extra as bool,
                      )),
                    ),
                    GoRoute(
                      path: 'tracking',
                      builder: (context, state) => BasePage(child: const TrackingPage()),
                    ),
                    GoRoute(
                      path: 'edit-item',
                      builder: (context, state) => BasePage(
                          child: EditItemPage(
                        itemModel: state.extra as ItemModel,
                      )),
                    ),
                    GoRoute(
                      path: 'stocking',
                      builder: (context, state) => BasePage(
                          child: StockingPage(
                        stockargumen: state.extra as StockingArgumenModel,
                      )),
                    ),
                  ]),
              GoRoute(
                path: 'category',
                builder: (context, state) => BasePage(child: const CategoryPage()),
              ),
              GoRoute(
                path: 'sub-category',
                builder: (context, state) => BasePage(child: const SubCategoryPage()),
              ),
              GoRoute(
                path: 'location',
                builder: (context, state) => BasePage(child: const LocationPage()),
              ),
              GoRoute(
                path: 'create-pdf',
                builder: (context, state) => const GeneratePDFWidget("GeneratePDF"),
              ),
            ])
      ])
    ]);
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
            update: (context, loading, location) => location!..update(loading)),
        ChangeNotifierProxyProvider<LoadingProvider, CategoryProvider?>(
            create: (context) => CategoryProvider(),
            update: (context, loading, location) => location!..update(loading)),
        ChangeNotifierProxyProvider<LoadingProvider, SubCategoryProvider?>(
            create: (context) => SubCategoryProvider(),
            update: (context, loading, location) => location!..update(loading))
      ],
      child: ScreenUtilInit(
          designSize: const Size(1024, 768),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: () => MaterialApp.router(
                routeInformationParser: goroutes.routeInformationParser,
                routerDelegate: goroutes.routerDelegate,
                routeInformationProvider: goroutes.routeInformationProvider,
                debugShowCheckedModeBanner: false,
                title: 'NagaManager',
                theme: ThemeData(
                    primarySwatch: Colors.blue, textTheme: GoogleFonts.poppinsTextTheme()),
                builder: (context, widget) {
                  //add this line
                  ScreenUtil.setContext(context);
                  return MediaQuery(
                    //Setting font does not change with system font size
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: widget!,
                  );
                },
              )),
    );
  }
}
