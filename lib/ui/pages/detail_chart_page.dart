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

  @override
  Widget build(BuildContext context) {
    ChartProvider chartProvider = Provider.of<ChartProvider>(context);
    int stockLength = Provider.of<ChartProvider>(context)
        .chartDetailBarangModel!
        .stock
        .length;
    String barcode = Provider.of<ChartProvider>(context).barcodeSelected;
    ItemModel itemModel = Provider.of<ItemProvider>(context)
        .item!
        .firstWhere((element) => element.barcode == barcode);
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                        onPressed: () {
                          Navigator.pushNamed(context, "/dashboard");
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: red, elevation: 0),
                        child: Row(
                          children: [
                            const Icon(Iconsax.paperclip,
                                color: Colors.white, size: 20),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              'Create PDF',
                              style: normalText.copyWith(color: Colors.white),
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
                                  border:
                                      Border.all(color: "#DAE7F0".toColor())),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: itemModel.imagePath == "-"
                                          ? Image.asset(
                                              "assets/empty-image.png",
                                              fit: BoxFit.contain)
                                          : Image.network(itemModel.imagePath,
                                              fit: BoxFit.contain),
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Text(itemModel.name,
                                      style: normalText.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18.sp)),
                                  Text("STOCK : ${itemModel.qty.toString()}",
                                      style:
                                          normalText.copyWith(fontSize: 14.sp)),
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
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  elevation: 16,
                                  style:
                                      normalText.copyWith(color: Colors.black),
                                  underline: Container(),
                                  onChanged: (String? newValue) {
                                    switch (newValue) {
                                      case "Harian":
                                        setState(() {
                                          startDate = Helper.getToday.normal();
                                          endDate = Helper.getToday.normal();
                                          dropdownValue = newValue!;
                                        });
                                        _onSelected();
                                        break;
                                      case "Mingguan":
                                        setState(() {
                                          startDate = Helper.getToday
                                              .decrement(value: 7);
                                          endDate = Helper.getToday.normal();
                                          dropdownValue = newValue!;
                                        });
                                        _onSelected();
                                        break;
                                      case "Bulanan":
                                        setState(() {
                                          startDate = Helper.getToday
                                              .decrement(value: 30);
                                          endDate = Helper.getToday.normal();
                                          dropdownValue = newValue!;
                                        });
                                        _onSelected();
                                        break;
                                      case "Tahunan":
                                        setState(() {
                                          startDate = Helper.getToday
                                              .decrement(value: 365);
                                          endDate = Helper.getToday.normal();
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
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: "#DAE7F0".toColor())),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        const Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 30),
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
}
