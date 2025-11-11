// lib/widgets/expense_pie_chart.dart (UPDATED)
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

  @override
  Widget build(BuildContext context) {
    if (totalAmount == 0) {
      return const Center(child: Text("No data to show for this period."));
    }

    // Assign colors to categories (you'd ideally map colors consistently)
    final List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.cyan,
      Colors.pink,
    ];
    int colorIndex = 0;

    List<PieChartSectionData> sections = categoryTotals.entries.map((entry) {
      final percentage = (entry.value / totalAmount) * 100;
      final amount = entry.value; // Get the raw amount
      final color = colors[colorIndex % colors.length];
      colorIndex++;

      // NEW: Show Amount and Percentage in the title
      final titleText =
          'Rs.${amount.toStringAsFixed(0)}\n${percentage.toStringAsFixed(1)}%';

      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: titleText, // UPDATED title
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black, // Use a contrasting color
        ),
      );
    }).toList();

    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PieChart(
            PieChartData(
              sections: sections,
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // UPDATED: Increased spacing in Wrap
        Wrap(
          spacing: 16.0, // Increased spacing
          runSpacing: 8.0, // Increased run spacing
          children: categoryTotals.entries.map((entry) {
            final color =
                colors[categoryTotals.keys.toList().indexOf(entry.key) %
                    colors.length];
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  color: color,
                  margin: const EdgeInsets.only(right: 4),
                ), // Added margin
                Text(
                  '${entry.key}: Rs.${entry.value.toStringAsFixed(2)}', // Optional: Show amount here too
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
