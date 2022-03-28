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
  Widget build(BuildContext context) {
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
                      "assets/login-logo.png",
                      width: 40.w,
                      height: 40.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Center(
                      child: Text(
                    "SMART WAREHOUSE",
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
                          padding: EdgeInsets.only(left: 30.w),
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
                          padding: EdgeInsets.only(left: 30.w),
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
                        onPressed: () async {
                          AuthProvider authProvider =
                              Provider.of<AuthProvider>(context, listen: false);
                          ItemProvider itemProvider =
                              Provider.of<ItemProvider>(context, listen: false);
                          ChartProvider chartProvider =
                              Provider.of<ChartProvider>(context,
                                  listen: false);
                          setState(() {
                            isLoading = true;
                          });
                          if (await authProvider.login(
                              username: usernameController.text,
                              password: passwordController.text)) {
                            setState(() {
                              isLoading = false;
                            });
                            await itemProvider
                                .getProject(authProvider.user!.accessToken);
                            await itemProvider
                                .getTotalIn(authProvider.user!.accessToken);
                            await itemProvider
                                .getTotalOut(authProvider.user!.accessToken);

                            if (await chartProvider.getDashboardChart(
                                authProvider.user!.accessToken)) {
                              if (await chartProvider.getItemInfo(
                                  authProvider.user!.accessToken)) {
                                Navigator.pushNamed(context, "/dashboard");
                              }
                            }
                          } else {
                            showToast(
                                "Login Gagal, Silahkan Check Username dan Password anda",
                                true);
                            setState(() {
                              isLoading = false;
                            });
                          }
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
}
