part of 'widgets.dart';

class ItemCard extends StatelessWidget {
  final ItemModel itemModel;
  const ItemCard({Key? key, required this.itemModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        context.go("/dashboard/home/edit-item", extra: itemModel);
      },
      onTap: () => {
        showModalBottomSheet(
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
            context: context,
            builder: (BuildContext context) {
              return BottomSheetSelectedItem(
                itemModel: itemModel,
              );
            })
      },
      child: Container(
        width: 271.w,
        height: 130.h,
        decoration: BoxDecoration(color: backgroundItem, borderRadius: BorderRadius.circular(5)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 5.w,
            ),
            itemModel.imagePath == "-"
                ? SizedBox(
                    width: 100.w,
                    height: 100.h,
                    child: Image.asset("assets/empty-image.png"),
                  )
                : CachedNetworkImage(
                    imageUrl: itemModel.imagePath,
                    progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                      child: SizedBox(
                        width: 50.h,
                        height: 50.h,
                        child: CircularProgressIndicator(value: downloadProgress.progress),
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset("assets/empty-image.png"),
                    width: 100.w,
                    height: 100.h,
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
                    itemModel.name,
                    style: normalText,
                    maxLines: 2,
                  ),
                  SizedBox(
                    height: 52.h,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/logo-barcode.png",
                              width: 15.w,
                              height: 9.h,
                            ),
                            SizedBox(
                              width: 11.w,
                            ),
                            Expanded(
                                child: Text(
                              itemModel.barcode,
                              style:
                                  normalText.copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),
                            ))
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/logo-items.png",
                              width: 15.w,
                              height: 9.h,
                            ),
                            SizedBox(
                              width: 11.w,
                            ),
                            Expanded(
                                child: Text(
                              itemModel.qty.toString(),
                              style:
                                  normalText.copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),
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
    );
  }
}

class ItemCardMobile extends StatelessWidget {
  final ItemModel itemModel;
  const ItemCardMobile({Key? key, required this.itemModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        // showModalBottomSheet(
        //     shape: const RoundedRectangleBorder(
        //         borderRadius: BorderRadius.only(
        //             topRight: Radius.circular(15),
        //             topLeft: Radius.circular(15))),
        //     context: context,
        //     builder: (BuildContext context) {
        //       return BottomSheetSelectedItemMobile(
        //         itemModel: itemModel,
        //       );
        //     })
      },
      child: Container(
        width: 271.w,
        height: 130.h,
        decoration: BoxDecoration(color: backgroundItem, borderRadius: BorderRadius.circular(5)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 5.w,
            ),
            itemModel.imagePath == "-"
                ? SizedBox(
                    width: 150.h,
                    height: 150.h,
                    child: Image.asset("assets/empty-image.png"),
                  )
                : CachedNetworkImage(
                    imageUrl: itemModel.imagePath,
                    progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                      child: SizedBox(
                        width: 50.h,
                        height: 50.h,
                        child: CircularProgressIndicator(value: downloadProgress.progress),
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset("assets/empty-image.png"),
                    width: 150.h,
                    height: 150.h,
                  ),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    itemModel.name,
                    style: normalTextMobile,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 52.h,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/logo-barcode.png",
                              width: 15.h,
                              height: 15.h,
                            ),
                            SizedBox(
                              width: 11.w,
                            ),
                            Expanded(
                                child: Text(
                              itemModel.barcode,
                              style: normalTextMobile.copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 35.sp),
                            ))
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/logo-items.png",
                              width: 15.h,
                              height: 15.h,
                            ),
                            SizedBox(
                              width: 11.w,
                            ),
                            Expanded(
                                child: Text(
                              itemModel.qty.toString(),
                              style: normalTextMobile.copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 36.sp),
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
    );
  }
}
