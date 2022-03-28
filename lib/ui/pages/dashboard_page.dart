part of 'pages.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    ChartProvider chartProvider = Provider.of<ChartProvider>(context);
    ItemProvider itemProvider = Provider.of<ItemProvider>(context);
    String token = Provider.of<AuthProvider>(context).user!.accessToken;
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
                          const Spacer(),
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
                                        child: Text('Tidak', style: normalText),
                                        onPressed: () {
                                          Navigator.of(dialogContext)
                                              .pop(); // Dismiss alert dialog
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Ya', style: normalText),
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, "/login");
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              headerContent(
                                  0,
                                  "Total Stock In",
                                  chartProvider.itemInfoModel!.totalStockIn
                                      .toString(),
                                  "Start From 1 Jan 2022",
                                  null),
                              headerContent(
                                  1,
                                  "Total Stock Out",
                                  chartProvider.itemInfoModel!.totalStockOut
                                      .toString(),
                                  "Start From 1 Jan 2022",
                                  null),
                              headerContent(
                                  2,
                                  "Total Barang",
                                  chartProvider.itemInfoModel!.totalBarang
                                      .toString(),
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
                              }),
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
                    padding:
                        EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.w),
                    child: const BarChartWidget()),
              )
            ],
          ),
        )));
  }

  Container headerContent(index, title, value, footer, handleClick) {
    Color backgroundColor = blue;
    IconData iconData = Iconsax.home_trend_up;
    Color textColor = Colors.white;
    switch (index) {
      case 1:
        backgroundColor = red;
        iconData = Iconsax.home_trend_down;
        break;
      case 2:
        backgroundColor = white;
        iconData = Iconsax.d_cube_scan;
        textColor = Colors.black;
        break;
    }
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: "#DAE7F0".toColor())),
      width: 260.w,
      height: 180.h,
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40.h,
            width: 40.h,
            decoration: BoxDecoration(
                color: textColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(5)),
            child: Icon(iconData, color: textColor),
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
}
