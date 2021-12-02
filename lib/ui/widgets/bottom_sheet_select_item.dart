part of 'widgets.dart';


class BottomSheetSelectedItem extends StatefulWidget {
  final ItemModel itemModel;
  const BottomSheetSelectedItem({Key? key, required this.itemModel}) : super(key: key);

  @override
  _BottomSheetSelectedItemState createState() => _BottomSheetSelectedItemState();
}

class _BottomSheetSelectedItemState extends State<BottomSheetSelectedItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(child:SizedBox(
            width: 271.w,
            height: 130.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 5.w,
                ),
                Image.network(widget.itemModel.image_path, width: 150.w, height: 150.h,),
                SizedBox(
                  width: 15.w,
                ),
                Expanded(child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.itemModel.name, style: normalText.copyWith(fontSize: 16.sp), maxLines: 2,),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        children: [
                          Image.asset("assets/logo-barcode.png", width: 15.w, height: 9.h,),
                          SizedBox(
                            width: 11.w,
                          ),
                          Expanded(child: Text(widget.itemModel.barcode, style: normalText.copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),))
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset("assets/logo-items.png", width: 15.w, height: 9.h,),
                          SizedBox(
                            width: 11.w,
                          ),
                          Expanded(child: Text(widget.itemModel.qty.toString(), style: normalText.copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),))
                        ],
                      )
                    ],
                  ),
                ))
              ],
            ),
          ),),
          GestureDetector(
            onTap: () => {
              Navigator.pushNamed(context, "/stocking", arguments: widget.itemModel)
            },
            child: BounceInUp(
              child: Container(
                width: 160.w,
                height: 150.w,
                decoration: BoxDecoration(
                    color: blue,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 5.h,
                    ),
                    Image.asset("assets/stock-in.png", width: 76.w, height: 60.h,),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text("Stock In", style: normalText.copyWith(color: Colors.white),)
                  ],
                ),
              ),
              duration: Duration(milliseconds: 500),
            ),
          ),
          SizedBox(
            width: 25.w,
          ),
          BounceInUp(
            child: Container(
              width: 160.w,
              height: 150.w,
              decoration: BoxDecoration(
                  color: red,
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  Image.asset("assets/stock-out.png", width: 76.w, height: 60.h,),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text("Stock Out", style: normalText.copyWith(color: Colors.white),)
                ],
              ),
            ),
            duration: Duration(milliseconds: 500),
          ),
        ],
      ),
    );
  }
}
