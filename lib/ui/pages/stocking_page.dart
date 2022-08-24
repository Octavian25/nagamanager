part of 'pages.dart';

class StockingPage extends StatefulWidget {
  const StockingPage({Key? key}) : super(key: key);

  @override
  _StockingPageState createState() => _StockingPageState();
}

class _StockingPageState extends State<StockingPage> {
  var focusBarcode = FocusNode();
  final barcodeController = TextEditingController();
  var counter = 0;
  bool isLoading = false;

  @override
  void initState() {
    // focusBarcode.requestFocus();
    Timer(const Duration(seconds: 1),
        () => {SystemChannels.textInput.invokeMethod('TextInput.hide')});
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stockargumen =
        ModalRoute.of(context)!.settings.arguments as StockingArgumenModel;
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
                        stockargumen.isStockIn
                            ? "Melakukan Stock In,"
                            : "Melakukan Stock Out,",
                        style: normalText.copyWith(fontSize: 14.sp),
                      ),
                      Text(
                        stockargumen.itemModel.name,
                        style: titleText,
                      ),
                      Text(
                        stockargumen.itemModel.barcode,
                        style: titleText,
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
                  // Container(
                  //   width: 200.w,
                  //   height: 150.w,
                  //   child: CachedNetworkImage(
                  //     imageUrl: stockargumen.itemModel.imagePath,
                  //     progressIndicatorBuilder: (context, url, downloadProgress) =>
                  //         Center(child: CircularProgressIndicator(value: downloadProgress.progress),),
                  //     errorWidget: (context, url, error) => Icon(Icons.error),
                  //     width: 150.w, height: 150.h,
                  //   ),
                  // ),
                  Container(
                    width: 160.w,
                    height: 150.w,
                    decoration: BoxDecoration(
                        color: stockargumen.isStockIn ? blue : red,
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
                          stockargumen.isStockIn ? "Stock In" : "Stock Out",
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
                            child: TextFormField(
                              focusNode: focusBarcode,
                              style: normalText,
                              keyboardType: TextInputType.number,
                              showCursor: true,
                              autofocus: true,
                              controller: barcodeController,
                              onFieldSubmitted: (String data) => {
                                if (data == stockargumen.itemModel.barcode)
                                  {
                                    setState(() {
                                      counter = counter + 1;
                                    }),
                                    focusBarcode.unfocus(),
                                    barcodeController.clear(),
                                    focusBarcode.requestFocus(),
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide')
                                  }
                                else
                                  {print("BARANG BERBEDA")}
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: "Scan Your Barcode",
                                hintStyle: normalText,
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                            visible: counter == 0,
                            child: Image.asset(
                              "assets/waiting-scan.png",
                              width: 493.w,
                              height: 296.h,
                            )),
                        Visibility(
                          visible: counter > 0,
                          child: CachedNetworkImage(
                            imageUrl: stockargumen.itemModel.imagePath,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            width: 493.w,
                            height: 350.h,
                          ),
                        ),
                        // Visibility(
                        //   visible: counter > 0,
                        //   child: Text(counter.toString(), style: bigText,),
                        // ),
                        // Visibility(
                        //   visible: counter > 0,
                        //   child: Text("Barang Masuk", style: titleText,),
                        // ),
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
                                setState(() {
                                  isLoading = true;
                                });
                                StockingProvider stockingProvider =
                                    Provider.of<StockingProvider>(context,
                                        listen: false);
                                AuthProvider authProvider =
                                    Provider.of<AuthProvider>(context,
                                        listen: false);
                                ItemProvider itemProvider =
                                    Provider.of<ItemProvider>(context,
                                        listen: false);
                                DateTime dateToday = DateTime.now();
                                String date =
                                    dateToday.toString().substring(0, 10);
                                var stockingModel = StockingModel(
                                    barcode: stockargumen.itemModel.barcode,
                                    inputBy: authProvider.user!.username,
                                    date: date,
                                    qty: counter,
                                    type:
                                        stockargumen.isStockIn ? "IN" : "OUT");
                                if (await stockingProvider.sendStocking(
                                    authProvider.user!.accessToken,
                                    stockingModel)) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await itemProvider.getProject(
                                      authProvider.user!.accessToken);
                                  await itemProvider.getTotalOut(
                                      authProvider.user!.accessToken);
                                  await itemProvider.getTotalIn(
                                      authProvider.user!.accessToken);
                                  Timer(
                                      const Duration(seconds: 3),
                                      () => {
                                            Navigator.pushNamed(
                                                context, "/home")
                                          });
                                  showModalBottomSheet(
                                      isDismissible: false,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(15),
                                              topLeft: Radius.circular(15))),
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 242.h,
                                          decoration: BoxDecoration(
                                              color: success,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(15),
                                                      topLeft:
                                                          Radius.circular(15))),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 125.w,
                                              ),
                                              Image.asset(
                                                "assets/finish-scan.png",
                                                width: 363.w,
                                                height: 242.h,
                                              ),
                                              SizedBox(
                                                width: 35.w,
                                              ),
                                              Expanded(
                                                  child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    stockargumen.isStockIn
                                                        ? "Tambah Stock In Berhasil"
                                                        : "Tambah Stock Out Berhasil",
                                                    style: titleText.copyWith(
                                                        color: white),
                                                  ),
                                                  Text(
                                                    "Silahkan Check Kembali Stock di halaman Berikutnya",
                                                    style: normalText.copyWith(
                                                        color: white),
                                                  )
                                                ],
                                              ))
                                            ],
                                          ),
                                        );
                                      });
                                } else {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  showModalBottomSheet(
                                      isDismissible: false,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(15),
                                              topLeft: Radius.circular(15))),
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 242.h,
                                          decoration: BoxDecoration(
                                              color: red,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(15),
                                                      topLeft:
                                                          Radius.circular(15))),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 125.w,
                                              ),
                                              Image.asset(
                                                "assets/finish-scan.png",
                                                width: 363.w,
                                                height: 242.h,
                                              ),
                                              SizedBox(
                                                width: 35.w,
                                              ),
                                              Expanded(
                                                  child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    stockargumen.isStockIn
                                                        ? "Tambah Stock In Gagal"
                                                        : "Tambah Stock Out Gagal",
                                                    style: titleText.copyWith(
                                                        color: white),
                                                  ),
                                                  Text(
                                                    "Silahkan Check Kembali Stock di halaman Berikutnya",
                                                    style: normalText.copyWith(
                                                        color: white),
                                                  )
                                                ],
                                              ))
                                            ],
                                          ),
                                        );
                                      });
                                }
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
                    )),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    ));
  }
}
