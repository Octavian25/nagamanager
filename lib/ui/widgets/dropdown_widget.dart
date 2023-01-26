part of 'widgets.dart';

class CustomDropdown<T> extends StatelessWidget {
  const CustomDropdown(
      {Key? key,
      required this.title,
      this.focus,
      required this.listData,
      required this.selectedValue,
      this.readOnly = false,
      required this.onChange,
      required this.width})
      : super(key: key);

  final String title;
  final double width;
  final bool readOnly;
  final FocusNode? focus;
  final T? selectedValue;
  final List<DropdownMenuItem<T>> listData;
  final Function(T) onChange;

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
            padding: EdgeInsets.only(left: 10.w, top: 10.h, bottom: 10.h, right: 10.w),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: grey),
            child: DropdownButton<T>(
                value: selectedValue,
                items: listData,
                menuMaxHeight: 400.h,
                isExpanded: true,
                underline: const SizedBox(),
                alignment: Alignment.center,
                borderRadius: BorderRadius.circular(15),
                onChanged: (T? data) => {onChange(data!)}),
          ),
        ],
      ),
    );
  }
}
