part of 'widgets.dart';

class AddBarangWidget extends StatefulWidget {
  bool isMobile;
  AddBarangWidget({Key? key, this.isMobile = false}) : super(key: key);

  @override
  _AddBarangWidgetState createState() => _AddBarangWidgetState();
}

class _AddBarangWidgetState extends State<AddBarangWidget> {
  String gambar = "";
  TextEditingController barcode = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController(text: "0");
  TextEditingController type = TextEditingController(text: "Pcs");
  TextEditingController qty = TextEditingController(text: "0");
  FocusNode nameFocus = FocusNode();
  FocusNode priceFocus = FocusNode();
  FocusNode typeFocus = FocusNode();
  FocusNode qtyFocus = FocusNode();
  String barcodeString = '';
  ScrollController scrollController = ScrollController();

  void _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 50);
      if (image != null) {
        var hasil = image.path;
        setState(() {
          gambar = hasil;
        });
      }
    }
  }

  void pickFile(String limiter) async {
    List<ItemModel> listItems = [];
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      var fields = [];
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String locationCode =
          sharedPreferences.getString(LocationProvider.KODE_LOKASI) ?? "-";
      if (!kIsWeb) {
        PlatformFile file = result.files.first;
        final input = File(file.path!).openRead();
        fields = await input
            .transform(utf8.decoder)
            .transform(CsvToListConverter(
                fieldDelimiter: limiter, shouldParseNumbers: false, eol: "\n"))
            .toList();
      } else {
        Uint8List? file = result.files.first.bytes;
        final input = Stream.value(List<int>.from(file!));
        fields = await input
            .transform(utf8.decoder)
            .transform(CsvToListConverter(
                fieldDelimiter: limiter, shouldParseNumbers: false, eol: "\n"))
            .toList();
      }
      for (var i = 0; i < fields.length; i++) {
        listItems.add(ItemModel(
            id: "-",
            locationCode: locationCode,
            name: fields[i][0],
            barcode: "-",
            imagePath: fields[i][3].toString().trim(),
            price: int.parse(fields[i][2]),
            qty: int.parse(fields[i][1]),
            type: fields[i][4].toString().trim(),
            isDifference: false,
            categoryCode: fields[i][5].toString().trim(),
            subCategoryCode: fields[i][6].toString().trim(),
            lastOpname: "-"));
      }
      if (await Provider.of<ItemProvider>(context, listen: false).batchAddItems(
          Provider.of<AuthProvider>(context, listen: false).user!.accessToken,
          listItems)) {
        var message = Provider.of<ItemProvider>(context, listen: false)
            .listGeneratedBarcode
            .join(",");
        var directory = await getApplicationDocumentsDirectory();
        var file = File('${directory.path}/autoprint-barcode.txt');
        file.writeAsString(
          message,
          flush: true,
        );
        // OpenFile.open('${directory.path}/faktur-saldo-awal.txt', type: "txt");
        Navigator.pop(context);
        showDialog<void>(
          context: context,
          barrierDismissible: true,
          // false = user must tap button, true = tap outside dialog
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(5.h),
              title: Text(
                'Report Duplicate Item : ',
                style: titleText,
              ),
              content: SizedBox(
                  height: 340.h,
                  width: 300.w,
                  child: Column(
                    children: [
                      Expanded(
                        child: Scrollbar(
                          thumbVisibility: true,
                          controller: scrollController,
                          child: ListView(
                            controller: scrollController,
                            children: Provider.of<ItemProvider>(context,
                                    listen: false)
                                .duplicatedBatchResult
                                .map((e) => ListTile(
                                      title: Text("Barcode : $e"),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Text(
                        "Success Added : ${Provider.of<ItemProvider>(context, listen: false).successfullyAdded}",
                        style: titleText,
                      )
                    ],
                  )),
              actions: <Widget>[
                TextButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  },
                ),
              ],
            );
          },
        );
        showToast(
            "${Provider.of<ItemProvider>(context, listen: false).successfullyAdded} Barang Berhasil Ditambahkan , Terdapat Beberapa Barang yang Gagal : ${Provider.of<ItemProvider>(context, listen: false).duplicatedBatchResult.toString()} ",
            false);
        await Provider.of<ChartProvider>(context, listen: false)
            .getDashboardChart(
          Provider.of<AuthProvider>(context, listen: false).user!.accessToken,
        );
        setState(() {});
      } else {
        showToast("Import CSV Gagal", true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ItemProvider itemProvider = Provider.of<ItemProvider>(context);
    // ChartProvider chartProvider = Provider.of<ChartProvider>(context);
    // String token = Provider.of<AuthProvider>(context).user!.accessToken;
    bool isLoading = Provider.of<LoadingProvider>(context).isLoading;
    if (widget.isMobile) {
      return SizedBox(
        height: 420.h,
        width: 900.w,
        child: isLoading
            ? Column(
                children: [
                  Expanded(
                    child: Lottie.asset("assets/sending.json",
                        fit: BoxFit.contain),
                  ),
                  Text('Sedang Mengirim Data . . ',
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.w700)),
                ],
              )
            : Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        pickFile(",");
                      },
                      child: const Text(
                        "Import CSV Comma Delimited",
                        textAlign: TextAlign.center,
                      )),
                  20.verticalSpace,
                  TextButton(
                      onPressed: () {
                        pickFile(";");
                      },
                      child: const Text(
                        "Import CSV Semicolon Delimiter",
                        textAlign: TextAlign.center,
                      )),
                ],
              )),
      );
    } else {
      return Container(
        height: 420.h,
        width: 900.w,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: isLoading
            ? Column(
                children: [
                  Expanded(
                    child: Lottie.asset("assets/sending.json",
                        fit: BoxFit.contain),
                  ),
                  Text('Sedang Mengirim Data . . ',
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.w700)),
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5.h,
                              ),
                              TextFieldCustom(
                                  controller: name,
                                  focus: nameFocus,
                                  title: "Name",
                                  width: double.infinity),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                children: [
                                  TextFieldCustom(
                                      controller: price,
                                      focus: priceFocus,
                                      title: "Price",
                                      width: 300.w),
                                  const Spacer(),
                                  TextFieldCustom(
                                      controller: qty,
                                      focus: qtyFocus,
                                      title: "Qty",
                                      width: 250.w),
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              TextFieldCustom(
                                  controller: type,
                                  focus: typeFocus,
                                  title: "Type",
                                  width: double.infinity),
                            ],
                          ),
                          flex: 3,
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                      ],
                    ),
                    20.verticalSpacingRadius,
                    SizedBox(
                      height: 53.h,
                      child: ElevatedButton.icon(
                          onPressed: () async {
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            String locationCode = sharedPreferences
                                    .getString(LocationProvider.KODE_LOKASI) ??
                                "-";
                            ItemModel payload = ItemModel(
                                id: "-",
                                locationCode: locationCode,
                                name: name.text,
                                barcode: "-",
                                imagePath: "-",
                                price: int.parse(price.text),
                                qty: int.parse(qty.text),
                                type: type.text,
                                isDifference: false,
                                categoryCode: "-",
                                subCategoryCode: "-",
                                lastOpname: "-");
                            if (await Provider.of<ItemProvider>(context,
                                    listen: false)
                                .batchAddItems(
                                    Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .user!
                                        .accessToken,
                                    [payload])) {
                              var message = Provider.of<ItemProvider>(context,
                                      listen: false)
                                  .listGeneratedBarcode
                                  .join(",");
                              var directory =
                                  await getApplicationDocumentsDirectory();
                              var file = File(
                                  '${directory.path}/autoprint-barcode.txt');
                              file.writeAsString(
                                message,
                                flush: true,
                              );
                              name.clear();
                              price.text = "0";
                              qty.text = "0";
                              type.text = "PCS";
                              nameFocus.requestFocus();
                            }
                          },
                          icon: const Icon(Icons.print_rounded,
                              color: Colors.white),
                          label: const Text("Simpan Barang & Print")),
                    ),
                    20.verticalSpacingRadius,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50.r,
                          child: TextButton(
                              onPressed: () {
                                pickFile(",");
                              },
                              child: const Text(
                                "Import CSV Comma Delimited",
                                textAlign: TextAlign.center,
                              )),
                        ),
                        20.verticalSpace,
                        SizedBox(
                          height: 50.r,
                          child: TextButton(
                              onPressed: () {
                                pickFile(";");
                              },
                              child: const Text(
                                "Import CSV Semicolon Delimiter",
                                textAlign: TextAlign.center,
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
      );
    }
  }
}
