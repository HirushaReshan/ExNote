import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpensePieChart extends StatelessWidget {
  final Map<String, double> categoryTotals;
  final double totalAmount;

  const ExpensePieChart({
    super.key,
    required this.categoryTotals,
    required this.totalAmount,
  });

  // A fixed set of colors for consistency
  static const List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.cyan,
    Colors.pink,
  ];

  @override
  Widget build(BuildContext context) {
    if (totalAmount == 0) {
      return const Center(child: Text("No data to show for this period."));
    }

    int colorIndex = 0;

    List<PieChartSectionData> sections = categoryTotals.entries.map((entry) {
      final percentage = (entry.value / totalAmount) * 100;
      final amount = entry.value;
      final color = _colors[colorIndex % _colors.length];
      colorIndex++;

      final titleText =
          'Rs.${amount.toStringAsFixed(0)}\n${percentage.toStringAsFixed(1)}%';

      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: titleText,
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Changed to white for better contrast
        ),
      );
    }).toList();

    // Reset color index for the legend to match the chart colors
    colorIndex = 0;
    final Map<String, Color> categoryColors = {};
    for (var entry in categoryTotals.entries) {
      categoryColors[entry.key] = _colors[colorIndex % _colors.length];
      colorIndex++;
    }

    return Column(
      children: [
        SizedBox(
          height: 180, // Increased height for better visualization
          child: PieChart(
            PieChartData(
              sections: sections,
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Separated legend into its own widget for clarity and spacing
        _LegendWidget(categoryColors: categoryColors),
      ],
    );
  }
}

// NEW WIDGET: For displaying the legend clearly under the chart
class _LegendWidget extends StatelessWidget {
  final Map<String, Color> categoryColors;

  const _LegendWidget({required this.categoryColors});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 24.0, // Horizontal space between items
      runSpacing: 12.0, // Vertical space between lines
      alignment: WrapAlignment.center,
      children: categoryColors.entries.map((entry) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              color: entry.value,
              margin: const EdgeInsets.only(right: 6),
            ),
            Text(
              entry.key,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium, // Adjusted text size
            ),
          ],
        );
      }).toList(),
    );
  }
}
