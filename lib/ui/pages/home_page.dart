part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var searchResult = "";
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ItemProvider itemProvider = Provider.of<ItemProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return SafeArea(child: Scaffold(
      backgroundColor: background,
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Container(
              height: 150.h,
              width: 100.sw,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Selamat Datang,", style: titleText.copyWith(fontWeight: FontWeight.w200),),
                      Text(authProvider.user!.username, style: titleText,),
                      SizedBox(
                        height: 15.h,
                      ),
                      Container(
                        height: 45.h,
                        width: 129.w,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: red,
                              onPrimary: white
                          ),
                          onPressed: () => {
                            Navigator.pushNamed(context, "/login")
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Logout", style: normalText,),

                              Image.asset("assets/logo-logout.png", scale: 1,)
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/tracking", arguments: true);
                    },
                    child: Container(
                      width: 160.w,
                      height: 150.w,
                      decoration: BoxDecoration(
                          color: blue,
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/stock-in.png", width: 60.w, height: 76.h,),
                          SizedBox(
                            height: 19.h,
                          ),
                          Text("Track In", style: normalText.copyWith(color: Colors.white),)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 18.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/tracking", arguments: false);
                    },
                    child: Container(
                      width: 160.w,
                      height: 150.w,
                      decoration: BoxDecoration(
                          color: red,
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/stock-out.png", width: 60.w, height: 76.h,),
                          SizedBox(
                            height: 19.h,
                          ),
                          Text("Track Out", style: normalText.copyWith(color: Colors.white),)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 18.w,
                  ),
                  Container(
                    width: 160.w,
                    height: 150.w,
                    decoration: BoxDecoration(
                        color: blue,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/logo-box.png", width: 30.w, height: 34.h,),
                        Text(itemProvider.totalIn.toString(), style: bigText.copyWith(color: Colors.white),),
                        Text("Monthly Stock In", style: normalText.copyWith(color: Colors.white),)
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 18.w,
                  ),
                  Container(
                    width: 160.w,
                    height: 150.w,
                    decoration: BoxDecoration(
                        color: red,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/logo-box.png", width: 30.w, height: 34.h,),
                        Text(itemProvider.totalOut.toString(), style: bigText.copyWith(color: Colors.white),),
                        Text("Monthly Stock Out", style: normalText.copyWith(color: Colors.white),)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child:
            Container(
              margin: EdgeInsets.only(top: 10.h),
              padding: EdgeInsets.all(10.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: white
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 16.h,
                  ),
                  Container(
                    height: 45.h,
                    width: 873.w,
                    margin: EdgeInsets.only(bottom: 10.h),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26, width: 1),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 25.w,
                            ),
                            Container(
                              width: 26.w,
                              child: Icon(Icons.search, size: 25.w,),
                            ),
                            SizedBox(
                              width: 25.w,
                            ),
                            Expanded(
                              child: TextFormField(
                                style: normalText,
                                controller: search,
                                onChanged: (data) => {
                                setState(() {
                                searchResult = search.text;
                                })
                                },
                                decoration: InputDecoration.collapsed(
                                  hintText: "Search",
                                  hintStyle: normalText,
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  Expanded(
                    child: GridView.count(
                      shrinkWrap: true,
                      childAspectRatio: 271.w/130.h,
                      crossAxisCount: 3, children: itemProvider.item!.where((element) => element.name.toLowerCase().contains(searchResult.toLowerCase())).map((e) => ItemCard(itemModel: e)).toList(), crossAxisSpacing: 15.h, mainAxisSpacing: 15.w, ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    ));
  }
}

