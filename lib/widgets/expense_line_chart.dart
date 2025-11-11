// lib/widgets/expense_line_chart.dart (NEW FILE)
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpenseLineChart extends StatelessWidget {
  final Map<DateTime, double> monthlyTotals;

  const ExpenseLineChart({super.key, required this.monthlyTotals});

  @override
  Widget build(BuildContext context) {
    if (monthlyTotals.isEmpty || monthlyTotals.values.every((v) => v == 0)) {
      return const Center(child: Text("No monthly data available."));
    }

    // Assign integer index (0, 1, 2...) for the x-axis
    final List<MapEntry<DateTime, double>> sortedData = monthlyTotals.entries
        .toList();

    // Find the maximum amount for scaling the graph
    final maxAmount = monthlyTotals.values.reduce((a, b) => a > b ? a : b);

    // Prepare FlSpot data
    List<FlSpot> spots = sortedData.asMap().entries.map((entry) {
      // entry.key is the index (0, 1, 2...)
      // entry.value.value is the total amount
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();

    // Determine line color and label color based on theme
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final lineColor = primaryColor;
    final gridColor = isDarkMode
        ? Colors.white10
        : Colors.grey.withOpacity(0.3);
    final labelColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Container(
      padding: const EdgeInsets.only(top: 10, right: 20, left: 10, bottom: 10),
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxAmount / 5, // Show 5 horizontal lines
            getDrawingHorizontalLine: (value) {
              return FlLine(color: gridColor, strokeWidth: 0.5);
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  // Format the amount for the Y-axis labels
                  return Text(
                    '${value.toInt()}',
                    style: TextStyle(color: labelColor, fontSize: 10),
                  );
                },
                reservedSize: 40,
                interval: maxAmount / 5,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  // Convert index (value) back to month name
                  final index = value.toInt();
                  if (index >= 0 && index < sortedData.length) {
                    final month = sortedData[index].key.month;
                    final year =
                        sortedData[index].key.year %
                        100; // Last two digits of year
                    final monthName = _getMonthAbbreviation(month);
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '$monthName\'$year',
                        style: TextStyle(color: labelColor, fontSize: 10),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: gridColor, width: 1),
              left: const BorderSide(color: Colors.transparent),
              right: const BorderSide(color: Colors.transparent),
              top: const BorderSide(color: Colors.transparent),
            ),
          ),
          minX: 0,
          maxX: (sortedData.length - 1).toDouble(),
          minY: 0,
          maxY: maxAmount * 1.1, // 10% padding on top
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: lineColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: lineColor.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthAbbreviation(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }
}
