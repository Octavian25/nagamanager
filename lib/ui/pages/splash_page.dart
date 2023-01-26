part of 'pages.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () => {context.go('/login')});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZoomIn(
        child: Center(
          child: Image.asset(
            "assets/logo.png",
            width: 291.w,
            height: 232.h,
          ),
        ),
      ),
    );
  }
}
