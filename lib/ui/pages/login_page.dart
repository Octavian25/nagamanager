part of 'pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: white,
      body: Row(
        children: [
          Container(
            width: 630.w,
            height: 100.sh,
            child: Image.asset("assets/login-image.png",fit: BoxFit.cover, ),
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SizedBox(
                height: 30.h,
              ),
                Center(
                  child: Container(
                    child: Image.asset("assets/login-logo.png", width: 40.w, height: 40.h,fit: BoxFit.contain,),
                  ),
                ),
              Center(child: Text("WAREMANAGER", style: titleText,)),
              Center(child: Text("Warehouse Mangement that is easy to use andadopt by end user for All industri", style: normalText, textAlign: TextAlign.center,)),
              SizedBox(
                height: 30.h,
              ),
              Text("Username", style: normalText,),
                SizedBox(
                  height: 5.h,
                ),
              Container(
                height: 35.h,
                width: 309.w,
                padding: EdgeInsets.only(left: 30.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: grey
                ),
                child: Center(
                  child: TextFormField(
                    style: normalText,
                    decoration: InputDecoration.collapsed(
                      hintText: "Username",
                      hintStyle: normalText,
                    ),
                  ),
                ),
              ),
                SizedBox(
                  height: 17.h,
                ),
                Text("Password", style: normalText,),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  height: 35.h,
                  width: 309.w,
                  padding: EdgeInsets.only(left: 30.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: grey
                  ),
                  child: Center(
                    child: TextFormField(
                      style: normalText,
                      obscureText: true,
                      decoration: InputDecoration.collapsed(
                        hintText: "Username",
                        hintStyle: normalText,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Center(
                  child: Container(
                    height: 30.h,
                    width: 309.w,
                    child: ElevatedButton(
                      onPressed: () => { Navigator.pushNamed(context, "/home")},
                      style: ElevatedButton.styleFrom(
                        primary: blue,
                        onPrimary: white
                      ),
                      child: Text("Login", style: normalText,),
                    ),
                  ),
                )
            ],),

          ))
        ],
      ),
    ));
  }
}
