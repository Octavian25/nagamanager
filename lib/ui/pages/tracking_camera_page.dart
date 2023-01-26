part of 'pages.dart';

class TrackingPageCamera extends StatefulWidget {
  final bool trackingIn;
  const TrackingPageCamera({Key? key, this.trackingIn = false}) : super(key: key);

  @override
  _TrackingPageCameraState createState() => _TrackingPageCameraState();
}

class _TrackingPageCameraState extends State<TrackingPageCamera> {
  var focusBarcode = InputWithKeyboardControlFocusNode();
  final barcodeController = TextEditingController();
  final qtyController = TextEditingController();
  MobileScannerController mobileScannerController = MobileScannerController();
  var counter = 0;
  List<ItemModel> listTracking = [];
  String imageSelected = "";
  bool isLoading = false;
  TextInputType keyboardType = TextInputType.none;
  String barcodeString = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    qtyController.dispose();
    barcodeController.dispose();
    mobileScannerController.stop();
    mobileScannerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ItemProvider itemProvider = Provider.of<ItemProvider>(context);
    final trackingIn = widget.trackingIn;
    return LayoutBuilder(builder: (context, constrains) {
      if (constrains.maxWidth < 600) {
        return SafeArea(
            child: Scaffold(
          backgroundColor: background,
          body: ExpandableBottomSheet(
              background: Stack(
                children: [
                  SizedBox(
                    height: 1.sh,
                    width: 1.sw,
                    child: MobileScanner(
                      allowDuplicates: false,
                      controller: mobileScannerController,
                      onDetect: (barcode, args) {
                        if (barcode.rawValue == null) {
                          showToast("Scan Barcode Gagal", true);
                        } else {
                          final String barcodeString = barcode.rawValue!;
                          try {
                            showDialog<void>(
                              context: context,
                              barrierDismissible: true,
                              // false = user must tap button, true = tap outside dialog
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  title: Text('Enter Quantity',
                                      style:
                                          TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w700)),
                                  content: SizedBox(
                                    height: 45.h,
                                    width: 80.w,
                                    child: Container(
                                      height: 45.h,
                                      width: 80.w,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black54),
                                          borderRadius: BorderRadius.circular(5)),
                                      child: Center(
                                        child: TextField(
                                          controller: qtyController,
                                          textAlignVertical: TextAlignVertical.center,
                                          textAlign: TextAlign.center,
                                          style: normalTextMobile,
                                          onSubmitted: (data) {
                                            if (data != "" || data != "0") {
                                              try {
                                                var ItemModel = itemProvider.item!.firstWhere(
                                                    (element) => element.barcode == barcodeString);
                                                for (var i = 0; i < data.toInt()!; i++) {
                                                  listTracking.add(ItemModel);
                                                }
                                                imageSelected = ItemModel.imagePath;
                                                setState(() {
                                                  counter = counter + data.toInt()!;
                                                });
                                                barcodeController.clear();
                                                qtyController.clear();
                                                Navigator.pop(context);
                                              } catch (e) {
                                                showToast("Barcode Tidak Ditemukan", true);
                                              }
                                            } else {
                                              showToast("Masukan Quantity", true);
                                            }
                                          },
                                          decoration: InputDecoration(
                                              hintText: "Enter Here",
                                              hintStyle: normalTextMobile,
                                              border: InputBorder.none),
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
                            showToast("Barcode Tidak Ditemukan", true);
                          }
                        }
                      },
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 20.w,
                          ),
                          CircleAvatar(
                            backgroundColor: white,
                            child: IconButton(
                                onPressed: () {
                                  context.go('/dashboard/home');
                                },
                                color: blue,
                                icon: const Icon(Icons.keyboard_arrow_left)),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              persistentHeader: Container(
                height: 170,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Column(
                      children: [
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flash(
                              child: Text('Swipe Up For Details',
                                  style: normalTextMobile.copyWith(fontSize: 25.sp)),
                              infinite: true,
                              delay: const Duration(seconds: 1),
                              duration: const Duration(seconds: 3),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Last Items Scanned',
                                style: normalTextMobile.copyWith(fontSize: 40.sp)),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Container(
                              width: 100.h,
                              height: 100.h,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                              child: CachedNetworkImage(
                                imageUrl: imageSelected,
                                progressIndicatorBuilder: (context, url, downloadProgress) =>
                                    Center(
                                  child:
                                      CircularProgressIndicator(value: downloadProgress.progress),
                                ),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                width: 100.h,
                                height: 100.h,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 100.h,
                              height: 100.h,
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
                                      style: bigTextMobile.copyWith(
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
                                    style: normalTextMobile.copyWith(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16.h,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              expandableContent: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 10),
                  height: 400.h,
                  width: 100.sw,
                  decoration: BoxDecoration(color: white),
                  child: Column(
                    children: [
                      Expanded(
                        child: counter == 0
                            ? Column(
                                children: [
                                  Image.asset(
                                    counter > 0
                                        ? "assets/progress-scan.png"
                                        : "assets/waiting-scan.png",
                                    width: 270.h,
                                    height: 270.h,
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
                                        "Barang Masih Kosong, Jangan Khawatir ! Arahkan Scanner Ke Barang Untuk Melakukan Stock In",
                                        style: normalTextMobile,
                                        textAlign: TextAlign.center,
                                      )),
                                ],
                              )
                            : ListView.builder(
                                itemCount: listTracking.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    width: 873.w,
                                    margin: EdgeInsets.symmetric(vertical: 16.h),
                                    padding: EdgeInsets.symmetric(horizontal: 35.w),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 150.w,
                                          child: Text(
                                            listTracking[index].barcode,
                                            style: normalText.copyWith(
                                                fontSize: 30.sp, fontWeight: FontWeight.w700),
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
                                              fontSize: 30.sp, fontWeight: FontWeight.w700),
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
                                                  fontSize: 30.sp, fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                      ),
                      SizedBox(
                        height: 16.h,
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
                                  Provider.of<AuthProvider>(context, listen: false);
                              TrackingProvider trackingProvider =
                                  Provider.of<TrackingProvider>(context, listen: false);
                              ItemProvider itemProvider =
                                  Provider.of<ItemProvider>(context, listen: false);
                              var result = await trackingProvider.sendTracking(
                                  token: authProvider.user!.accessToken,
                                  listBarang: listTracking,
                                  type: trackingIn ? "TRACK IN" : "TRACK OUT");
                              setState(() {
                                isLoading = false;
                              });
                              await itemProvider.getProject(authProvider.user!.accessToken);
                              await itemProvider.getTotalOut(authProvider.user!.accessToken);
                              await itemProvider.getTotalIn(authProvider.user!.accessToken);
                              showModalBottomSheet(
                                isDismissible: false,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        topLeft: Radius.circular(15))),
                                context: context,
                                builder: (BuildContext context) {
                                  return BottomSheetTrackingMobile(trackingFeedback: result);
                                },
                              );
                            },
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
                                        "Loading..",
                                        style: normalTextMobile,
                                      )
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
              )),
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
                            trackingIn ? "Melakukan Track In," : "Melakukan Track Out,",
                            style: normalText.copyWith(fontSize: 14.sp),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          SizedBox(
                            height: 45.h,
                            width: 150.w,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(primary: red, onPrimary: white),
                              onPressed: () => {context.go('/dashboard/home')},
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
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                        child: CachedNetworkImage(
                          imageUrl: imageSelected,
                          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(value: downloadProgress.progress),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
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
                                    color: white, fontSize: 60.sp, fontWeight: FontWeight.bold),
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
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15), color: white),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 16.h,
                        ),
                        Container(
                          height: 45.h,
                          width: 873.w,
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
                                  style: normalText.copyWith(color: Colors.black),
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
                                                    fontSize: 20.sp, fontWeight: FontWeight.w700)),
                                            content: SizedBox(
                                              height: 45.h,
                                              width: 80.w,
                                              child: Container(
                                                height: 45.h,
                                                width: 80.w,
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.black54),
                                                    borderRadius: BorderRadius.circular(5)),
                                                child: Center(
                                                  child: TextField(
                                                    controller: qtyController,
                                                    textAlignVertical: TextAlignVertical.center,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 15.sp),
                                                    onSubmitted: (data) {
                                                      if (data != "" || data != "0") {
                                                        try {
                                                          var ItemModel = itemProvider.item!
                                                              .firstWhere((element) =>
                                                                  element.barcode == barcode);
                                                          for (var i = 0; i < data.toInt()!; i++) {
                                                            listTracking.add(ItemModel);
                                                          }
                                                          imageSelected = ItemModel.imagePath;
                                                          setState(() {
                                                            counter = counter + data.toInt()!;
                                                          });
                                                          barcodeController.clear();
                                                          qtyController.clear();
                                                          Navigator.pop(context);
                                                        } catch (e) {
                                                          showToast(
                                                              "Barcode Tidak Ditemukan", true);
                                                        }
                                                      } else {
                                                        showToast("Masukan Quantity", true);
                                                      }
                                                    },
                                                    decoration: const InputDecoration(
                                                        hintText: "Enter Here",
                                                        border: InputBorder.none),
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
                                      showToast("Barcode Tidak Ditemukan", true);
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
                                          "Barang Masih Kosong, Jangan Khawatir ! Arahkan Scanner Ke Barang Untuk Melakukan Stock In",
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
                                                  borderRadius: BorderRadius.circular(15))),
                                          onPressed: () async {
                                            StockingProvider stockingProvider =
                                                Provider.of<StockingProvider>(context,
                                                    listen: false);
                                            AuthProvider authProvider =
                                                Provider.of<AuthProvider>(context, listen: false);
                                            ItemProvider itemProvider =
                                                Provider.of<ItemProvider>(context, listen: false);
                                            DateTime dateToday = DateTime.now();
                                            String date = dateToday.toString().substring(0, 10);
                                          },
                                          child: const Text("Simpan"),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : ListView.builder(
                                  itemCount: listTracking.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      width: 873.w,
                                      margin: EdgeInsets.symmetric(vertical: 16.h),
                                      padding: EdgeInsets.symmetric(horizontal: 35.w),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            listTracking[index].barcode,
                                            style: normalText.copyWith(
                                                fontSize: 18.sp, fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            listTracking[index].name,
                                            style: normalText.copyWith(
                                                fontSize: 18.sp, fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "1",
                                            style: normalText.copyWith(
                                                fontSize: 18.sp, fontWeight: FontWeight.w700),
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
                                    Provider.of<AuthProvider>(context, listen: false);
                                TrackingProvider trackingProvider =
                                    Provider.of<TrackingProvider>(context, listen: false);
                                ItemProvider itemProvider =
                                    Provider.of<ItemProvider>(context, listen: false);
                                var result = await trackingProvider.sendTracking(
                                    token: authProvider.user!.accessToken,
                                    listBarang: listTracking,
                                    type: trackingIn ? "TRACK IN" : "TRACK OUT");
                                setState(() {
                                  isLoading = false;
                                });
                                await itemProvider.getProject(authProvider.user!.accessToken);
                                await itemProvider.getTotalOut(authProvider.user!.accessToken);
                                await itemProvider.getTotalIn(authProvider.user!.accessToken);
                                showModalBottomSheet(
                                  isDismissible: false,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          topLeft: Radius.circular(15))),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return BottomSheetTracking(trackingFeedback: result);
                                  },
                                );
                              },
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
                                          "Loading..",
                                          style: normalText,
                                        )
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
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
