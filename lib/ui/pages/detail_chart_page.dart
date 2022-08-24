part of 'pages.dart';

class DetailChartPage extends StatefulWidget {
  const DetailChartPage({Key? key}) : super(key: key);

  @override
  _DetailChartPageState createState() => _DetailChartPageState();
}

class _DetailChartPageState extends State<DetailChartPage> {
  String dropdownValue = "Mingguan";
  List<String> dropdownItem = [
    'Harian',
    'Mingguan',
    'Bulanan',
    'Tahunan',
    "Pilih Tanggal.."
  ];
  String startDate = "";
  String endDate = "";
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    PickerDateRange pickerDateRange = args.value;
    setState(() {
      startDate = Helper.dateToString(pickerDateRange.startDate);
    });
    if (pickerDateRange.endDate != null) {
      setState(() {
        endDate = Helper.dateToString(pickerDateRange.endDate);
      });
    }
    dropdownItem.removeWhere((element) => element.contains("-"));
    dropdownItem.add(
        "${Helper.convertDate(startDate)} - ${Helper.convertDate(endDate)}");
    dropdownValue =
        "${Helper.convertDate(startDate)} - ${Helper.convertDate(endDate)}";
  }

  void _onSelectedDate() async {
    Navigator.pop(context);
    ChartProvider chart = Provider.of<ChartProvider>(context, listen: false);
    String token =
        Provider.of<AuthProvider>(context, listen: false).user!.accessToken;
    chart.updateDate(startDate: startDate, endDate: endDate);
    if (await chart.getDetailChart(
        token, chart.barcodeSelected, startDate, endDate)) {
      if (await chart.getChartAnnual(token, chart.barcodeSelected)) {
        showToast("Data Berhasil Diperbarui", false);
      }
    }
  }

  void _onSelected() async {
    ChartProvider chart = Provider.of<ChartProvider>(context, listen: false);
    String token =
        Provider.of<AuthProvider>(context, listen: false).user!.accessToken;
    if (await chart.getDetailChart(
        token, chart.barcodeSelected, startDate, endDate)) {
      if (await chart.getChartAnnual(token, chart.barcodeSelected)) {
        showToast("Data Berhasil Diperbarui", false);
      }
    }
  }

  void generatePDF(Uint8List pdfInBytes) {
    html.AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(pdfInBytes)}")
      ..setAttribute("download", "Laporan Stock.pdf")
      ..click();
  }

  @override
  Widget build(BuildContext context) {
    ChartProvider chartProvider = Provider.of<ChartProvider>(context);
    int stockLength = Provider.of<ChartProvider>(context)
        .chartDetailBarangModel!
        .stock
        .length;
    String barcode = Provider.of<ChartProvider>(context).barcodeSelected;
    ItemModel? itemModel = Provider.of<ItemProvider>(context).item!.firstWhere(
        (element) => element.barcode == barcode,
        orElse: () => ItemModel(
            imagePath: "-",
            qty: 0,
            barcode: "0",
            isDifference: false,
            locationCode: "-",
            lastOpname: "0",
            name: "0",
            price: 100,
            type: "-",
            categoryCode: "-",
            subCategoryCode: "-",
            id: '-'));
    return LayoutBuilder(builder: (context, constrains) {
      if (constrains.maxWidth < 600) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(40.w),
                child: Column(
                  children: [
                    SizedBox(
                        height: 40.h,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: "#E8ECF2".toColor(), elevation: 0),
                              child: Row(
                                children: [
                                  Icon(Iconsax.arrow_square_left,
                                      color: text, size: 20),
                                ],
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, "/dashboard");
                              },
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      height: 40.h,
                      width: 1.sw,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: green, elevation: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Iconsax.paperclip,
                                      color: Colors.white, size: 20),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    'Create Excel',
                                    style: normalTextMobile.copyWith(
                                        color: Colors.white),
                                  )
                                ],
                              ),
                              onPressed: _generateExcel,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: red, elevation: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Iconsax.paperclip,
                                      color: Colors.white, size: 20),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    'Create PDF',
                                    style: normalTextMobile.copyWith(
                                        color: Colors.white),
                                  )
                                ],
                              ),
                              onPressed: () {
                                if (stockLength < 2) {
                                  showToast(
                                      "History Barang Kosong, PDF Belum Tersedia",
                                      true);
                                } else {
                                  Navigator.pushNamed(context, "/create-pdf");
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: 1.sw,
                          height: 230.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              SizedBox(
                                child: Row(children: [
                                  const Icon(Iconsax.box),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text('Detail Barang', style: normalTextMobile)
                                ]),
                                width: double.infinity,
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(20.w),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: "#DAE7F0".toColor())),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            child: itemModel.imagePath == "-"
                                                ? Image.asset(
                                                    "assets/empty-image.png",
                                                    fit: BoxFit.contain)
                                                : Image.network(
                                                    itemModel.imagePath,
                                                    fit: BoxFit.contain),
                                            width: double.infinity,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Expanded(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(itemModel.name,
                                              style: normalTextMobile.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 40.sp),
                                              maxLines: 2,
                                              textAlign: TextAlign.center),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Column(
                                            children: [
                                              Icon(
                                                Iconsax.box,
                                                size: 30.sp,
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Text(itemModel.qty.toString(),
                                                  style:
                                                      normalTextMobile.copyWith(
                                                          fontSize: 30.sp)),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Icon(
                                                Iconsax.barcode,
                                                size: 30.sp,
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Text(itemModel.barcode,
                                                  style:
                                                      normalTextMobile.copyWith(
                                                          fontSize: 30.sp)),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Icon(
                                                Iconsax.dollar_circle,
                                                size: 30.sp,
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Text(
                                                  NumberFormat.currency(
                                                          symbol: "Rp. ",
                                                          decimalDigits: 0)
                                                      .format(itemModel.price),
                                                  style:
                                                      normalTextMobile.copyWith(
                                                          fontSize: 30.sp))
                                            ],
                                          ),
                                        ],
                                      ))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        SizedBox(
                          width: 1.sw,
                          height: 230.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Row(children: [
                                  const Icon(Iconsax.chart),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text('Daily Stock Report',
                                        style: normalTextMobile),
                                  ),
                                  const Spacer(),
                                  Expanded(
                                    flex: 2,
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: dropdownValue,
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      elevation: 16,
                                      style: normalTextMobile.copyWith(
                                          color: Colors.black),
                                      underline: Container(),
                                      onChanged: (String? newValue) {
                                        switch (newValue) {
                                          case "Harian":
                                            setState(() {
                                              startDate =
                                                  Helper.getToday.normal();
                                              endDate =
                                                  Helper.getToday.normal();
                                              dropdownValue = newValue!;
                                            });
                                            _onSelected();
                                            break;
                                          case "Mingguan":
                                            setState(() {
                                              startDate = Helper.getToday
                                                  .decrement(value: 7);
                                              endDate =
                                                  Helper.getToday.normal();
                                              dropdownValue = newValue!;
                                            });
                                            _onSelected();
                                            break;
                                          case "Bulanan":
                                            setState(() {
                                              startDate = Helper.getToday
                                                  .decrement(value: 30);
                                              endDate =
                                                  Helper.getToday.normal();
                                              dropdownValue = newValue!;
                                            });
                                            _onSelected();
                                            break;
                                          case "Tahunan":
                                            setState(() {
                                              startDate = Helper.getToday
                                                  .decrement(value: 365);
                                              endDate =
                                                  Helper.getToday.normal();
                                              dropdownValue = newValue!;
                                            });
                                            _onSelected();
                                            break;
                                          case "Pilih Tanggal..":
                                            showDateDialog(context);
                                            break;
                                        }
                                      },
                                      items: dropdownItem
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,
                                              style: normalTextMobile.copyWith(
                                                  color: value == dropdownValue
                                                      ? blue
                                                      : Colors.black)),
                                        );
                                      }).toList(),
                                    ),
                                  )
                                ]),
                                width: double.infinity,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                                color: "#DAE7F0".toColor())),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            const Expanded(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 30),
                                                child:
                                                    DetailChartWidgetMobile(),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 230.h,
                      width: 1.sw,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          SizedBox(
                            child: Row(children: [
                              const Icon(Iconsax.trend_down),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text('Annual Stock In', style: normalTextMobile)
                            ]),
                            width: double.infinity,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(40.w),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border:
                                      Border.all(color: "#DAE7F0".toColor())),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: ListView.separated(
                                        separatorBuilder:
                                            (BuildContext context, index) {
                                          return SizedBox(
                                            height: 20.h,
                                          );
                                        },
                                        physics: const BouncingScrollPhysics(),
                                        itemCount:
                                            chartProvider.chartAnnualIn.length,
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          return headerPieChartMobile(
                                              chartProvider
                                                  .chartAnnualIn[index],
                                              index);
                                        }),
                                  ),
                                  const Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: EdgeInsets.all(30),
                                        child: PieChartWidgetMobile(),
                                      ))
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    SizedBox(
                      width: 1.sw,
                      height: 230.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          SizedBox(
                            child: Row(children: [
                              const Icon(Iconsax.trend_up),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text('Annual Stock Out', style: normalTextMobile)
                            ]),
                            width: double.infinity,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(40.w),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border:
                                      Border.all(color: "#DAE7F0".toColor())),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: ListView.separated(
                                        separatorBuilder:
                                            (BuildContext context, index) {
                                          return SizedBox(
                                            height: 20.h,
                                          );
                                        },
                                        physics: const BouncingScrollPhysics(),
                                        itemCount:
                                            chartProvider.chartAnnualOut.length,
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          return headerPieChartMobile(
                                              chartProvider
                                                  .chartAnnualOut[index],
                                              index);
                                        }),
                                  ),
                                  const Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: PieChartOutWidgetMobile(),
                                      ))
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      } else {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  SizedBox(
                      height: 50.h,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () async {
                              Navigator.pushNamed(context, "/dashboard");
                            },
                            borderRadius: BorderRadius.circular(10.r),
                            child: Ink(
                              height: 45.h,
                              width: 90.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: "#E8ECF2".toColor()),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 15.w,
                                  ),
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
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: _generateExcel,
                            borderRadius: BorderRadius.circular(10.r),
                            child: Ink(
                              height: 45.h,
                              width: 120.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: green),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    'Create Excel',
                                    style: normalText.copyWith(
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          InkWell(
                            onTap: () async {
                              if (stockLength < 2) {
                                showToast(
                                    "History Barang Kosong, PDF Belum Tersedia",
                                    true);
                              } else {
                                final GenerateLaporanStock res =
                                    GenerateLaporanStock(
                                        context, chartProvider);
                                final result = await compute(
                                    res.generateLaporanTracking, null);
                                generatePDF(result);
                              }
                            },
                            borderRadius: BorderRadius.circular(10.r),
                            child: Ink(
                              height: 45.h,
                              width: 120.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: red),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    'Create PDF',
                                    style: normalText.copyWith(
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                  Flexible(
                    child: Row(
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              SizedBox(
                                child: Row(children: [
                                  const Icon(Iconsax.box),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text('Detail Barang', style: titleText)
                                ]),
                                width: double.infinity,
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: "#DAE7F0".toColor())),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            child: itemModel.imagePath == "-"
                                                ? Image.asset(
                                                    "assets/empty-image.png",
                                                    fit: BoxFit.contain)
                                                : Image.network(
                                                    itemModel.imagePath,
                                                    fit: BoxFit.contain),
                                            width: double.infinity,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Text(itemModel.name,
                                          style: normalText.copyWith(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18.sp),
                                          maxLines: 2,
                                          textAlign: TextAlign.center),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Wrap(
                                        alignment: WrapAlignment.center,
                                        children: [
                                          Icon(
                                            Iconsax.box,
                                            size: 18.sp,
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Text(itemModel.qty.toString(),
                                              style: normalText.copyWith(
                                                  fontSize: 14.sp)),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Icon(
                                            Iconsax.barcode,
                                            size: 18.sp,
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Text(itemModel.barcode,
                                              style: normalText.copyWith(
                                                  fontSize: 14.sp)),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Icon(
                                            Iconsax.dollar_circle,
                                            size: 18.sp,
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Text(
                                              NumberFormat.currency(
                                                      symbol: "Rp. ",
                                                      decimalDigits: 0)
                                                  .format(itemModel.price),
                                              style: normalText.copyWith(
                                                  fontSize: 14.sp))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          flex: 1,
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Row(children: [
                                  const Icon(Iconsax.chart),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text('Daily Stock Report',
                                        style: titleText),
                                  ),
                                  const Spacer(),
                                  Expanded(
                                    flex: 2,
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: dropdownValue,
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      elevation: 16,
                                      style: normalText.copyWith(
                                          color: Colors.black),
                                      underline: Container(),
                                      onChanged: (String? newValue) {
                                        switch (newValue) {
                                          case "Harian":
                                            setState(() {
                                              startDate =
                                                  Helper.getToday.normal();
                                              endDate =
                                                  Helper.getToday.normal();
                                              dropdownValue = newValue!;
                                            });
                                            _onSelected();
                                            break;
                                          case "Mingguan":
                                            setState(() {
                                              startDate = Helper.getToday
                                                  .decrement(value: 7);
                                              endDate =
                                                  Helper.getToday.normal();
                                              dropdownValue = newValue!;
                                            });
                                            _onSelected();
                                            break;
                                          case "Bulanan":
                                            setState(() {
                                              startDate = Helper.getToday
                                                  .decrement(value: 30);
                                              endDate =
                                                  Helper.getToday.normal();
                                              dropdownValue = newValue!;
                                            });
                                            _onSelected();
                                            break;
                                          case "Tahunan":
                                            setState(() {
                                              startDate = Helper.getToday
                                                  .decrement(value: 365);
                                              endDate =
                                                  Helper.getToday.normal();
                                              dropdownValue = newValue!;
                                            });
                                            _onSelected();
                                            break;
                                          case "Pilih Tanggal..":
                                            showDateDialog(context);
                                            break;
                                        }
                                      },
                                      items: dropdownItem
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,
                                              style: normalText.copyWith(
                                                  color: value == dropdownValue
                                                      ? blue
                                                      : Colors.black)),
                                        );
                                      }).toList(),
                                    ),
                                  )
                                ]),
                                width: double.infinity,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                                color: "#DAE7F0".toColor())),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            const Expanded(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 30),
                                                child: DetailChartWidget(),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          flex: 2,
                        ),
                      ],
                    ),
                    flex: 3,
                  ),
                  Flexible(
                    flex: 3,
                    child: Row(
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              SizedBox(
                                child: Row(children: [
                                  const Icon(Iconsax.trend_down),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text('Annual Stock In', style: titleText)
                                ]),
                                width: double.infinity,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: "#DAE7F0".toColor())),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: ListView.separated(
                                            separatorBuilder:
                                                (BuildContext context, index) {
                                              return SizedBox(
                                                height: 20.h,
                                              );
                                            },
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemCount: chartProvider
                                                .chartAnnualIn.length,
                                            itemBuilder:
                                                (BuildContext context, index) {
                                              return headerPieChart(
                                                  chartProvider
                                                      .chartAnnualIn[index],
                                                  index);
                                            }),
                                      ),
                                      const Expanded(
                                          flex: 2, child: PieChartWidget())
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          flex: 2,
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              SizedBox(
                                child: Row(children: [
                                  const Icon(Iconsax.trend_up),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text('Annual Stock Out', style: titleText)
                                ]),
                                width: double.infinity,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: "#DAE7F0".toColor())),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: ListView.separated(
                                            separatorBuilder:
                                                (BuildContext context, index) {
                                              return SizedBox(
                                                height: 20.h,
                                              );
                                            },
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemCount: chartProvider
                                                .chartAnnualOut.length,
                                            itemBuilder:
                                                (BuildContext context, index) {
                                              return headerPieChart(
                                                  chartProvider
                                                      .chartAnnualOut[index],
                                                  index);
                                            }),
                                      ),
                                      const Expanded(
                                          flex: 2, child: PieChartOutWidget())
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          flex: 2,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    });
  }

  Future<void> _generateExcel() async {
    ChartDetailBarangModel chartDetailBarangModel =
        Provider.of<ChartProvider>(context, listen: false)
            .chartDetailBarangModel!;
    final excel.Workbook workbook = excel.Workbook();
    final excel.Worksheet worksheet = workbook.worksheets[0];
    if (chartDetailBarangModel.historyDetail!.isNotEmpty) {
      worksheet.getRangeByName("A1").setText("TANGGAL");
      worksheet.getRangeByName("B1").setText("STOCK IN");
      worksheet.getRangeByName("C1").setText("STOCK OUT");
      worksheet.getRangeByName("D1").setText("AVAILABLE");
      for (var i = 0; i < chartDetailBarangModel.historyDetail!.length; i++) {
        int index = i + 2;
        worksheet
            .getRangeByName("A$index")
            .setText(chartDetailBarangModel.historyDetail![i].tanggal);
        worksheet.getRangeByName("B$index").setNumber(
            chartDetailBarangModel.historyDetail![i].stockIn.toDouble());
        worksheet.getRangeByName("C$index").setNumber(
            chartDetailBarangModel.historyDetail![i].stockOut.toDouble());
        worksheet.getRangeByName("D$index").setNumber(
            chartDetailBarangModel.historyDetail![i].available.toDouble());
      }
      int lastIndex = chartDetailBarangModel.historyDetail!.length + 1;
      worksheet.getRangeByName("A$lastIndex").setText("TOTAL");
      worksheet
          .getRangeByName("B$lastIndex")
          .setFormula("=SUM(B2:B${lastIndex - 1})");
      worksheet
          .getRangeByName("C$lastIndex")
          .setFormula("=SUM(C2:C${lastIndex - 1})");
      worksheet
          .getRangeByName("D$lastIndex")
          .setFormula("=SUM(D2:D${lastIndex - 1})");
      final List<int> bytes = workbook.saveAsStream();
      saveFile(bytes, "Daily Stock Report.xlsx");
    }
  }

  void saveFile(bytes, String name) async {
    if (kIsWeb) {
      html.AnchorElement(
          href:
              "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
        ..setAttribute("download", "Laporan Stock.xlsx")
        ..click();
    } else {
      Directory appDocument = await getApplicationDocumentsDirectory();
      File("${appDocument.path}/$name").writeAsBytes(bytes);
      openFile("${appDocument.path}/$name");
    }
  }

  void openFile(String path) {
    OpenFile.open(path);
  }

  Future<dynamic> showDateDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: _onSelectedDate,
                  child: const Text('Pilih Tanggal'),
                )
              ],
              content: Container(
                width: 400.w,
                height: 400.w,
                color: Colors.white,
                child: SfDateRangePicker(
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.range,
                ),
              ),
            ));
  }

  Container HistoryStockingItems(HistoryDetail historyDetail) {
    return Container(
      height: 80.h,
      padding: EdgeInsets.only(left: 20.w),
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
          color: backgroundItem, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Flexible(
              flex: 1,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('No Transaksi',
                        style: normalText.copyWith(
                            color: Colors.black.withOpacity(0.3))),
                    Text(historyDetail.trackNumber, style: normalText),
                  ],
                ),
              )),
          Flexible(
              flex: 1,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tanggal',
                        style: normalText.copyWith(
                            color: Colors.black.withOpacity(0.3))),
                    Text(historyDetail.tanggal, style: normalText),
                  ],
                ),
              )),
          Flexible(
              flex: 1,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jumlah In',
                        style: normalText.copyWith(
                            color: Colors.black.withOpacity(0.3))),
                    Text(historyDetail.stockIn.toString(), style: normalText),
                  ],
                ),
              )),
          Flexible(
              flex: 1,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jumlah Out',
                        style: normalText.copyWith(
                            color: Colors.black.withOpacity(0.3))),
                    Text(historyDetail.stockOut.toString(), style: normalText),
                  ],
                ),
              )),
          Flexible(
              flex: 1,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Available',
                        style: normalText.copyWith(
                            color: Colors.black.withOpacity(0.3))),
                    Text(historyDetail.available.toString(), style: normalText),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Row headerPieChart(ChartAnnual value, int index) {
    return Row(
      children: [
        Container(
          height: 15.h,
          width: 15.h,
          decoration: BoxDecoration(
              color: listColor[index], borderRadius: BorderRadius.circular(5)),
        ),
        SizedBox(
          width: 5.w,
        ),
        Text("${value.month} / ${value.value}", style: normalText),
      ],
    );
  }

  Row headerPieChartMobile(ChartAnnual value, int index) {
    return Row(
      children: [
        Container(
          height: 20.h,
          width: 20.h,
          decoration: BoxDecoration(
              color: listColor[index], borderRadius: BorderRadius.circular(5)),
        ),
        SizedBox(
          width: 15.w,
        ),
        Text("${value.month} / ${value.value}",
            style: normalTextMobile.copyWith(fontSize: 28.sp)),
      ],
    );
  }
}
