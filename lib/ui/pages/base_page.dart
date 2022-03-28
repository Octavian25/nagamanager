part of 'pages.dart';

class BasePage extends StatelessWidget {
  Widget child;
  BasePage({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLoading = Provider.of<LoadingProvider>(context).isLoading;
    return Scaffold(
      body: Stack(
        children: [
          child,
          isLoading
              ? ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      color: Colors.white30,
                      child: Center(
                        child: SizedBox(
                          height: 250.h,
                          width: 250.w,
                          child: Lottie.asset("assets/loader.json"),
                        ),
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
