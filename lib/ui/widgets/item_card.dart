part of 'widgets.dart';

class ItemCard extends StatelessWidget {

  const ItemCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
          showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft:Radius.circular(15) )
            ),
              context: context, builder: (BuildContext context){
            return Container(
              height: 150.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BounceInUp(
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
            Image.asset("assets/product-1.png", width: 100.w, height: 100.h,),
            SizedBox(
              width: 5.w,
            ),
            Expanded(child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Macbook Pro M1 Max 2TB 32GB", style: normalText, maxLines: 2,),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      Image.asset("assets/logo-barcode.png", width: 15.w, height: 9.h,),
                      SizedBox(
                        width: 11.w,
                      ),
                      Expanded(child: Text("KB-00012341", style: normalText.copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),))
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset("assets/logo-items.png", width: 15.w, height: 9.h,),
                      SizedBox(
                        width: 11.w,
                      ),
                      Expanded(child: Text("1300", style: normalText.copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),))
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
