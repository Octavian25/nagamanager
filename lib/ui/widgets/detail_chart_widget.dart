import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:nagamanager/providers/chart_provider.dart';
import 'package:nagamanager/shared/shared.dart';
import 'package:provider/provider.dart';

class DetailChartWidget extends StatefulWidget {
  const DetailChartWidget({Key? key}) : super(key: key);

  @override
  _DetailChartWidgetState createState() => _DetailChartWidgetState();
}

class _DetailChartWidgetState extends State<DetailChartWidget> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int chartProvider = Provider.of<ChartProvider>(context)
        .chartDetailBarangModel!
        .stock
        .length;
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
        Radius.circular(18),
      )),
      width: double.infinity,
      child: chartProvider == 0
          ? Column(
              children: [
                Expanded(child: Lottie.asset("assets/empty_state.json")),
                Text('Mohon Pilih Rentang Tanggal Yang Lain',
                    style: normalText.copyWith(fontSize: 18.sp)),
              ],
            )
          : LineChart(
              mainData(),
            ),
    );
  }

  LineChartData mainData() {
    ChartProvider chartProvider = Provider.of<ChartProvider>(context);
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTextStyles: (context, value) => normalText,
          getTitles: (value) {
            return chartProvider.chartDetailBarangModel!.list[value.toInt()];
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => normalText,
          getTitles: (value) {
            return value.toString();
          },
          reservedSize: 40.w,
        ),
      ),
      borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minY: 0,
      maxY: chartProvider.chartDetailBarangModel!.upperBound.toDouble(),
      minX: 0,
      lineBarsData: [
        LineChartBarData(
          // spots: [FlSpot(0.0, 1.1), FlSpot(1.0, 2.0), FlSpot(2.0, 3.0)],
          spots: [...chartProvider.chartDetail],
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.5)).toList(),
          ),
        ),
      ],
    );
  }
}
