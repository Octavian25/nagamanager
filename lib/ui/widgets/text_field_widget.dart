part of 'widgets.dart';

class TextFieldCustom extends StatelessWidget {
  const TextFieldCustom(
      {Key? key,
      required this.controller,
      required this.title,
      this.focus,
      this.readOnly = false,
      required this.width})
      : super(key: key);

  final TextEditingController controller;
  final String title;
  final double width;
  final bool readOnly;
  final FocusNode? focus;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: normalText,
          ),
          SizedBox(
            height: 5.h,
          ),
          Container(
            height: 53.h,
            width: width,
            padding: EdgeInsets.only(left: 15.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: grey),
            child: Center(
              child: TextFormField(
                focusNode: focus,
                controller: controller,
                style: normalText,
                enabled: !readOnly,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  border: InputBorder.none,
                  hintText: title,
                  hintStyle: normalText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DropdownCustom extends StatelessWidget {
  DropdownCustom(
      {Key? key,
      required this.controller,
      required this.title,
      this.readOnly = false,
      required this.locationModel,
      required this.onChange,
      this.selectedLocation,
      required this.width})
      : super(key: key);

  final TextEditingController controller;
  final String title;
  final double width;
  final bool readOnly;
  List<LocationModel> locationModel;
  Function(LocationModel?) onChange;
  LocationModel? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: normalText,
          ),
          SizedBox(
            height: 5.h,
          ),
          Container(
            height: 53.h,
            width: width,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: grey),
            child: Center(
                child: DropdownSearch<LocationModel>(
              popupProps: const PopupProps.menu(showSearchBox: true),
              dropdownDecoratorProps: DropDownDecoratorProps(
                  baseStyle: normalText,
                  dropdownSearchDecoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 38.h, top: 13.h))),
              onChanged: onChange,
              itemAsString: (LocationModel data) => data.locationName,
              items: locationModel,
              selectedItem: selectedLocation,
            )),
          ),
        ],
      ),
    );
  }
}
