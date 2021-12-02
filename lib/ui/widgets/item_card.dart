part of 'widgets.dart';

class ItemCard extends StatelessWidget {
  final ItemModel itemModel;
  const ItemCard({Key? key, required this.itemModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
          showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft:Radius.circular(15) )
            ),
              context: context, builder: (BuildContext context){
            return BottomSheetSelectedItem(itemModel: itemModel,);
          })
      },
      child: Container(
        width: 271.w,
        height: 130.h,
        decoration: BoxDecoration(
          color: backgroundItem,
          borderRadius: BorderRadius.circular(5)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 5.w,
            ),
            Image.network(itemModel.image_path, width: 100.w, height: 100.h,),
            SizedBox(
              width: 10.w,
            ),
            Expanded(child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(itemModel.name, style: normalText, maxLines: 2,),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      Image.asset("assets/logo-barcode.png", width: 15.w, height: 9.h,),
                      SizedBox(
                        width: 11.w,
                      ),
                      Expanded(child: Text(itemModel.barcode, style: normalText.copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),))
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset("assets/logo-items.png", width: 15.w, height: 9.h,),
                      SizedBox(
                        width: 11.w,
                      ),
                      Expanded(child: Text(itemModel.qty.toString(), style: normalText.copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),))
                    ],
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
