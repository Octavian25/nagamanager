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
  CategoryModel? selectedCategory;
  SubCategoryModel? subCategorySelected;

  @override
  void initState() {
    super.initState();
    ItemModel data = widget.itemModel;
    nameController.text = data.name;
    barcodeController.text = data.barcode;
    stockController.text = data.qty.toString();
    priceController.text = data.price.toString();
    typeController.text = data.type;
    selectedCategory = Provider.of<CategoryProvider>(context, listen: false)
        .listCategory
        .firstWhereIndexedOrNull(
            (index, element) => element.categoryCode == data.categoryCode);
    subCategorySelected =
        Provider.of<SubCategoryProvider>(context, listen: false)
            .listSubCategory
            .firstWhereIndexedOrNull((index, element) =>
                element.subCategoryCode == data.subCategoryCode);
  }

  printBarcode(String barcode, String jumlah) async {
    var text = '$barcode;$jumlah';
    final bytes = utf8.encode(text);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'autoprint_barcode.txt';
    html.document.body?.children.add(anchor);

// download
    anchor.click();

// cleanup
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    List<LocationModel> listLocation =
        Provider.of<LocationProvider>(context).listLocation;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.w),
          child: Column(
            children: [
              10.verticalSpacingRadius,
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
                        SizedBox(
                          width: 400.w,
                          child: Row(
                            children: [
                              CustomDropdown<CategoryModel>(
                                  title: "Kode Kategori",
                                  listData: Provider.of<CategoryProvider>(
                                          context,
                                          listen: false)
                                      .listCategory
                                      .map((e) => DropdownMenuItem(
                                            child: Text(e.name),
                                            value: e,
                                          ))
                                      .toList(),
                                  selectedValue: selectedCategory,
                                  onChange: (CategoryModel data) {
                                    setState(() {
                                      selectedCategory = data;
                                      subCategorySelected = null;
                                    });
                                  },
                                  width: 190.w),
                              20.horizontalSpace,
                              CustomDropdown<SubCategoryModel?>(
                                  title: "Kode Sub Kategori",
                                  listData: Provider.of<SubCategoryProvider>(
                                          context,
                                          listen: false)
                                      .listSubCategory
                                      .where((element) =>
                                          element.categoryCode ==
                                          selectedCategory?.categoryCode)
                                      .map((e) => DropdownMenuItem(
                                            child: Text(e.name),
                                            value: e,
                                          ))
                                      .toList(),
                                  selectedValue: subCategorySelected,
                                  onChange: (SubCategoryModel? data) {
                                    setState(() {
                                      subCategorySelected = data;
                                    });
                                  },
                                  width: 190.w),
                            ],
                          ),
                        ),
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
                        20.verticalSpacingRadius,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () async {
                                String token = Provider.of<AuthProvider>(
                                        context,
                                        listen: false)
                                    .user!
                                    .accessToken;
                                if (await Provider.of<ItemProvider>(context,
                                        listen: false)
                                    .deleteItems(token, widget.itemModel)) {
                                  showToast("Barang berhasil DIhapus", false);
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
                                  'Delete Barang',
                                  style:
                                      normalText.copyWith(color: Colors.white),
                                )),
                                decoration: BoxDecoration(
                                    color: red,
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                            10.horizontalSpaceRadius,
                            InkWell(
                              onTap: () => {
                                printBarcode(barcodeController.text,
                                    stockController.text)
                              },
                              child: Ink(
                                width: 100.w,
                                height: 45.h,
                                child: Center(
                                    child: Text(
                                  'Cetak Barcode',
                                  style:
                                      normalText.copyWith(color: Colors.white),
                                )),
                                decoration: BoxDecoration(
                                    color: red,
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                            10.horizontalSpaceRadius,
                            InkWell(
                              onTap: () async {
                                String token = Provider.of<AuthProvider>(
                                        context,
                                        listen: false)
                                    .user!
                                    .accessToken;
                                ItemModel payload = widget.itemModel.copyWith(
                                    name: nameController.text,
                                    qty: int.parse(stockController.text),
                                    subCategoryCode:
                                        subCategorySelected?.subCategoryCode,
                                    categoryCode:
                                        subCategorySelected?.categoryCode,
                                    price: int.parse(priceController.text),
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
                                  style:
                                      normalText.copyWith(color: Colors.white),
                                )),
                                decoration: BoxDecoration(
                                    color: green,
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                          ],
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
