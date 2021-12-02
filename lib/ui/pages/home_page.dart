part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> barang = [1300, 1400, 1500, 1600,1700,2800, 3914, 1923, 19483];

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: background,
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Container(
              height: 100.h,
              width: 100.sw,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Selamat Datang,", style: titleText.copyWith(fontWeight: FontWeight.w200),),
                      Text("Octavian", style: titleText,),
                      SizedBox(
                        height: 15.h,
                      ),
                      Container(
                        height: 30.h,
                        width: 150.w,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: red,
                            onPrimary: white
                          ),
                          onPressed: () => {},
                          child: Row(
                            children: [
                              Text("Logout", style: normalText,),
                              SizedBox(
                                width: 29.w,
                              ),
                              Image.asset("assets/logo-logout.png", scale: 1.3,)
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
                  Container(
                    width: 160.w,
                    height: 150.w,
                    decoration: BoxDecoration(
                      color: blue,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Image.asset("assets/logo-box.png", width: 30.w, height: 34.h,),
                        Container(
                          height: 54.w,
                          width: 78.w,
                          child: Text("3.2K", style: bigText.copyWith(color: Colors.white),),
                        ),
                        Text("Total In", style: normalText.copyWith(color: Colors.white),)
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
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Image.asset("assets/logo-box.png", width: 30.w, height: 34.h,),
                        Container(
                          height: 54.w,
                          width: 78.w,
                          child: Text("3.2K", style: bigText.copyWith(color: Colors.white),),
                        ),
                        Text("Total Out", style: normalText.copyWith(color: Colors.white),)
                      ],
                    ),
                  )
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
                  Container(
                    height: 30.h,
                    width: 873.w,
                    margin: EdgeInsets.only(bottom: 10.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: grey, width: 1),
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
                  Expanded(
                    child: GridView.count(
                      shrinkWrap: true,
                      childAspectRatio: 50.sw / 10000,
                      crossAxisCount: 3, children: dummyItemModel.map((e) => ItemCard(itemModel: e)).toList(), crossAxisSpacing: 15.h, mainAxisSpacing: 15.w, ),
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
