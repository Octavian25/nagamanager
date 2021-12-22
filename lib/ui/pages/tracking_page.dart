part of 'pages.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({Key? key}) : super(key: key);

  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  var focusBarcode = FocusNode();
  final barcodeController = TextEditingController();
  var counter = 0;
  List<ItemModel> listTracking = [];
  String imageSelected = "";
  @override
  void initState() {
    // focusBarcode.requestFocus();
    Timer(Duration(seconds: 1), () => {
      SystemChannels.textInput.invokeMethod('TextInput.hide')
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ItemProvider itemProvider = Provider.of<ItemProvider>(context);
    final trackingIn = ModalRoute.of(context)!.settings.arguments as bool ;
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
                      Text(trackingIn ? "Melakukan Track In," : "Melakukan Track Out,", style: normalText.copyWith(fontSize: 14.sp),),
                      SizedBox(
                        height: 5.h,
                      ),
                      Container(
                        height: 45.h,
                        width: 150.w,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: red,
                              onPrimary: white
                          ),
                          onPressed: () => {
                            Navigator.pushNamed(context, "/home")
                          },
                          child: Row(
                            children: [
                              Icon(Icons.chevron_left_rounded, size: 25.w,),
                              SizedBox(
                                width: 15.w,
                              ),
                              Text("Kembali", style: normalText,),

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
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: CachedNetworkImage(
                      imageUrl: imageSelected,
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          Center(child: CircularProgressIndicator(value: downloadProgress.progress),),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      width: 100.w, height: 100.h,
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
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Flash(child: Text(counter.toString(), style: bigText.copyWith(color: white, fontSize: 60.sp, fontWeight: FontWeight.bold),),infinite: true, delay: Duration(seconds: 1), duration: Duration(seconds: 3), ),
                        SizedBox(
                          height: 7.h,
                        ),
                        Text(trackingIn ? "Track In" : "Track Out", style: normalText.copyWith(color: Colors.white),)
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 18.w,
                  ),
                ],
              ),
            ),
            Expanded(child:
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 10.h),
                padding: EdgeInsets.all(10.h),
                height: 532.h,
                width: 100.sw,
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
                                child: Icon(Icons.qr_code_scanner_rounded, size: 25.w,),
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
                                  onFieldSubmitted: (String data) {
                                    var ItemModel = itemProvider.item!.firstWhere((element) => element.barcode == data);
                                    listTracking.add(ItemModel);
                                    imageSelected = ItemModel.imagePath;
                                    setState(() {
                                      counter = counter + 1;
                                    });
                                    focusBarcode.unfocus();
                                    barcodeController.clear();
                                    focusBarcode.requestFocus();
                                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                                  },
                                  decoration: InputDecoration.collapsed(
                                    hintText: "Scan Your Barcode",
                                    hintStyle: normalText,
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                    Expanded(
                        child: counter == 0 ? Column(
                          children: [
                            Image.asset(counter > 0 ? "assets/progress-scan.png" : "assets/waiting-scan.png", width: 493.w, height: 296.h,),
                            Visibility(
                              visible: counter > 0,
                              child: Text(counter.toString(), style: bigText,),
                            ),
                            Visibility(
                              visible: counter > 0,
                              child: Text("Barang Masuk", style: titleText,),
                            ),
                            Visibility(
                                visible: counter == 0,
                                child: Text("Barang Masih Kosong, Jangan Khawatir ! Arahkan Scanner Ke Barang Untuk Melakukan Stock In", style: normalText, textAlign: TextAlign.center,)),
                            SizedBox(
                              height: 11.h,
                            ),
                            Visibility(
                              visible: counter > 0,
                              child: Container(
                                height: 45.h,
                                width: 441.w,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: blue,
                                      onPrimary: white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                      )
                                  ),
                                  onPressed: ()async{
                                    StockingProvider stockingProvider =
                                    Provider.of<StockingProvider>(context, listen: false);
                                    AuthProvider authProvider =
                                    Provider.of<AuthProvider>(context, listen: false);
                                    ItemProvider itemProvider =
                                    Provider.of<ItemProvider>(context, listen: false);
                                    DateTime dateToday =new DateTime.now();
                                    String date = dateToday.toString().substring(0,10);
                                  },
                                  child: Text("Simpan"),
                                ),
                              ),
                            )
                          ],
                        ) : ListView.builder(
                            itemCount: listTracking.length,
                            itemBuilder: (BuildContext context, int index){
                          return Container(
                            width: 873.w,
                            margin: EdgeInsets.symmetric(vertical: 16.h),
                            padding: EdgeInsets.symmetric(horizontal: 35.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(listTracking[index].barcode, style: normalText.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),),
                                Text(listTracking[index].name, style: normalText.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),),
                                Text("1", style: normalText.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),)
                              ],
                            ),
                          );
                        }),
                    ),
                    Visibility(
                      visible: counter > 0,
                      child: Container(
                        height: 45.h,
                        width: 441.w,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: blue,
                              onPrimary: white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)
                              )
                          ),
                          onPressed: ()async{
                            AuthProvider authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                            TrackingProvider trackingProvider =
                            Provider.of<TrackingProvider>(context, listen: false);
                            var result = await trackingProvider.sendTracking(token: authProvider.user!.accessToken, listBarang: listTracking, type: trackingIn ? "TRACK IN" : "TRACK OUT");
                            showModalBottomSheet(
                                isDismissible: false,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft:Radius.circular(15) )
                                ),
                                context: context, builder: (BuildContext context){
                              return BottomSheetTracking(trackingFeedback: result);
                            },);
                          },
                          child: Text("Simpan"),
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
}
