part of 'widgets.dart';

class BottomSheetTracking extends StatefulWidget {
  final List<TrackingFeedback> trackingFeedback;
  const BottomSheetTracking({Key? key, required this.trackingFeedback}) : super(key: key);

  @override
  _BottomSheetTrackingState createState() => _BottomSheetTrackingState();
}

class _BottomSheetTrackingState extends State<BottomSheetTracking> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600.h,
      decoration: BoxDecoration(
          color: success,
          borderRadius:
              const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Tracking Barang Berhasil",
                style: titleText.copyWith(color: Colors.white),
              ),
              Text(
                "Berikut adalah Rekapan Hasil Tracking",
                style: normalText.copyWith(color: Colors.white),
              ),
            ],
          )),
          SizedBox(
            height: 10.h,
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 20.h, right: 5.w, left: 5.w),
                  padding: EdgeInsets.all(10.w),
                  width: 200.h,
                  height: 200.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 5),
                            spreadRadius: 3,
                            blurRadius: 4)
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        widget.trackingFeedback[index].barcode,
                        style: normalText.copyWith(fontSize: 16.sp),
                        textAlign: TextAlign.center,
                      ),
                      Text(widget.trackingFeedback[index].name,
                          style: normalText.copyWith(fontSize: 14.sp), textAlign: TextAlign.center),
                      Expanded(
                        child: Center(
                          child: Text(
                            widget.trackingFeedback[index].qty.toString(),
                            style: bigText,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
              itemCount: widget.trackingFeedback.length,
            ),
          )),
          Container(
            height: 45.h,
            width: 400.w,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/dashboard/home');
              },
              style: ElevatedButton.styleFrom(primary: blue, onPrimary: Colors.white),
              child: Text(
                "Selesai",
                style: normalText.copyWith(color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          )
        ],
      ),
    );
  }
}

class BottomSheetTrackingMobile extends StatefulWidget {
  final List<TrackingFeedback> trackingFeedback;
  const BottomSheetTrackingMobile({Key? key, required this.trackingFeedback}) : super(key: key);

  @override
  _BottomSheetTrackingMobileState createState() => _BottomSheetTrackingMobileState();
}

class _BottomSheetTrackingMobileState extends State<BottomSheetTrackingMobile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600.h,
      decoration: BoxDecoration(
          color: success,
          borderRadius:
              const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Tracking Barang Berhasil",
                style: titleTextMobile.copyWith(color: Colors.white),
              ),
              Text(
                "Berikut adalah Rekapan Hasil Tracking",
                style: normalTextMobile.copyWith(color: Colors.white),
              ),
            ],
          )),
          SizedBox(
            height: 10.h,
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 20.h, right: 5.w, left: 5.w),
                  padding: EdgeInsets.all(10.w),
                  width: 200.h,
                  height: 200.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 5),
                            spreadRadius: 3,
                            blurRadius: 4)
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        widget.trackingFeedback[index].barcode,
                        style: normalText.copyWith(fontSize: 30.sp),
                        textAlign: TextAlign.center,
                      ),
                      Text(widget.trackingFeedback[index].name,
                          style: normalText.copyWith(fontSize: 30.sp), textAlign: TextAlign.center),
                      Expanded(
                        child: Center(
                          child: Text(
                            widget.trackingFeedback[index].qty.toString(),
                            style: bigTextMobile,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
              itemCount: widget.trackingFeedback.length,
            ),
          )),
          Container(
            height: 45.h,
            width: 400.w,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/dashboard/home');
              },
              style: ElevatedButton.styleFrom(primary: blue, onPrimary: Colors.white),
              child: Text(
                "Selesai",
                style: normalTextMobile.copyWith(color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          )
        ],
      ),
    );
  }
}
