import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nagamanager/providers/chart_provider.dart';
import 'package:nagamanager/shared/shared.dart';
import 'package:provider/provider.dart';

class PieChartWidget extends StatefulWidget {
  const PieChartWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChartWidgetState();
}

class PieChartWidgetState extends State {
  int touchedIndex = -1;
  List<PieChartSectionData> data = [];
  @override
  void initState() {
    super.initState();
    List<PieChartSectionData> listData = [];
  }

  @override
  Widget build(BuildContext context) {
    ChartProvider chartProvider = Provider.of<ChartProvider>(context);
    return PieChart(
      PieChartData(
          pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          }),
          startDegreeOffset: 180,
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 1,
          centerSpaceRadius: 0,
          sections: chartProvider.chartAnnualIn
              .map((e) => PieChartSectionData(
                    color: listColor[chartProvider.chartAnnualIn
                        .indexWhere((element) => element.month == e.month)],
                    value: e.value.toDouble(),
                    title: '',
                    radius: e.value * 3 < 80
                        ? 80
                        : e.value * 3 > 90
                            ? 90
                            : e.value * 3,
                    titleStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff0c7f55)),
                    titlePositionPercentageOffset: 0.55,
                  ))
              .toList()),
    );
  }
}

class PieChartWidgetMobile extends StatefulWidget {
  const PieChartWidgetMobile({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChartWidgetMobileState();
}

class PieChartWidgetMobileState extends State {
  int touchedIndex = -1;
  List<PieChartSectionData> data = [];
  @override
  void initState() {
    super.initState();
    List<PieChartSectionData> listData = [];
  }

  @override
  Widget build(BuildContext context) {
    ChartProvider chartProvider = Provider.of<ChartProvider>(context);
    return PieChart(
      PieChartData(
          pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          }),
          startDegreeOffset: 180,
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 1,
          centerSpaceRadius: 0,
          sections: chartProvider.chartAnnualIn
              .map((e) => PieChartSectionData(
                    color: listColor[chartProvider.chartAnnualIn
                        .indexWhere((element) => element.month == e.month)],
                    value: e.value.toDouble(),
                    title: '',
                    radius: e.value * 1 < 60
                        ? 60
                        : e.value * 1 > 70
                            ? 70
                            : e.value * 1,
                    titleStyle: TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff0c7f55)),
                    titlePositionPercentageOffset: 0.55,
                  ))
              .toList()),
    );
  }
}
