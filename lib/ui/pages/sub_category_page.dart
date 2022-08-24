part of 'pages.dart';

class SubCategoryPage extends StatefulWidget {
  const SubCategoryPage({Key? key}) : super(key: key);

  @override
  State<SubCategoryPage> createState() => SubCategoryPageState();
}

class SubCategoryPageState extends State<SubCategoryPage> {
  TextEditingController subCategoryCodeController = TextEditingController();
  TextEditingController subCategoryNameController = TextEditingController();
  bool isEdited = false;
  CategoryModel? selectedCategory;
  String id = "-";

  void updateData() async {
    Navigator.pop(context);
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    ItemProvider itemProvider =
        Provider.of<ItemProvider>(context, listen: false);
    ChartProvider chartProvider =
        Provider.of<ChartProvider>(context, listen: false);
    CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);

    await itemProvider.getProject(authProvider.user!.accessToken);
    await itemProvider.getTotalIn(authProvider.user!.accessToken);
    await itemProvider.getTotalOut(authProvider.user!.accessToken);
    await categoryProvider.getAllCategory(authProvider.user!.accessToken);
    await chartProvider.getItemInfo(authProvider.user!.accessToken);
    if (await chartProvider.getDashboardChart(authProvider.user!.accessToken)) {
      if (await chartProvider.getItemInfo(authProvider.user!.accessToken)) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    SubCategoryProvider subCategoryProvider =
        Provider.of<SubCategoryProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.w, top: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      String token =
                          Provider.of<AuthProvider>(context, listen: false)
                              .user!
                              .accessToken;
                      ChartProvider chart =
                          Provider.of<ChartProvider>(context, listen: false);
                      if (await chart.getDashboardChart(token)) {
                        updateData();
                        Navigator.pushNamed(context, "/dashboard");
                      } else {
                        showToast("Ambil Data Terbaru Gagal", false);
                      }
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
                  20.horizontalSpaceRadius,
                  Text("Master Sub Category",
                      style: normalText.copyWith(
                          fontSize: 18.sp, fontWeight: FontWeight.bold)),
                ],
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isEdited = false;
                        subCategoryCodeController.clear();
                        subCategoryNameController.clear();
                        selectedCategory = null;
                      });
                    },
                    icon: const Icon(Icons.refresh),
                  )),
              Expanded(
                  child: Column(
                children: [
                  20.verticalSpace,
                  Row(
                    children: [
                      CustomDropdown<CategoryModel>(
                          title: "Kode Kategori",
                          listData: Provider.of<CategoryProvider>(context,
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
                            });
                          },
                          width: 200.w),
                      20.horizontalSpace,
                      TextFieldCustom(
                          readOnly: isEdited,
                          controller: subCategoryCodeController,
                          title: "Kode Sub Categori",
                          width: 200.w),
                      20.horizontalSpace,
                      TextFieldCustom(
                          controller: subCategoryNameController,
                          title: "Nama Sub Categori",
                          width: 300.w),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () async {
                        String token =
                            Provider.of<AuthProvider>(context, listen: false)
                                .user!
                                .accessToken;
                        SubCategoryModel payload = SubCategoryModel(
                            categoryCode: selectedCategory?.categoryCode ?? "-",
                            id: id,
                            subCategoryCode: subCategoryCodeController.text,
                            description: "-",
                            name: subCategoryNameController.text);
                        if (isEdited) {
                          await subCategoryProvider.editSubCategory(
                              token, payload);
                          await subCategoryProvider.getAllSubCategory(token);
                        } else {
                          await subCategoryProvider.addSubCategory(
                              token, payload);
                          await subCategoryProvider.getAllSubCategory(token);
                        }
                      },
                      child: Ink(
                        width: 100.w,
                        height: 45.h,
                        child: Center(
                            child: Text(
                          isEdited ? "Rubah" : 'Simpan',
                          style: normalText.copyWith(color: Colors.white),
                        )),
                        decoration: BoxDecoration(
                            color: green,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  Row(
                    children: [
                      10.horizontalSpace,
                      Expanded(
                        child: Text("Kode Sub Kategori",
                            style: normalText.copyWith(
                                fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Text("Nama Sub Kategori",
                            style: normalText.copyWith(
                                fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  Expanded(
                      child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemBuilder: (context, index) {
                      return InkWell(
                        onLongPress: () {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: true,
                            // false = user must tap button, true = tap outside dialog
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                title: const Text('Yakin Ingin Menghapus ? '),
                                actionsAlignment: MainAxisAlignment.spaceAround,
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Batal'),
                                    onPressed: () {
                                      Navigator.of(dialogContext)
                                          .pop(); // Dismiss alert dialog
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Hapus'),
                                    onPressed: () async {
                                      String token = Provider.of<AuthProvider>(
                                              context,
                                              listen: false)
                                          .user!
                                          .accessToken;
                                      if (await subCategoryProvider
                                          .deleteSubCategory(
                                              token,
                                              subCategoryProvider
                                                  .listSubCategory[index].id)) {
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onTap: () {
                          List<CategoryModel> listCategory =
                              Provider.of<CategoryProvider>(context,
                                      listen: false)
                                  .listCategory;
                          CategoryModel? result =
                              listCategory.firstWhereOrNull((element) {
                            return element.categoryCode ==
                                subCategoryProvider
                                    .listSubCategory[index].categoryCode;
                          });
                          subCategoryCodeController.text = subCategoryProvider
                              .listSubCategory[index].subCategoryCode;
                          subCategoryNameController.text =
                              subCategoryProvider.listSubCategory[index].name;
                          setState(() {
                            id = subCategoryProvider.listSubCategory[index].id;
                            selectedCategory = result;
                            isEdited = true;
                          });
                        },
                        child: Ink(
                          height: 50.h,
                          child: Row(
                            children: [
                              10.horizontalSpace,
                              Expanded(
                                child: Text(
                                  subCategoryProvider
                                      .listSubCategory[index].subCategoryCode,
                                  style: normalText,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                    subCategoryProvider
                                        .listSubCategory[index].name,
                                    style: normalText),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: subCategoryProvider.listSubCategory.length,
                  ))
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
