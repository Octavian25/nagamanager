part of 'widgets.dart';

class AddBarangWidget extends StatefulWidget {
  const AddBarangWidget({Key? key}) : super(key: key);

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
  String barcodeString = '';

  void _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      var hasil = await image.path;
      setState(() {
        gambar = hasil;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ItemProvider itemProvider = Provider.of<ItemProvider>(context);
    ChartProvider chartProvider = Provider.of<ChartProvider>(context);
    String token = Provider.of<AuthProvider>(context).user!.accessToken;
    bool isLoading = Provider.of<LoadingProvider>(context).isLoading;
    return Container(
      height: 420.h,
      width: 900.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: isLoading
          ? Column(
              children: [
                Expanded(
                  child:
                      Lottie.asset("assets/sending.json", fit: BoxFit.contain),
                ),
                Text('Sedang Mengirim Data . . ',
                    style: TextStyle(
                        fontSize: 18.sp, fontWeight: FontWeight.w700)),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 85.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Barcode",
                                    style: normalText,
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Container(
                                    height: 53.h,
                                    width: 390.w,
                                    padding: EdgeInsets.only(left: 30.w),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: grey),
                                    child: Center(
                                      child: TextFormField(
                                        controller: barcode,
                                        style: normalText,
                                        textInputAction: TextInputAction.done,
                                        onChanged: (String value) {
                                          setState(() {
                                            barcodeString = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Masukan Barcode",
                                          hintStyle: normalText,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            TextFieldCustom(
                                controller: name,
                                title: "Name",
                                width: double.infinity),
                            SizedBox(
                              height: 5.h,
                            ),
                            Row(
                              children: [
                                TextFieldCustom(
                                    controller: price,
                                    title: "Price",
                                    width: 300.w),
                                Spacer(),
                                TextFieldCustom(
                                    controller: qty,
                                    title: "Qty",
                                    width: 250.w),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            TextFieldCustom(
                                controller: type,
                                title: "Type",
                                width: double.infinity),
                          ],
                        ),
                        flex: 3,
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Center(
                              child: SizedBox(
                                height: 150.h,
                                width: 150.h,
                                child: QrImage(
                                  data: barcodeString,
                                  version: QrVersions.auto,
                                  gapless: false,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Center(
                              child: Container(
                                height: 150.h,
                                width: 150.w,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black54, width: 1),
                                    color: background,
                                    borderRadius: BorderRadius.circular(10)),
                                child: gambar.isNotEmpty
                                    ? Image.file(
                                        File(gambar),
                                        fit: BoxFit.contain,
                                      )
                                    : TextButton(
                                        onPressed: _pickImage,
                                        child: Text('Select Photo'),
                                      ),
                              ),
                            )
                          ],
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                  Container(
                    height: 55.h,
                    child: Row(
                      children: [
                        Spacer(),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel')),
                        SizedBox(
                          width: 30.w,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: blue, onPrimary: white),
                          child: Row(
                            children: [
                              Icon(Iconsax.send_2, size: 20.sp),
                              SizedBox(
                                width: 10.w,
                              ),
                              const Text('Simpan')
                            ],
                          ),
                          onPressed: () async {
                            ItemModel item = ItemModel(
                                name: name.text,
                                barcode: barcode.text,
                                imagePath: gambar,
                                price: int.parse(price.text),
                                qty: int.parse(qty.text),
                                type: type.text,
                                isDifference: false,
                                lastOpname: "1");
                            if (await itemProvider.addItems(token, item)) {
                              showToast("Berhasil Menambahkan data", false);
                              name.text = "";
                              barcode.text = "";
                              gambar = "";
                              price.text = "0";
                              qty.text = "0";
                              type.text = "Pcs";
                              if (await chartProvider
                                  .getDashboardChart(token)) {
                                if (await chartProvider.getItemInfo(token)) {
                                  Navigator.pop(context);
                                }
                              }
                            } else {
                              showToast("Gagal Menambahkan data", true);
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
