part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var searchResult = "";
  TextEditingController search = TextEditingController();

  void updateData() async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    ItemProvider itemProvider =
        Provider.of<ItemProvider>(context, listen: false);
    ChartProvider chartProvider =
        Provider.of<ChartProvider>(context, listen: false);
    LocationProvider locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    await itemProvider.getProject(authProvider.user!.accessToken);
    await itemProvider.getTotalIn(authProvider.user!.accessToken);
    await itemProvider.getTotalOut(authProvider.user!.accessToken);
    await locationProvider.getAllLocation(authProvider.user!.accessToken);
    await chartProvider.getItemInfo(authProvider.user!.accessToken);
    locationProvider.checkLastLocation();

    if (await chartProvider.getDashboardChart(authProvider.user!.accessToken)) {
      if (await chartProvider.getItemInfo(authProvider.user!.accessToken)) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    ItemProvider itemProvider = Provider.of<ItemProvider>(context);
    return LayoutBuilder(builder: (context, constrains) {
      if (constrains.maxWidth < 600) {
        return SafeArea(
            child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                SizedBox(
                  height: 55.h,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16.w,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: "#E8ECF2".toColor(), elevation: 0),
                        child: Row(
                          children: [
                            Icon(Iconsax.arrow_square_left,
                                color: text, size: 20),
                          ],
                        ),
                        onPressed: () async {
                          String token =
                              Provider.of<AuthProvider>(context, listen: false)
                                  .user!
                                  .accessToken;
                          ChartProvider chart = Provider.of<ChartProvider>(
                              context,
                              listen: false);
                          if (await chart.getDashboardChart(token)) {
                            updateData();
                            Navigator.pushNamed(context, "/dashboard");
                          } else {
                            showToast("Ambil Data Terbaru Gagal", false);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 130.h,
                  width: 100.sw,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/tracking",
                              arguments: true);
                        },
                        child: Container(
                          width: 100.h,
                          height: 100.h,
                          decoration: BoxDecoration(
                              color: blue,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/stock-in.png",
                                width: 30.h,
                                height: 30.h,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                "Track In",
                                style: normalTextMobile.copyWith(
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 18.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/tracking",
                              arguments: false);
                        },
                        child: Container(
                          width: 100.h,
                          height: 100.h,
                          decoration: BoxDecoration(
                              color: red,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/stock-out.png",
                                width: 30.h,
                                height: 30.h,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                "Track Out",
                                style: normalTextMobile.copyWith(
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(top: 10.h),
                  padding: EdgeInsets.all(10.h),
                  decoration: BoxDecoration(
                      border: Border.all(color: "#DAE7F0".toColor()),
                      borderRadius: BorderRadius.circular(15),
                      color: white),
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
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                            child: Row(
                          children: [
                            SizedBox(
                              width: 25.w,
                            ),
                            SizedBox(
                              width: 26.w,
                              child: Icon(
                                Icons.search,
                                size: 40.w,
                              ),
                            ),
                            SizedBox(
                              width: 25.w,
                            ),
                            Expanded(
                              child: TextFormField(
                                style: normalTextMobile,
                                controller: search,
                                onChanged: (data) => {
                                  setState(() {
                                    searchResult = search.text;
                                  })
                                },
                                decoration: InputDecoration.collapsed(
                                  hintText: "Search",
                                  hintStyle: normalTextMobile,
                                ),
                              ),
                            ),
                          ],
                        )),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      Expanded(
                        child: itemProvider.item!.isEmpty
                            ? SizedBox(
                                width: 100.sw,
                                height: 100.sh,
                                child: Column(
                                  children: [
                                    Expanded(
                                        child: Lottie.asset(
                                            "assets/empty_state.json")),
                                    Text(
                                        'Barang Masih Kosong, Silahkan Tambahkan Barang Dahulu',
                                        style: normalText.copyWith(
                                            fontSize: 18.sp)),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 10.h,
                                ),
                                shrinkWrap: true,
                                itemBuilder: (context, index) => ItemCardMobile(
                                    itemModel: itemProvider.item!
                                        .where((element) => element.name
                                            .toLowerCase()
                                            .contains(
                                                searchResult.toLowerCase()))
                                        .toList()[index]),
                                itemCount: itemProvider.item!
                                    .where((element) => element.name
                                        .toLowerCase()
                                        .contains(searchResult.toLowerCase()))
                                    .length,
                              ),
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
        ));
      } else {
        return SafeArea(
            child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                SizedBox(
                  height: 55.h,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16.w,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: "#E8ECF2".toColor(), elevation: 0),
                        child: Row(
                          children: [
                            Icon(Iconsax.arrow_square_left,
                                color: text, size: 20),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              'Back',
                              style: normalText.copyWith(color: text),
                            )
                          ],
                        ),
                        onPressed: () async {
                          String token =
                              Provider.of<AuthProvider>(context, listen: false)
                                  .user!
                                  .accessToken;
                          ChartProvider chart = Provider.of<ChartProvider>(
                              context,
                              listen: false);
                          if (await chart.getDashboardChart(token)) {
                            updateData();
                            Navigator.pushNamed(context, "/dashboard");
                          } else {
                            showToast("Ambil Data Terbaru Gagal", false);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 150.h,
                  width: 100.sw,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/tracking",
                              arguments: true);
                        },
                        child: Container(
                          width: 160.w,
                          height: 150.w,
                          decoration: BoxDecoration(
                              color: blue,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/stock-in.png",
                                width: 60.w,
                                height: 76.h,
                              ),
                              SizedBox(
                                height: 19.h,
                              ),
                              Text(
                                "Track In",
                                style: normalText.copyWith(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 18.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/tracking",
                              arguments: false);
                        },
                        child: Container(
                          width: 160.w,
                          height: 150.w,
                          decoration: BoxDecoration(
                              color: red,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/stock-out.png",
                                width: 60.w,
                                height: 76.h,
                              ),
                              SizedBox(
                                height: 19.h,
                              ),
                              Text(
                                "Track Out",
                                style: normalText.copyWith(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),

                      // Container(
                      //   width: 160.w,
                      //   height: 150.w,
                      //   decoration: BoxDecoration(
                      //       color: blue, borderRadius: BorderRadius.circular(15)),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Image.asset(
                      //         "assets/logo-box.png",
                      //         width: 30.w,
                      //         height: 34.h,
                      //       ),
                      //       Text(
                      //         itemProvider.totalIn.toString(),
                      //         style: bigText.copyWith(color: Colors.white),
                      //       ),
                      //       Text(
                      //         "Monthly Stock In",
                      //         style: normalText.copyWith(color: Colors.white),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   width: 18.w,
                      // ),
                      // Container(
                      //   width: 160.w,
                      //   height: 150.w,
                      //   decoration: BoxDecoration(
                      //       color: red, borderRadius: BorderRadius.circular(15)),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Image.asset(
                      //         "assets/logo-box.png",
                      //         width: 30.w,
                      //         height: 34.h,
                      //       ),
                      //       Text(
                      //         itemProvider.totalOut.toString(),
                      //         style: bigText.copyWith(color: Colors.white),
                      //       ),
                      //       Text(
                      //         "Monthly Stock Out",
                      //         style: normalText.copyWith(color: Colors.white),
                      //       )
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(top: 10.h),
                  padding: EdgeInsets.all(10.h),
                  decoration: BoxDecoration(
                      border: Border.all(color: "#DAE7F0".toColor()),
                      borderRadius: BorderRadius.circular(15),
                      color: white),
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
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                            child: Row(
                          children: [
                            SizedBox(
                              width: 25.w,
                            ),
                            SizedBox(
                              width: 26.w,
                              child: Icon(
                                Icons.search,
                                size: 25.w,
                              ),
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
                        )),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      Expanded(
                        child: itemProvider.item!.isEmpty
                            ? SizedBox(
                                width: 100.sw,
                                height: 100.sh,
                                child: Column(
                                  children: [
                                    Expanded(
                                        child: Lottie.asset(
                                            "assets/empty_state.json")),
                                    Text(
                                        'Barang Masih Kosong, Silahkan Tambahkan Barang Dahulu',
                                        style: normalText.copyWith(
                                            fontSize: 18.sp)),
                                  ],
                                ),
                              )
                            : GridView.count(
                                shrinkWrap: true,
                                childAspectRatio: 271.w / 130.h,
                                crossAxisCount: 3,
                                children: itemProvider.item!
                                    .where((element) => element.name
                                        .toLowerCase()
                                        .contains(searchResult.toLowerCase()))
                                    .map((e) => ItemCard(itemModel: e))
                                    .toList(),
                                crossAxisSpacing: 15.h,
                                mainAxisSpacing: 15.w,
                              ),
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
        ));
      }
    });
  }
}
