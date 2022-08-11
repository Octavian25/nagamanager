part of 'pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    requestPermission();
    checkLastUser();
  }

  void checkLastUser() async {
    if (await Provider.of<AuthProvider>(context, listen: false)
        .checkLastLogin()) {
      AuthProvider authProvider =
          Provider.of<AuthProvider>(context, listen: false);
      ItemProvider itemProvider =
          Provider.of<ItemProvider>(context, listen: false);
      ChartProvider chartProvider =
          Provider.of<ChartProvider>(context, listen: false);
      LocationProvider locationProvider =
          Provider.of<LocationProvider>(context, listen: false);
      setState(() {
        isLoading = true;
      });
      setState(() {
        isLoading = false;
      });
      await itemProvider.getProject(authProvider.user!.accessToken);
      await itemProvider.getTotalIn(authProvider.user!.accessToken);
      await itemProvider.getTotalOut(authProvider.user!.accessToken);
      await locationProvider.getAllLocation(authProvider.user!.accessToken);
      locationProvider.checkLastLocation();

      if (await chartProvider
          .getDashboardChart(authProvider.user!.accessToken)) {
        if (await chartProvider.getItemInfo(authProvider.user!.accessToken)) {
          Navigator.pushNamed(context, "/dashboard");
        }
      }
    } else {}
  }

  void requestPermission() async {
    var status = await Permission.storage.request();
    var statusCamera = await Permission.camera.request();
    if (status.isDenied) {
      showToast(
          "Anda Tidak Mengijinkan kami untuk mengakses penyimpanan, anda tidak bisa menyimpan data excel",
          true);
      await Permission.storage.request();
    }
    if (statusCamera.isDenied) {
      showToast(
          "Anda Tidak Mengijinkan kami untuk mengakses kamera, anda tidak bisa menggunakan seluruh feature didalam aplikasi ini",
          true);
    }
  }

  void loginHandler() async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    ItemProvider itemProvider =
        Provider.of<ItemProvider>(context, listen: false);
    ChartProvider chartProvider =
        Provider.of<ChartProvider>(context, listen: false);
    LocationProvider locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    setState(() {
      isLoading = true;
    });
    if (await authProvider.login(
        username: usernameController.text, password: passwordController.text)) {
      setState(() {
        isLoading = false;
      });
      await itemProvider.getProject(authProvider.user!.accessToken);
      await itemProvider.getTotalIn(authProvider.user!.accessToken);
      await itemProvider.getTotalOut(authProvider.user!.accessToken);
      await locationProvider.getAllLocation(authProvider.user!.accessToken);
      locationProvider.checkLastLocation();

      if (await chartProvider
          .getDashboardChart(authProvider.user!.accessToken)) {
        if (await chartProvider.getItemInfo(authProvider.user!.accessToken)) {
          Navigator.pushNamed(context, "/dashboard");
        }
      }
    } else {
      showToast("Login Gagal, Silahkan Check Username dan Password anda", true);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      if (constrains.maxWidth < 600) {
        return SafeArea(
            child: Scaffold(
          backgroundColor: white,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/login-logo.png",
                      width: 200.w,
                      height: 200.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Center(
                      child: Text(
                    "NAGATECH SMART WAREHOUSE",
                    style: titleTextMobile,
                  )),
                  SizedBox(
                    height: 10.h,
                  ),
                  Center(
                      child: Text(
                    "Smart Warehouse Mangement that is easy to use and adopt by end user for All industri",
                    style: normalTextMobile,
                    textAlign: TextAlign.center,
                  )),
                  SizedBox(
                    height: 60.h,
                  ),
                  SizedBox(
                    height: 85.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Username",
                          style: normalTextMobile,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Container(
                          height: 53.h,
                          width: 1.sw,
                          padding: EdgeInsets.only(left: 30.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: grey),
                          child: Center(
                            child: TextFormField(
                              style: normalTextMobile,
                              textInputAction: TextInputAction.next,
                              controller: usernameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Username",
                                hintStyle: normalTextMobile,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 17.h,
                  ),
                  SizedBox(
                    height: 85.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Password",
                          style: normalTextMobile,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Container(
                          height: 53.h,
                          width: 1.sw,
                          padding: EdgeInsets.only(left: 30.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: grey),
                          child: Row(children: [
                            Expanded(
                              child: TextFormField(
                                controller: passwordController,
                                style: normalTextMobile,
                                obscureText: !showPassword,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: normalTextMobile,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                              icon: Icon(!showPassword
                                  ? Iconsax.eye_slash
                                  : Iconsax.eye),
                            )
                          ]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60.h,
                  ),
                  Center(
                    child: SizedBox(
                      height: 45.h,
                      width: 1.sw,
                      child: ElevatedButton(
                        onPressed: () async {
                          loginHandler();
                        },
                        style: ElevatedButton.styleFrom(
                            primary: blue, onPrimary: white),
                        child: isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 13.w,
                                    height: 13.w,
                                    child: CircularProgressIndicator(
                                      backgroundColor: white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    "Login",
                                    style: normalTextMobile,
                                  )
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Login",
                                    style: normalTextMobile,
                                  )
                                ],
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  )
                ],
              ),
            ),
          ),
        ));
      } else {
        return SafeArea(
            child: Scaffold(
          backgroundColor: white,
          body: Row(
            children: [
              SizedBox(
                width: 630.w,
                height: 100.sh,
                child: Image.asset(
                  "assets/login-image.png",
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/logo.png",
                          width: 110.w,
                          height: 110.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Center(
                          child: Text(
                        "NAGATECH SMART WAREHOUSE",
                        style: titleText,
                      )),
                      SizedBox(
                        height: 10.h,
                      ),
                      Center(
                          child: Text(
                        "Smart Warehouse Mangement that is easy to use and adopt by end user for All industri",
                        style: normalText,
                        textAlign: TextAlign.center,
                      )),
                      SizedBox(
                        height: 67.h,
                      ),
                      SizedBox(
                        height: 85.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Username",
                              style: normalText,
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Container(
                              height: 53.h,
                              width: 309.w,
                              padding: EdgeInsets.only(left: 20.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: grey),
                              child: Center(
                                child: TextFormField(
                                  style: normalText,
                                  textInputAction: TextInputAction.next,
                                  controller: usernameController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Username",
                                    hintStyle: normalText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 17.h,
                      ),
                      SizedBox(
                        height: 85.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Password",
                              style: normalText,
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Container(
                              height: 53.h,
                              width: 309.w,
                              padding: EdgeInsets.only(left: 20.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: grey),
                              child: Row(children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: passwordController,
                                    style: normalText,
                                    obscureText: !showPassword,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle: normalText,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                  icon: Icon(!showPassword
                                      ? Iconsax.eye_slash
                                      : Iconsax.eye),
                                )
                              ]),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 76.h,
                      ),
                      Center(
                        child: SizedBox(
                          height: 45.h,
                          width: 309.w,
                          child: ElevatedButton(
                            onPressed: () {
                              loginHandler();
                            },
                            style: ElevatedButton.styleFrom(
                                primary: blue, onPrimary: white),
                            child: isLoading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 13.w,
                                        height: 13.w,
                                        child: CircularProgressIndicator(
                                          backgroundColor: white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15.w,
                                      ),
                                      Text(
                                        "Login",
                                        style: normalText,
                                      )
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Login",
                                        style: normalText,
                                      )
                                    ],
                                  ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ))
            ],
          ),
        ));
      }
    });
  }
}
