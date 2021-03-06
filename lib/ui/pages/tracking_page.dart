part of 'pages.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({Key? key}) : super(key: key);

  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  var focusBarcode = InputWithKeyboardControlFocusNode();
  final barcodeController = TextEditingController();
  final qtyController = TextEditingController();
  var counter = 0;
  List<ItemModel> listTracking = [];
  String imageSelected = "";
  bool isLoading = false;
  TextInputType keyboardType = TextInputType.none;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    qtyController.dispose();
    barcodeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ItemProvider itemProvider = Provider.of<ItemProvider>(context);
    final trackingIn = ModalRoute.of(context)!.settings.arguments as bool;
    return LayoutBuilder(builder: (context, constrains) {
      if (constrains.maxWidth < 600) {
        return SafeArea(
            child: Scaffold(
          backgroundColor: background,
          body: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                SizedBox(
                  height: 155.h,
                  width: 100.sw,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 45.h,
                            width: 150.w,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: red, onPrimary: white),
                              onPressed: () =>
                                  {Navigator.pushNamed(context, "/home")},
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.chevron_left_rounded,
                                    size: 40.w,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                      Container(
                        width: 160.h,
                        height: 150.h,
                        decoration: BoxDecoration(
                            color: trackingIn ? blue : red,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 5.h,
                            ),
                            Flash(
                              child: Text(
                                counter.toString(),
                                style: bigText.copyWith(
                                    color: white,
                                    fontSize: 80.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              infinite: true,
                              delay: const Duration(seconds: 1),
                              duration: const Duration(seconds: 3),
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            Text(
                              trackingIn ? "Track In" : "Track Out",
                              style: normalTextMobile.copyWith(
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(top: 10.h),
                    padding: EdgeInsets.all(30.h),
                    height: 502.h,
                    width: 100.sw,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15), color: white),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 16.h,
                        ),
                        Container(
                          height: 45.h,
                          width: 873.w,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black26, width: 1),
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                              child: Row(
                            children: [
                              SizedBox(
                                width: 25.w,
                              ),
                              SizedBox(
                                width: 40.w,
                                child: Icon(
                                  Icons.qr_code_scanner_rounded,
                                  size: 40.w,
                                ),
                              ),
                              SizedBox(
                                width: 25.w,
                              ),
                              Expanded(
                                child: InputWithKeyboardControl(
                                  focusNode: focusBarcode,
                                  style: normalTextMobile.copyWith(
                                      color: Colors.black),
                                  autofocus: true,
                                  controller: barcodeController,
                                  onSubmitted: (String barcode) {
                                    try {
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: true,
                                        // false = user must tap button, true = tap outside dialog
                                        builder: (BuildContext dialogContext) {
                                          return AlertDialog(
                                            title: Text('Enter Quantity',
                                                style: TextStyle(
                                                    fontSize: 40.sp,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            content: SizedBox(
                                              height: 45.h,
                                              width: 80.w,
                                              child: Container(
                                                height: 45.h,
                                                width: 80.w,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black54),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Center(
                                                  child: TextField(
                                                    controller: qtyController,
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .center,
                                                    textAlign: TextAlign.center,
                                                    style: normalTextMobile,
                                                    autofocus: true,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    onSubmitted: (data) {
                                                      if (data != "" ||
                                                          data != "0") {
                                                        try {
                                                          var ItemModel = itemProvider
                                                              .item!
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .barcode ==
                                                                      barcode);
                                                          for (var i = 0;
                                                              i < data.toInt()!;
                                                              i++) {
                                                            listTracking
                                                                .add(ItemModel);
                                                          }
                                                          imageSelected =
                                                              ItemModel
                                                                  .imagePath;
                                                          setState(() {
                                                            counter = counter +
                                                                data.toInt()!;
                                                          });
                                                          barcodeController
                                                              .clear();
                                                          qtyController.clear();
                                                          Navigator.pop(
                                                              context);
                                                        } catch (e) {
                                                          showToast(
                                                              "Barcode Tidak Ditemukan",
                                                              true);
                                                        }
                                                      } else {
                                                        showToast(
                                                            "Masukan Quantity",
                                                            true);
                                                      }
                                                    },
                                                    decoration: InputDecoration(
                                                        hintText: "Enter Here",
                                                        hintStyle:
                                                            normalTextMobile,
                                                        border:
                                                            InputBorder.none),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    } catch (e) {
                                      showToast(
                                          "Barcode Tidak Ditemukan", true);
                                      Navigator.pop(context);
                                    }
                                  },
                                  width: double.infinity,
                                  showButton: true,
                                  showUnderline: false,
                                  startShowKeyboard: false,
                                  buttonColorEnabled: blue,
                                  buttonColorDisabled: Colors.black,
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                              )
                            ],
                          )),
                        ),
                        Expanded(
                          child: counter == 0
                              ? Column(
                                  children: [
                                    Image.asset(
                                      counter > 0
                                          ? "assets/progress-scan.png"
                                          : "assets/waiting-scan.png",
                                      width: 303.h,
                                      height: 300.h,
                                    ),
                                    Visibility(
                                      visible: counter > 0,
                                      child: Text(
                                        counter.toString(),
                                        style: bigText,
                                      ),
                                    ),
                                    Visibility(
                                      visible: counter > 0,
                                      child: Text(
                                        "Barang Masuk",
                                        style: titleTextMobile,
                                      ),
                                    ),
                                    Visibility(
                                        visible: counter == 0,
                                        child: Text(
                                          "Barang Masih Kosong, Jangan Khawatir !???Arahkan Scanner Ke Barang Untuk Melakukan Stock In",
                                          style: normalTextMobile,
                                          textAlign: TextAlign.center,
                                        )),
                                    SizedBox(
                                      height: 11.h,
                                    ),
                                    Visibility(
                                      visible: counter > 0,
                                      child: SizedBox(
                                        height: 45.h,
                                        width: 441.w,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: blue,
                                              onPrimary: white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15))),
                                          onPressed: () async {
                                            StockingProvider stockingProvider =
                                                Provider.of<StockingProvider>(
                                                    context,
                                                    listen: false);
                                            AuthProvider authProvider =
                                                Provider.of<AuthProvider>(
                                                    context,
                                                    listen: false);
                                            ItemProvider itemProvider =
                                                Provider.of<ItemProvider>(
                                                    context,
                                                    listen: false);
                                            DateTime dateToday = DateTime.now();
                                            String date = dateToday
                                                .toString()
                                                .substring(0, 10);
                                          },
                                          child: const Text("Simpan"),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : ListView.builder(
                                  itemCount: listTracking.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      width: 873.w,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 16.h),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 35.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 150.w,
                                            child: Text(
                                              listTracking[index].barcode,
                                              style: normalText.copyWith(
                                                  fontSize: 30.sp,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 30.w,
                                          ),
                                          Expanded(
                                              child: Text(
                                            listTracking[index].name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: normalText.copyWith(
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w700),
                                          )),
                                          SizedBox(
                                            width: 30.w,
                                          ),
                                          SizedBox(
                                            width: 50.w,
                                            child: Center(
                                              child: Text(
                                                "1",
                                                style: normalText.copyWith(
                                                    fontSize: 30.sp,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                        ),
                        Visibility(
                          visible: counter > 0,
                          child: SizedBox(
                            height: 45.h,
                            width: 441.w,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: blue,
                                  onPrimary: white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                AuthProvider authProvider =
                                    Provider.of<AuthProvider>(context,
                                        listen: false);
                                TrackingProvider trackingProvider =
                                    Provider.of<TrackingProvider>(context,
                                        listen: false);
                                ItemProvider itemProvider =
                                    Provider.of<ItemProvider>(context,
                                        listen: false);
                                var result =
                                    await trackingProvider.sendTracking(
                                        token: authProvider.user!.accessToken,
                                        listBarang: listTracking,
                                        type: trackingIn
                                            ? "TRACK IN"
                                            : "TRACK OUT");
                                setState(() {
                                  isLoading = false;
                                });
                                await itemProvider
                                    .getProject(authProvider.user!.accessToken);
                                await itemProvider.getTotalOut(
                                    authProvider.user!.accessToken);
                                await itemProvider
                                    .getTotalIn(authProvider.user!.accessToken);
                                showModalBottomSheet(
                                  isDismissible: false,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          topLeft: Radius.circular(15))),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return BottomSheetTrackingMobile(
                                        trackingFeedback: result);
                                  },
                                );
                              },
                              child: isLoading
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          "Loading..",
                                          style: normalTextMobile,
                                        )
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Simpan",
                                          style: normalTextMobile,
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
          ),
        ));
      } else {
        return SafeArea(
            child: Scaffold(
          backgroundColor: background,
          body: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                SizedBox(
                  height: 155.h,
                  width: 100.sw,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trackingIn
                                ? "Melakukan Track In,"
                                : "Melakukan Track Out,",
                            style: normalText.copyWith(fontSize: 14.sp),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          SizedBox(
                            height: 45.h,
                            width: 150.w,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: red, onPrimary: white),
                              onPressed: () =>
                                  {Navigator.pushNamed(context, "/home")},
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.chevron_left_rounded,
                                    size: 25.w,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    "Kembali",
                                    style: normalText,
                                  ),
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
                            borderRadius: BorderRadius.circular(15)),
                        child: CachedNetworkImage(
                          imageUrl: imageSelected,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          width: 100.w,
                          height: 100.h,
                        ),
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      Container(
                        width: 160.w,
                        height: 150.w,
                        decoration: BoxDecoration(
                            color: trackingIn ? blue : red,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 5.h,
                            ),
                            Flash(
                              child: Text(
                                counter.toString(),
                                style: bigText.copyWith(
                                    color: white,
                                    fontSize: 60.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              infinite: true,
                              delay: const Duration(seconds: 1),
                              duration: const Duration(seconds: 3),
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            Text(
                              trackingIn ? "Track In" : "Track Out",
                              style: normalText.copyWith(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 18.w,
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(top: 10.h),
                    padding: EdgeInsets.all(10.h),
                    height: 532.h,
                    width: 100.sw,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15), color: white),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 16.h,
                        ),
                        Container(
                          height: 45.h,
                          width: 873.w,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black26, width: 1),
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
                                  Icons.qr_code_scanner_rounded,
                                  size: 25.w,
                                ),
                              ),
                              SizedBox(
                                width: 25.w,
                              ),
                              Expanded(
                                child: InputWithKeyboardControl(
                                  focusNode: focusBarcode,
                                  style:
                                      normalText.copyWith(color: Colors.black),
                                  autofocus: true,
                                  controller: barcodeController,
                                  onSubmitted: (String barcode) {
                                    try {
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: true,
                                        // false = user must tap button, true = tap outside dialog
                                        builder: (BuildContext dialogContext) {
                                          return AlertDialog(
                                            title: Text('Enter Quantity',
                                                style: TextStyle(
                                                    fontSize: 20.sp,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            content: SizedBox(
                                              height: 45.h,
                                              width: 80.w,
                                              child: Container(
                                                height: 45.h,
                                                width: 80.w,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black54),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Center(
                                                  child: TextField(
                                                    controller: qtyController,
                                                    autofocus: true,
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .center,
                                                    textAlign: TextAlign.center,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    style: TextStyle(
                                                        fontSize: 15.sp),
                                                    onSubmitted: (data) {
                                                      if (data != "" ||
                                                          data != "0") {
                                                        try {
                                                          var ItemModel = itemProvider
                                                              .item!
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .barcode ==
                                                                      barcode);
                                                          for (var i = 0;
                                                              i < data.toInt()!;
                                                              i++) {
                                                            listTracking
                                                                .add(ItemModel);
                                                          }
                                                          imageSelected =
                                                              ItemModel
                                                                  .imagePath;
                                                          setState(() {
                                                            counter = counter +
                                                                data.toInt()!;
                                                          });
                                                          barcodeController
                                                              .clear();
                                                          qtyController.clear();
                                                          Navigator.pop(
                                                              context);
                                                        } catch (e) {
                                                          showToast(
                                                              "Barcode Tidak Ditemukan",
                                                              true);
                                                        }
                                                      } else {
                                                        showToast(
                                                            "Masukan Quantity",
                                                            true);
                                                      }
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText:
                                                                "Enter Here",
                                                            border: InputBorder
                                                                .none),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    } catch (e) {
                                      showToast(
                                          "Barcode Tidak Ditemukan", true);
                                      Navigator.pop(context);
                                    }
                                  },
                                  width: double.infinity,
                                  showButton: true,
                                  showUnderline: false,
                                  startShowKeyboard: false,
                                  buttonColorEnabled: blue,
                                  buttonColorDisabled: Colors.black,
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                              )
                            ],
                          )),
                        ),
                        Expanded(
                          child: counter == 0
                              ? Column(
                                  children: [
                                    Image.asset(
                                      counter > 0
                                          ? "assets/progress-scan.png"
                                          : "assets/waiting-scan.png",
                                      width: 493.w,
                                      height: 296.h,
                                    ),
                                    Visibility(
                                      visible: counter > 0,
                                      child: Text(
                                        counter.toString(),
                                        style: bigText,
                                      ),
                                    ),
                                    Visibility(
                                      visible: counter > 0,
                                      child: Text(
                                        "Barang Masuk",
                                        style: titleText,
                                      ),
                                    ),
                                    Visibility(
                                        visible: counter == 0,
                                        child: Text(
                                          "Barang Masih Kosong, Jangan Khawatir !???Arahkan Scanner Ke Barang Untuk Melakukan Stock In",
                                          style: normalText,
                                          textAlign: TextAlign.center,
                                        )),
                                    SizedBox(
                                      height: 11.h,
                                    ),
                                    Visibility(
                                      visible: counter > 0,
                                      child: SizedBox(
                                        height: 45.h,
                                        width: 441.w,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: blue,
                                              onPrimary: white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15))),
                                          onPressed: () async {
                                            StockingProvider stockingProvider =
                                                Provider.of<StockingProvider>(
                                                    context,
                                                    listen: false);
                                            AuthProvider authProvider =
                                                Provider.of<AuthProvider>(
                                                    context,
                                                    listen: false);
                                            ItemProvider itemProvider =
                                                Provider.of<ItemProvider>(
                                                    context,
                                                    listen: false);
                                            DateTime dateToday = DateTime.now();
                                            String date = dateToday
                                                .toString()
                                                .substring(0, 10);
                                          },
                                          child: const Text("Simpan"),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : ListView.builder(
                                  itemCount: listTracking.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      width: 873.w,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 16.h),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 35.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            listTracking[index].barcode,
                                            style: normalText.copyWith(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            listTracking[index].name,
                                            style: normalText.copyWith(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "1",
                                            style: normalText.copyWith(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w700),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                        ),
                        Visibility(
                          visible: counter > 0,
                          child: SizedBox(
                            height: 45.h,
                            width: 441.w,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: blue,
                                  onPrimary: white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                AuthProvider authProvider =
                                    Provider.of<AuthProvider>(context,
                                        listen: false);
                                TrackingProvider trackingProvider =
                                    Provider.of<TrackingProvider>(context,
                                        listen: false);
                                ItemProvider itemProvider =
                                    Provider.of<ItemProvider>(context,
                                        listen: false);
                                var result =
                                    await trackingProvider.sendTracking(
                                        token: authProvider.user!.accessToken,
                                        listBarang: listTracking,
                                        type: trackingIn
                                            ? "TRACK IN"
                                            : "TRACK OUT");
                                setState(() {
                                  isLoading = false;
                                });
                                await itemProvider
                                    .getProject(authProvider.user!.accessToken);
                                await itemProvider.getTotalOut(
                                    authProvider.user!.accessToken);
                                await itemProvider
                                    .getTotalIn(authProvider.user!.accessToken);
                                showModalBottomSheet(
                                  isDismissible: false,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          topLeft: Radius.circular(15))),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return BottomSheetTracking(
                                        trackingFeedback: result);
                                  },
                                );
                              },
                              child: isLoading
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          "Loading..",
                                          style: normalText,
                                        )
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Simpan",
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
          ),
        ));
      }
    });
  }
}
