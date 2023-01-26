part of 'pages.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  TextEditingController locationCodeController = TextEditingController();
  TextEditingController locationNameController = TextEditingController();
  bool isEdited = false;
  String id = "";
  void updateData() async {
    Navigator.pop(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    ItemProvider itemProvider = Provider.of<ItemProvider>(context, listen: false);
    ChartProvider chartProvider = Provider.of<ChartProvider>(context, listen: false);
    LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);

    await itemProvider.getProject(authProvider.user!.accessToken);
    await itemProvider.getTotalIn(authProvider.user!.accessToken);
    await itemProvider.getTotalOut(authProvider.user!.accessToken);
    await locationProvider.getAllLocation(authProvider.user!.accessToken);
    await chartProvider.getItemInfo(authProvider.user!.accessToken);
    locationProvider.checkLastLocation();

    if (await chartProvider.getDashboardChart(authProvider.user!.accessToken)) {
      if (await chartProvider.getItemInfo(authProvider.user!.accessToken)) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.w, top: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  String token =
                      Provider.of<AuthProvider>(context, listen: false).user!.accessToken;
                  ChartProvider chart = Provider.of<ChartProvider>(context, listen: false);
                  if (await chart.getDashboardChart(token)) {
                    updateData();
                    context.go("/dashboard");
                  } else {
                    showToast("Ambil Data Terbaru Gagal", false);
                  }
                },
                borderRadius: BorderRadius.circular(10.r),
                child: Ink(
                  height: 45.h,
                  width: 90.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r), color: "#E8ECF2".toColor()),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 15.w,
                      ),
                      Icon(Iconsax.arrow_square_left, color: text, size: 20),
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
              Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isEdited = false;
                        locationCodeController.clear();
                        locationNameController.clear();
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
                      TextFieldCustom(
                          readOnly: isEdited,
                          controller: locationCodeController,
                          title: "Kode Lokasi",
                          width: 200.w),
                      20.horizontalSpace,
                      TextFieldCustom(
                          controller: locationNameController, title: "Nama Lokasi", width: 300.w),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () async {
                        String token =
                            Provider.of<AuthProvider>(context, listen: false).user!.accessToken;
                        LocationModel payload = LocationModel(
                            locationCode: locationCodeController.text,
                            locationName: locationNameController.text,
                            id: "-");
                        EditLocationModel payloadEdit =
                            EditLocationModel(locationName: locationNameController.text, id: id);
                        if (isEdited) {
                          await locationProvider.editLocation(token, payloadEdit);
                          await locationProvider.getAllLocation(token);
                        } else {
                          await locationProvider.addLocation(token, payload);
                          await locationProvider.getAllLocation(token);
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
                        decoration:
                            BoxDecoration(color: green, borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  Container(
                    child: Row(
                      children: [
                        10.horizontalSpace,
                        Expanded(
                          child: Text("Kode Lokasi",
                              style: normalText.copyWith(
                                  fontSize: 18.sp, fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: Text("Nama Lokasi",
                              style: normalText.copyWith(
                                  fontSize: 18.sp, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  10.verticalSpace,
                  Expanded(
                      child: ListView.builder(
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
                                      Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Hapus'),
                                    onPressed: () async {
                                      String token =
                                          Provider.of<AuthProvider>(context, listen: false)
                                              .user!
                                              .accessToken;
                                      if (await locationProvider.deleteLocation(
                                          token, locationProvider.listLocation[index].id)) {
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
                          locationCodeController.text =
                              locationProvider.listLocation[index].locationCode;
                          locationNameController.text =
                              locationProvider.listLocation[index].locationName;
                          setState(() {
                            id = locationProvider.listLocation[index].id;
                            isEdited = true;
                          });
                        },
                        child: Ink(
                          height: 50.h,
                          child: Row(
                            children: [
                              10.horizontalSpace,
                              Expanded(
                                child: Text(locationProvider.listLocation[index].locationCode),
                              ),
                              Expanded(
                                child: Text(locationProvider.listLocation[index].locationName),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: locationProvider.listLocation.length,
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
