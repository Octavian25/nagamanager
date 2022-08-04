part of 'widgets.dart';

class BottomSheetSelectedItem extends StatefulWidget {
  final ItemModel itemModel;
  const BottomSheetSelectedItem({Key? key, required this.itemModel})
      : super(key: key);

  @override
  _BottomSheetSelectedItemState createState() =>
      _BottomSheetSelectedItemState();
}

class _BottomSheetSelectedItemState extends State<BottomSheetSelectedItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              width: 275.w,
              height: 160.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 5.w,
                  ),
                  Image.network(
                    widget.itemModel.imagePath,
                    width: 150.w,
                    height: 150.h,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          widget.itemModel.name,
                          style: normalText.copyWith(fontSize: 18.sp),
                          maxLines: 2,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/logo-barcode.png",
                                    width: 20.w,
                                    height: 14.h,
                                  ),
                                  SizedBox(
                                    width: 11.w,
                                  ),
                                  Expanded(
                                      child: Text(
                                    widget.itemModel.barcode,
                                    style: normalText.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17.sp),
                                  ))
                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/logo-items.png",
                                    width: 20.w,
                                    height: 14.h,
                                  ),
                                  SizedBox(
                                    width: 11.w,
                                  ),
                                  Expanded(
                                      child: Text(
                                    widget.itemModel.qty.toString(),
                                    style: normalText.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17.sp),
                                  ))
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ))
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => {
              Navigator.pushNamed(context, "/stocking",
                  arguments: StockingArgumenModel(
                      itemModel: widget.itemModel, isStockIn: true))
            },
            child: BounceInUp(
              child: Container(
                width: 160.w,
                height: 150.h,
                decoration: BoxDecoration(
                    color: blue, borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 21.h,
                    ),
                    Image.asset(
                      "assets/stock-in.png",
                      width: 60.w,
                      height: 76.h,
                    ),
                    SizedBox(
                      height: 19.h,
                    ),
                    Text(
                      "Stock In",
                      style: normalText.copyWith(color: Colors.white),
                    )
                  ],
                ),
              ),
              duration: const Duration(milliseconds: 350),
            ),
          ),
          SizedBox(
            width: 25.w,
          ),
          GestureDetector(
            onTap: () => {
              Navigator.pushNamed(context, "/stocking",
                  arguments: StockingArgumenModel(
                      itemModel: widget.itemModel, isStockIn: false))
            },
            child: BounceInUp(
              child: Container(
                width: 160.w,
                height: 150.h,
                decoration: BoxDecoration(
                    color: red, borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 21.h,
                    ),
                    Image.asset(
                      "assets/stock-out.png",
                      width: 60.w,
                      height: 76.h,
                    ),
                    SizedBox(
                      height: 19.h,
                    ),
                    Text(
                      "Stock Out",
                      style: normalText.copyWith(color: Colors.white),
                    )
                  ],
                ),
              ),
              duration: const Duration(milliseconds: 350),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomSheetSelectedItemMobile extends StatefulWidget {
  final ItemModel itemModel;
  const BottomSheetSelectedItemMobile({Key? key, required this.itemModel})
      : super(key: key);

  @override
  _BottomSheetSelectedItemMobileState createState() =>
      _BottomSheetSelectedItemMobileState();
}

class _BottomSheetSelectedItemMobileState
    extends State<BottomSheetSelectedItemMobile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350.h,
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 1.sw,
            height: 200.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 5.w,
                ),
                Image.network(
                  widget.itemModel.imagePath,
                  width: 200.w,
                  height: 200.h,
                ),
                SizedBox(
                  width: 30.w,
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.itemModel.name,
                              style: normalTextMobile.copyWith(fontSize: 35.sp),
                              maxLines: 2,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/logo-barcode.png",
                                  width: 16.h,
                                  height: 16.h,
                                ),
                                SizedBox(
                                  width: 11.w,
                                ),
                                Expanded(
                                    child: Text(
                                  widget.itemModel.barcode,
                                  style: normalTextMobile.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 30.sp),
                                ))
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/logo-items.png",
                                  width: 16.h,
                                  height: 16.h,
                                ),
                                SizedBox(
                                  width: 11.w,
                                ),
                                Expanded(
                                    child: Text(
                                  widget.itemModel.qty.toString(),
                                  style: normalTextMobile.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 30.sp),
                                ))
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ))
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => {
                  Navigator.pushNamed(context, "/stocking",
                      arguments: StockingArgumenModel(
                          itemModel: widget.itemModel, isStockIn: true))
                },
                child: BounceInUp(
                  child: Container(
                    width: 110.h,
                    height: 110.h,
                    decoration: BoxDecoration(
                        color: blue, borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 21.h,
                        ),
                        Image.asset(
                          "assets/stock-in.png",
                          width: 40.h,
                          height: 40.h,
                        ),
                        SizedBox(
                          height: 19.h,
                        ),
                        Text(
                          "Stock In",
                          style: normalTextMobile.copyWith(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  duration: const Duration(milliseconds: 350),
                ),
              ),
              SizedBox(
                width: 25.w,
              ),
              GestureDetector(
                onTap: () => {
                  Navigator.pushNamed(context, "/stocking",
                      arguments: StockingArgumenModel(
                          itemModel: widget.itemModel, isStockIn: false))
                },
                child: BounceInUp(
                  child: Container(
                    width: 110.h,
                    height: 110.h,
                    decoration: BoxDecoration(
                        color: red, borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 21.h,
                        ),
                        Image.asset(
                          "assets/stock-out.png",
                          width: 40.h,
                          height: 40.h,
                        ),
                        SizedBox(
                          height: 19.h,
                        ),
                        Text(
                          "Stock Out",
                          style: normalTextMobile.copyWith(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  duration: const Duration(milliseconds: 350),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
