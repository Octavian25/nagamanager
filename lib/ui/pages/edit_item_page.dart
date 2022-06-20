part of 'pages.dart';

class EditItemPage extends StatefulWidget {
  ItemModel itemModel;
  EditItemPage({Key? key, required this.itemModel}) : super(key: key);

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  String locationCode = "";
  LocationModel? selectedLocation;

  @override
  void initState() {
    super.initState();
    ItemModel data = widget.itemModel;
    nameController.text = data.name;
    barcodeController.text = data.barcode;
    stockController.text = data.qty.toString();
    priceController.text = data.price.toString();
    typeController.text = data.type;
  }

  @override
  Widget build(BuildContext context) {
    List<LocationModel> listLocation =
        Provider.of<LocationProvider>(context).listLocation;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.w),
          child: Column(
            children: [
              SizedBox(
                  height: 50.h,
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
                      10.horizontalSpace,
                      Text('Edit Barang', style: titleText),
                    ],
                  )),
              50.verticalSpace,
              Expanded(
                  child: Row(
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        Container(
                          width: 200.w,
                          height: 200.w,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      NetworkImage(widget.itemModel.imagePath),
                                  fit: BoxFit.cover)),
                        ),
                      ],
                    ),
                    flex: 1,
                  ),
                  50.horizontalSpace,
                  Flexible(
                    flex: 3,
                    child: ListView(
                      children: [
                        TextFieldCustom(
                            controller: nameController,
                            title: "Nama Barang",
                            width: 400.w),
                        DropdownCustom(
                            locationModel: listLocation,
                            controller: nameController,
                            onChange: (LocationModel? data) {
                              setState(() {
                                locationCode = data!.locationCode;
                              });
                            },
                            selectedLocation: listLocation.firstWhere(
                                (element) =>
                                    element.locationCode ==
                                    widget.itemModel.locationCode),
                            title: "Nama Lokasi",
                            width: 400.w),
                        TextFieldCustom(
                            controller: barcodeController,
                            title: "Barcode Barang",
                            width: 400.w),
                        TextFieldCustom(
                            controller: stockController,
                            title: "Stock Barang",
                            width: 400.w),
                        TextFieldCustom(
                            controller: priceController,
                            title: "Harga Barang",
                            width: 400.w),
                        TextFieldCustom(
                            controller: typeController,
                            title: "Type Barang",
                            width: 400.w),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () async {
                              String token = Provider.of<AuthProvider>(context,
                                      listen: false)
                                  .user!
                                  .accessToken;
                              ItemModel payload = widget.itemModel.copyWith(
                                  name: nameController.text,
                                  locationCode: locationCode);
                              if (await Provider.of<ItemProvider>(context,
                                      listen: false)
                                  .updateItems(token, payload)) {
                                showToast("Barang berhasil Dirubah", false);
                                Navigator.pop(context);
                              } else {
                                showToast(
                                    "Barang Gagal Dirubah, Coba Beberapa saat lagi..",
                                    true);
                              }
                            },
                            child: Ink(
                              width: 100.w,
                              height: 45.h,
                              child: Center(
                                  child: Text(
                                'Rubah',
                                style: normalText.copyWith(color: Colors.white),
                              )),
                              decoration: BoxDecoration(
                                  color: green,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
