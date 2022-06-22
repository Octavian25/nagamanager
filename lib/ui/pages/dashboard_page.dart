part of 'pages.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String selectedLocation = "-";
  bool isAddLocation = false;
  @override
  void initState() {
    super.initState();
  }

  void updateData() async {
    Navigator.pop(context);
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
    ChartProvider chartProvider = Provider.of<ChartProvider>(context);
    ItemProvider itemProvider = Provider.of<ItemProvider>(context);
    StockingProvider stockingProvider = Provider.of<StockingProvider>(context);
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    String token = Provider.of<AuthProvider>(context).user!.accessToken;
    return LayoutBuilder(builder: (context, constraint) {
      if (constraint.maxWidth < 600) {
        return Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                if (await itemProvider.getProject(token)) {
                  Navigator.pushNamed(context, "/home");
                }
              },
              child: Icon(Icons.qr_code_scanner),
            ),
            body: SafeArea(
                child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 40.w, right: 40.w, bottom: 40.w),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          child: Row(
                            children: [
                              Text('Dashboard', style: titleTextMobile),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  showDialog<void>(
                                    context: context,
                                    // false = user must tap button, true = tap outside dialog
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: Text('Silahkan Pilih Gudang',
                                            style: titleTextMobile),
                                        content: LocationMobileWidget(
                                            locationProvider),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Close'),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Iconsax.building),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    // false = user must tap button, true = tap outside dialog
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: Text('Apakah Anda Yakin ?',
                                            style: normalTextMobile),
                                        content: Text(
                                            'Anda akan keluar dari akun ini dan diarahkan kehalaman login kembali',
                                            style: normalTextMobile),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Tidak',
                                                style: normalTextMobile),
                                            onPressed: () {
                                              Navigator.of(dialogContext)
                                                  .pop(); // Dismiss alert dialog
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Ya',
                                                style: normalTextMobile),
                                            onPressed: () async {
                                              if (await Provider.of<
                                                          AuthProvider>(context,
                                                      listen: false)
                                                  .logout()) {
                                                Navigator.pushNamed(
                                                    context, "/login");
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Iconsax.logout),
                              )
                            ],
                          ),
                        ),
                        Text(
                            'Gudang : ${locationProvider.selectedLocation?.locationName ?? "-"}',
                            style: normalTextMobile),
                        10.verticalSpace,
                        Column(
                          children: [
                            headerContentMobile(
                                0,
                                "Total Stock In",
                                chartProvider.itemInfoModel?.totalStockIn
                                        .toString() ??
                                    "0",
                                "Start From 1 Jan 2022",
                                null,
                                stockingProvider,
                                itemProvider,
                                locationProvider,
                                token),
                            SizedBox(
                              height: 20.h,
                            ),
                            headerContentMobile(
                                1,
                                "Total Stock Out",
                                chartProvider.itemInfoModel?.totalStockOut
                                        .toString() ??
                                    "0",
                                "Start From 1 Jan 2022",
                                null,
                                stockingProvider,
                                itemProvider,
                                locationProvider,
                                token),
                            SizedBox(
                              height: 20.h,
                            ),
                            headerContentMobile(
                                2,
                                "Total Barang",
                                chartProvider.itemInfoModel?.totalBarang
                                        .toString() ??
                                    "0",
                                "+ Tambah Barang Baru", () {
                              showDialog<void>(
                                context: context,
                                barrierDismissible: true,
                                // false = user must tap button, true = tap outside dialog
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title: Text('Tambah Barang',
                                        style: TextStyle(
                                            fontSize: 45.sp,
                                            fontWeight: FontWeight.w700)),
                                    content: AddBarangWidget(isMobile: true),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Close'),
                                      )
                                    ],
                                  );
                                },
                              );
                            }, stockingProvider, itemProvider, locationProvider,
                                token),
                            SizedBox(
                              height: 15.w,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      height: 40.h,
                      child: Row(
                        children: [
                          const Icon(Iconsax.chart),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text('Stock Barang', style: titleText),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                        height: 300.h,
                        width: 1.sw,
                        decoration: BoxDecoration(
                            border: Border.all(color: "#DAE7F0".toColor()),
                            borderRadius: BorderRadius.circular(5)),
                        child: const BarChartWidgetMobile())
                  ],
                ),
              ),
            )));
      } else {
        return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.w),
              child: Column(
                children: [
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          child: Row(
                            children: [
                              Text('Dashboard', style: titleText),
                              30.horizontalSpace,
                              Text(
                                  'Gudang : ${locationProvider.selectedLocation?.locationName ?? "-"}',
                                  style: normalText),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  showDialog<void>(
                                    context: context,
                                    // false = user must tap button, true = tap outside dialog
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: Text('Silahkan Pilih Gudang',
                                            style: titleText),
                                        content:
                                            LocationWidget(locationProvider),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, "/location");
                                            },
                                            child: Text('Tambah Gudang'),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Iconsax.building),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    // false = user must tap button, true = tap outside dialog
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: Text('Apakah Anda Yakin ?',
                                            style: normalText),
                                        content: Text(
                                            'Anda akan keluar dari akun ini dan diarahkan kehalaman login kembali',
                                            style: normalText),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Tidak',
                                                style: normalText),
                                            onPressed: () {
                                              Navigator.of(dialogContext)
                                                  .pop(); // Dismiss alert dialog
                                            },
                                          ),
                                          TextButton(
                                            child:
                                                Text('Ya', style: normalText),
                                            onPressed: () async {
                                              if (await Provider.of<
                                                          AuthProvider>(context,
                                                      listen: false)
                                                  .logout()) {
                                                Navigator.pushNamed(
                                                    context, "/login");
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Iconsax.logout),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: Row(
                          children: [
                            Flexible(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  headerContent(
                                      0,
                                      "Total Stock In",
                                      chartProvider.itemInfoModel?.totalStockIn
                                              .toString() ??
                                          "0",
                                      "Start From 1 Jan 2022",
                                      null,
                                      stockingProvider,
                                      itemProvider,
                                      locationProvider,
                                      token),
                                  headerContent(
                                      1,
                                      "Total Stock Out",
                                      chartProvider.itemInfoModel?.totalStockOut
                                              .toString() ??
                                          "0",
                                      "Start From 1 Jan 2022",
                                      null,
                                      stockingProvider,
                                      itemProvider,
                                      locationProvider,
                                      token),
                                  headerContent(
                                      2,
                                      "Total Barang",
                                      chartProvider.itemInfoModel?.totalBarang
                                              .toString() ??
                                          "0",
                                      "+ Tambah Barang Baru", () {
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible: true,
                                      // false = user must tap button, true = tap outside dialog
                                      builder: (BuildContext dialogContext) {
                                        return AlertDialog(
                                          title: Text('Tambah Barang',
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w700)),
                                          content: AddBarangWidget(),
                                          actions: <Widget>[],
                                        );
                                      },
                                    );
                                  }, stockingProvider, itemProvider,
                                      locationProvider, token),
                                ],
                              ),
                              flex: 5,
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            Flexible(
                              child: InkWell(
                                onTap: () async {
                                  if (await itemProvider.getProject(token)) {
                                    Navigator.pushNamed(context, "/home");
                                  }
                                },
                                customBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Ink(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: blue,
                                      border: Border.all(color: Colors.black12),
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                          colors: [
                                            "#9bafd9".toColor(),
                                            "#103783".toColor(),
                                          ],
                                          end: Alignment.bottomLeft,
                                          begin: Alignment.topRight),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(3, 0),
                                          blurRadius: 10,
                                          spreadRadius: 3,
                                        )
                                      ]),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Iconsax.d_cube_scan,
                                        color: white,
                                        size: 50.h,
                                      ),
                                      Text('Mulai Scan',
                                          style: normalText.copyWith(
                                              color: Colors.white,
                                              fontSize: 20.sp)),
                                    ],
                                  ),
                                ),
                              ),
                              flex: 1,
                            )
                          ],
                        )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    height: 40.h,
                    child: Row(
                      children: [
                        const Icon(Iconsax.chart),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text('Stock Barang', style: titleText),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Flexible(
                    flex: 3,
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: "#DAE7F0".toColor()),
                            borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.only(
                            left: 10.w, right: 10.w, bottom: 10.w),
                        child: const BarChartWidget()),
                  )
                ],
              ),
            )));
      }
    });
  }

  SizedBox LocationWidget(LocationProvider locationProvider) {
    return SizedBox(
      width: 0.90.sw,
      height: 250.h,
      child: ListView.separated(
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 9.w,
            );
          },
          itemCount: locationProvider.listLocation.length,
          itemBuilder: (BuildContext context, int index) {
            return gudangWidget(locationProvider, index);
          },
          scrollDirection: Axis.horizontal),
    );
  }

  InkWell gudangWidget(LocationProvider locationProvider, int index) {
    return InkWell(
      onTap: () async {
        locationProvider.setLocation(locationProvider.listLocation[index]);
        updateData();
      },
      borderRadius: BorderRadius.circular(5),
      child: Ink(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(color: grey, blurRadius: 10, spreadRadius: 2)
            ],
            border: Border.all(color: grey)),
        height: 200.w,
        width: 200.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Gudang', style: normalText),
            Text(locationProvider.listLocation[index].locationName,
                textAlign: TextAlign.center, style: titleText)
          ],
        ),
      ),
    );
  }

  SizedBox LocationMobileWidget(LocationProvider locationProvider) {
    return SizedBox(
      width: 0.90.sw,
      height: 250.h,
      child: ListView.separated(
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 9.h,
            );
          },
          itemCount: locationProvider.listLocation.length,
          itemBuilder: (BuildContext context, int index) {
            return gudangMobileWidget(locationProvider, index);
          },
          scrollDirection: Axis.vertical),
    );
  }

  InkWell gudangMobileWidget(LocationProvider locationProvider, int index) {
    return InkWell(
      onTap: () async {
        locationProvider.setLocation(locationProvider.listLocation[index]);
        updateData();
      },
      borderRadius: BorderRadius.circular(5),
      child: Ink(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(color: grey, blurRadius: 10, spreadRadius: 2)
            ],
            border: Border.all(color: grey)),
        height: 300.w,
        width: 200.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Gudang', style: normalTextMobile),
            Text(locationProvider.listLocation[index].locationName,
                textAlign: TextAlign.center, style: titleTextMobile)
          ],
        ),
      ),
    );
  }

  Container headerContent(
      index,
      title,
      value,
      footer,
      handleClick,
      StockingProvider stockingProvider,
      ItemProvider itemProvider,
      LocationProvider locationProvider,
      String token) {
    Color backgroundColor = blue;
    IconData iconData = Iconsax.home_trend_up;
    Color textColor = Colors.white;
    Color borderColor = blue;
    switch (index) {
      case 1:
        backgroundColor = red;
        borderColor = red;
        iconData = Iconsax.home_trend_down;
        break;
      case 2:
        backgroundColor = white;
        borderColor = "#DAE7F0".toColor();
        iconData = Iconsax.d_cube_scan;
        textColor = Colors.black;
        break;
    }
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(3, 0),
              blurRadius: 10,
              spreadRadius: 3,
            )
          ],
          border: Border.all(color: borderColor)),
      width: 260.w,
      height: 180.h,
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 40.h,
                width: 40.h,
                decoration: BoxDecoration(
                    color: textColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(iconData, color: textColor),
              ),
              Spacer(),
              GestureDetector(
                  onTap: () async {
                    if (index == 0) {
                      var startDate = Helper.getToday.decrement(value: 7);
                      var endDate = Helper.getToday.normal();
                      if (await itemProvider.getDetailStock(
                          token,
                          startDate,
                          endDate,
                          "IN",
                          locationProvider.selectedLocation?.locationCode ??
                              "-")) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailStockPage(
                                      isStockIn: true,
                                    )));
                      }
                    } else if (index == 1) {
                      var startDate = Helper.getToday.decrement(value: 7);
                      var endDate = Helper.getToday.normal();
                      if (await itemProvider.getDetailStock(
                          token,
                          startDate,
                          endDate,
                          "OUT",
                          locationProvider.selectedLocation?.locationCode ??
                              "-")) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailStockPage(
                                      isStockIn: false,
                                    )));
                      }
                    }
                  },
                  child: const Text(
                    'See More Detail',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
          const Spacer(),
          Text(title,
              style: normalText.copyWith(color: textColor.withOpacity(0.5))),
          SizedBox(
            height: 3.h,
          ),
          Text(value,
              style: titleText.copyWith(color: textColor, fontSize: 28.sp)),
          Divider(color: textColor.withOpacity(0.5)),
          handleClick != null
              ? Material(
                  color: Colors.white,
                  child: InkWell(
                    onTap: handleClick,
                    splashColor: blue,
                    child: Ink(
                      child: Text(footer,
                          style: normalText.copyWith(
                              color: blue, fontSize: 12.sp)),
                    ),
                  ),
                )
              : Text(footer,
                  style: normalText.copyWith(
                      color: textColor.withOpacity(0.5), fontSize: 12.sp)),
        ],
      ),
    );
  }

  Container headerContentMobile(
      index,
      title,
      value,
      footer,
      handleClick,
      StockingProvider stockingProvider,
      ItemProvider itemProvider,
      LocationProvider locationProvider,
      String token) {
    Color backgroundColor = blue;
    IconData iconData = Iconsax.home_trend_up;
    Color textColor = Colors.white;
    Color borderColor = blue;
    switch (index) {
      case 1:
        backgroundColor = red;
        borderColor = red;
        iconData = Iconsax.home_trend_down;
        break;
      case 2:
        backgroundColor = white;
        borderColor = "#DAE7F0".toColor();
        iconData = Iconsax.d_cube_scan;
        textColor = Colors.black;
        break;
    }
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(3, 0),
              blurRadius: 10,
              spreadRadius: 3,
            )
          ],
          border: Border.all(color: borderColor)),
      width: 1.sw,
      height: 180.h,
      padding: EdgeInsets.all(40.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 40.h,
                width: 40.h,
                decoration: BoxDecoration(
                    color: textColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(iconData, color: textColor),
              ),
              Spacer(),
              GestureDetector(
                  onTap: () async {
                    if (index == 0) {
                      var startDate = Helper.getToday.decrement(value: 7);
                      var endDate = Helper.getToday.normal();
                      if (await itemProvider.getDetailStock(
                          token,
                          startDate,
                          endDate,
                          "IN",
                          locationProvider.selectedLocation?.locationCode ??
                              "-")) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailStockPage(
                                      isStockIn: true,
                                    )));
                      }
                    } else if (index == 1) {
                      var startDate = Helper.getToday.decrement(value: 7);
                      var endDate = Helper.getToday.normal();
                      if (await itemProvider.getDetailStock(
                          token,
                          startDate,
                          endDate,
                          "OUT",
                          locationProvider.selectedLocation?.locationCode ??
                              "-")) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailStockPage(
                                      isStockIn: false,
                                    )));
                      }
                    }
                  },
                  child: Text(
                    'See More Detail',
                    style: normalTextMobile.copyWith(color: white),
                  )),
            ],
          ),
          const Spacer(),
          Text(title,
              style:
                  normalTextMobile.copyWith(color: textColor.withOpacity(0.5))),
          SizedBox(
            height: 3.h,
          ),
          Text(value,
              style:
                  titleTextMobile.copyWith(color: textColor, fontSize: 60.sp)),
          Divider(color: textColor.withOpacity(0.5)),
          handleClick != null
              ? Material(
                  color: Colors.white,
                  child: InkWell(
                    onTap: handleClick,
                    splashColor: blue,
                    child: Ink(
                      child: Text(footer,
                          style: normalTextMobile.copyWith(
                              color: blue, fontSize: 30.sp)),
                    ),
                  ),
                )
              : Text(footer,
                  style: normalTextMobile.copyWith(
                      color: textColor.withOpacity(0.5), fontSize: 20.sp)),
        ],
      ),
    );
  }
}
