import 'package:euchack/constants/app_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GroceryHealthChart extends StatelessWidget {
  const GroceryHealthChart({super.key});

  @override
  Widget build(BuildContext context) {
    return buildLineChart();
  }

  Widget buildLineChart() {
    final List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];

    final List<FlSpot> scores = [
      FlSpot(0, 4),
      FlSpot(1, 16),
      FlSpot(2, 32),
      FlSpot(3, 48),
      FlSpot(4, 72),
      FlSpot(5, 96),
    ];

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 5,
        minY: 0,
        maxY: 100,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 20,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[300],
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey[300],
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            axisNameWidget: const Text('Time'),
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                // Assuming each value represents a week
                return Text('Wk ${value.toInt() + 1}');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              getTitlesWidget: (value, meta) {
                return Text('${value.toInt()}%',
                    style: header1Text.copyWith(fontSize: 8));
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: scores,
            isCurved: true,
            gradient: LinearGradient(
              colors: gradientColors,
            ),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(
              show: true,
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColors
                    .map((color) => color.withOpacity(0.3))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
