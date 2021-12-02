part of 'pages.dart';

class StockingPage extends StatefulWidget {
  const StockingPage({Key? key}) : super(key: key);

  @override
  _StockingPageState createState() => _StockingPageState();
}

class _StockingPageState extends State<StockingPage> {
  @override
  Widget build(BuildContext context) {
    final itemModel = ModalRoute.of(context)!.settings.arguments as ItemModel;
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
                      Text("Melakukan Stock In,", style: normalText.copyWith(fontSize: 14.sp),),
                      Text(itemModel.name, style: titleText,),
                      Text(itemModel.barcode, style: titleText,),
                      SizedBox(
                        height: 5.h,
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
                    width: 200.w,
                    height: 150.w,
                    child: Image.network(itemModel.image_path, width: 150.w, height: 150.h,),
                  ),
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
                        Image.asset("assets/stock-in.png", width: 76.w, height: 60.h,),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text("Stock In", style: normalText.copyWith(color: Colors.white),)
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
            Container(
              margin: EdgeInsets.only(top: 10.h),
              padding: EdgeInsets.all(10.h),
              width: 100.sw,
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
                              child: Icon(Icons.qr_code_scanner_rounded, size: 25.w,),
                            ),
                            SizedBox(
                              width: 25.w,
                            ),
                            Expanded(
                              child: TextFormField(
                                style: normalText,
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
                    child: Column(
                      children: [
                        Image.asset("assets/waiting-scan.png", width: 493.w, height: 150.h,),
                        Text("Barang Masih Kosong, Jangan Khawatir ! Arahkan Scanner Ke Barang Untuk Melakukan Stock In", style: normalText, textAlign: TextAlign.center,)
                      ],
                    )
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
