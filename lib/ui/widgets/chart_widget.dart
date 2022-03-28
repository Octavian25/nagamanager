import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nagamanager/models/chart_barang_model.dart';
import 'package:nagamanager/providers/chart_provider.dart';
import 'package:nagamanager/providers/providers.dart';
import 'package:nagamanager/shared/helper.dart';
import 'package:nagamanager/shared/shared.dart';
import 'package:provider/provider.dart';

class BarChartWidget extends StatefulWidget {
  const BarChartWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BarChartWidgetState();
}

class BarChartWidgetState extends State<BarChartWidget> {
  final Color leftBarColor = const Color(0xff53fdd7);
  String dropdownValue = 'Bulanan';
  int lengthY = 10;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData>? listChartGroup =
        Provider.of<ChartProvider>(context).listBarChartGroupData;
    ChartBarangModel? chartBarangModel =
        Provider.of<ChartProvider>(context).chartBarangModel;
    int longestName = Provider.of<ChartProvider>(context).longestName;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: 90.w * listChartGroup.length > 100.sw
                      ? 90.w * listChartGroup.length
                      : MediaQuery.of(context).size.width - 100,
                  height: double.infinity,
                  padding: EdgeInsets.only(top: 10.h),
                  child: BarChart(
                    BarChartData(
                      maxY: chartBarangModel?.UpperBound.toDouble() ?? 100,
                      barTouchData: BarTouchData(
                          touchCallback: (FlTouchEvent event, response) async {
                        if (!event.isInterestedForInteractions) {
                          String startDate =
                              Helper.getToday.decrement(value: 7);
                          String endDate = Helper.getToday.decrement(value: 0);
                          if (response?.spot != null) {
                            int index = response!.spot!.touchedBarGroupIndex;
                            ChartProvider chart = Provider.of<ChartProvider>(
                                context,
                                listen: false);
                            String token = Provider.of<AuthProvider>(context,
                                    listen: false)
                                .user!
                                .accessToken;
                            if (await chart.getDetailChart(
                                token,
                                chartBarangModel!.barcode[index],
                                startDate,
                                endDate)) {
                              if (await chart.getChartAnnual(
                                  token, chartBarangModel.barcode[index])) {
                                chart.setInformation(
                                    barangSelectedd: chartBarangModel
                                            .listBarang[
                                        response.spot!.touchedBarGroupIndex],
                                    startDatee: startDate,
                                    endDatee: endDate,
                                    barcodeSelectedd:
                                        chartBarangModel.barcode[index]);
                                Navigator.pushNamed(context, "/detail-chart");
                              }
                            }
                          }
                        }
                      }),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: SideTitles(showTitles: false),
                        topTitles: SideTitles(showTitles: false),
                        bottomTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (context, value) => normalText,
                            margin: 20.w,
                            getTitles: (double value) {
                              if (chartBarangModel!
                                      .listBarang[value.toInt()].length >
                                  15) {
                                return chartBarangModel
                                    .listBarang[value.toInt()]
                                    .substring(0, 15);
                              } else {
                                var length = chartBarangModel
                                    .listBarang[value.toInt()].length;
                                var mustInsert = 7 - length;
                                var space = "";
                                for (var i = 0; i < mustInsert; i++) {
                                  space += "\ ";
                                }
                                return chartBarangModel
                                        .listBarang[value.toInt()] +
                                    space;
                              }
                            },
                            interval: 1,
                            reservedSize: longestName * 3.6,
                            rotateAngle: 35),
                        leftTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (context, value) => normalText,
                          reservedSize: 70,
                          interval: 20,
                          getTitles: (value) {
                            return value.toString();
                          },
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: listChartGroup,
                      gridData: FlGridData(show: true),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
