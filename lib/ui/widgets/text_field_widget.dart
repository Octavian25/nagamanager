part of 'widgets.dart';

class TextFieldCustom extends StatelessWidget {
  const TextFieldCustom(
      {Key? key,
      required this.controller,
      required this.title,
      required this.width})
      : super(key: key);

  final TextEditingController controller;
  final String title;
  final double width;

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
            padding: EdgeInsets.only(left: 30.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: grey),
            child: Center(
              child: TextFormField(
                controller: controller,
                style: normalText,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
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
