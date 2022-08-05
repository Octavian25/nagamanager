part of 'pages.dart';

class DetailStockPage extends StatefulWidget {
  bool isStockIn;
  DetailStockPage({Key? key, this.isStockIn = true}) : super(key: key);

  @override
  _DetailStockPageState createState() => _DetailStockPageState();
}

class _DetailStockPageState extends State<DetailStockPage> {
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
  bool isStockIn = false;
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
    ItemProvider chart = Provider.of<ItemProvider>(context, listen: false);
    LocationProvider locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    String token =
        Provider.of<AuthProvider>(context, listen: false).user!.accessToken;
    if (await chart.getDetailStock(
        token,
        startDate,
        endDate,
        isStockIn ? "IN" : "OUT",
        locationProvider.selectedLocation?.locationCode ?? "-")) {
      showToast("Data Berhasil Diperbarui", false);
    }
  }

  void _onSelected() async {
    ItemProvider chart = Provider.of<ItemProvider>(context, listen: false);
    String token =
        Provider.of<AuthProvider>(context, listen: false).user!.accessToken;
    LocationProvider locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    if (await chart.getDetailStock(
        token,
        startDate,
        endDate,
        isStockIn ? "IN" : "OUT",
        locationProvider.selectedLocation?.locationCode ?? "-")) {
      showToast("Data Berhasil Diperbarui", false);
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isStockIn = widget.isStockIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    ItemProvider itemProvider = Provider.of<ItemProvider>(context);
    return LayoutBuilder(builder: (context, constrains) {
      if (constrains.maxWidth < 600) {
        return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: true,
                  // false = user must tap button, true = tap outside dialog
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: Text('Filter Barang', style: normalTextMobile),
                      content: FilterBarangWidget(),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Close', style: normalTextMobile),
                          onPressed: () {
                            Navigator.of(dialogContext)
                                .pop(); // Dismiss alert dialog
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Icon(Icons.sort_rounded),
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 40.w, right: 40.w, bottom: 40.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
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
                                ],
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, "/dashboard");
                              },
                            ),
                          ],
                        )),
                    SizedBox(
                      child: Row(children: [
                        const Icon(Iconsax.box),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                              isStockIn
                                  ? 'Detail Stock In'
                                  : 'Detail Stock Out',
                              style: titleTextMobile),
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
                                normalTextMobile.copyWith(color: Colors.black),
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
                                    startDate =
                                        Helper.getToday.decrement(value: 7);
                                    endDate = Helper.getToday.normal();
                                    dropdownValue = newValue!;
                                  });
                                  _onSelected();
                                  break;
                                case "Bulanan":
                                  setState(() {
                                    startDate =
                                        Helper.getToday.decrement(value: 30);
                                    endDate = Helper.getToday.normal();
                                    dropdownValue = newValue!;
                                  });
                                  _onSelected();
                                  break;
                                case "Tahunan":
                                  setState(() {
                                    startDate =
                                        Helper.getToday.decrement(value: 365);
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
                                .map<DropdownMenuItem<String>>((String value) {
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
                      height: 8.h,
                    ),
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: "#DAE7F0".toColor())),
                          child: itemProvider.listDetailStock
                                  .where((element) => element.isShow == true)
                                  .toList()
                                  .isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Lottie.asset(
                                          "assets/empty_state.json",
                                          fit: BoxFit.cover,
                                          width: 500.w),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Center(
                                        child: Text('Data Kosong',
                                            style: normalText.copyWith(
                                                fontSize: 50.sp))),
                                    Center(
                                        child: Text(
                                            'Coba Pilih Rentang Tanggal Yang Lain..',
                                            style: normalText.copyWith(
                                                fontSize: 30.sp))),
                                  ],
                                )
                              : ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      title: Text(
                                          itemProvider.listDetailStock
                                              .where((element) =>
                                                  element.isShow == true)
                                              .toList()[index]
                                              .name,
                                          style: normalTextMobile),
                                      subtitle: Text(
                                          "${itemProvider.listDetailStock.where((element) => element.isShow == true).toList()[index].barcode} / ${NumberFormat.currency(symbol: "Rp. ", decimalDigits: 0).format(itemProvider.listDetailStock.where((element) => element.isShow == true).toList()[index].price)} / ${itemProvider.listDetailStock.where((element) => element.isShow == true).toList()[index].type}",
                                          style: normalTextMobile),
                                      trailing: Text(
                                          itemProvider.listDetailStock
                                              .where((element) =>
                                                  element.isShow == true)
                                              .toList()[index]
                                              .totalStockIn
                                              .toString(),
                                          style: titleTextMobile),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const Divider();
                                  },
                                  itemCount: itemProvider.listDetailStock
                                      .where(
                                          (element) => element.isShow == true)
                                      .toList()
                                      .length)),
                    )
                  ],
                ),
              ),
            ));
      } else {
        return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: true,
                  // false = user must tap button, true = tap outside dialog
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: Text('Filter Barang'),
                      content: FilterBarangWidget(),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Close'),
                          onPressed: () {
                            Navigator.of(dialogContext)
                                .pop(); // Dismiss alert dialog
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Icon(Icons.sort_rounded),
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
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
                    SizedBox(
                      child: Row(children: [
                        const Icon(Iconsax.box),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                              isStockIn
                                  ? 'Detail Stock In'
                                  : 'Detail Stock Out',
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
                            style: normalText.copyWith(color: Colors.black),
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
                                    startDate =
                                        Helper.getToday.decrement(value: 7);
                                    endDate = Helper.getToday.normal();
                                    dropdownValue = newValue!;
                                  });
                                  _onSelected();
                                  break;
                                case "Bulanan":
                                  setState(() {
                                    startDate =
                                        Helper.getToday.decrement(value: 30);
                                    endDate = Helper.getToday.normal();
                                    dropdownValue = newValue!;
                                  });
                                  _onSelected();
                                  break;
                                case "Tahunan":
                                  setState(() {
                                    startDate =
                                        Helper.getToday.decrement(value: 365);
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
                                .map<DropdownMenuItem<String>>((String value) {
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
                      height: 8.h,
                    ),
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: "#DAE7F0".toColor())),
                          child: itemProvider.listDetailStock
                                  .where((element) => element.isShow == true)
                                  .toList()
                                  .isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Lottie.asset(
                                          "assets/empty_state.json",
                                          fit: BoxFit.cover,
                                          width: 500.w),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Center(
                                        child: Text('Data Kosong',
                                            style: normalText.copyWith(
                                                fontSize: 40.sp))),
                                    Center(
                                        child: Text(
                                            'Coba Pilih Rentang Tanggal Yang Lain..',
                                            style: normalText.copyWith(
                                                fontSize: 15.sp))),
                                  ],
                                )
                              : ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      title: Text(itemProvider.listDetailStock
                                          .where((element) =>
                                              element.isShow == true)
                                          .toList()[index]
                                          .name),
                                      subtitle: Text(
                                          "${itemProvider.listDetailStock.where((element) => element.isShow == true).toList()[index].barcode} / ${NumberFormat.currency(symbol: "Rp. ", decimalDigits: 0).format(itemProvider.listDetailStock.where((element) => element.isShow == true).toList()[index].price)} / ${itemProvider.listDetailStock.where((element) => element.isShow == true).toList()[index].type}"),
                                      trailing: Text(
                                          itemProvider.listDetailStock
                                              .where((element) =>
                                                  element.isShow == true)
                                              .toList()[index]
                                              .totalStockIn
                                              .toString(),
                                          style: titleText),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const Divider();
                                  },
                                  itemCount: itemProvider.listDetailStock
                                      .where(
                                          (element) => element.isShow == true)
                                      .toList()
                                      .length)),
                    )
                  ],
                ),
              ),
            ));
      }
    });
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
}
