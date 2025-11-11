// lib/pages/statistics_page.dart (UPDATED)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exnote/models/expense.dart';
import 'package:exnote/providers/expense_provider.dart';
import 'package:exnote/widgets/expense_bar_chart.dart';
import 'package:exnote/widgets/expense_pie_chart.dart';
// NEW IMPORT: Import the new Line Chart
import 'package:exnote/widgets/expense_line_chart.dart';

enum StatFilter { daily, weekly, monthly }

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  StatFilter _currentFilter = StatFilter.monthly;

  List<Expense> _getFilteredExpenses(ExpenseProvider provider) {
    // ... (Keep existing implementation of _getFilteredExpenses as is)
    final now = DateTime.now();
    if (_currentFilter == StatFilter.daily) {
      return provider.getDailyExpenses(now);
    } else if (_currentFilter == StatFilter.weekly) {
      // Logic for current week (Mon-Sun)
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));
      return provider.readExpensesByDateRange(startOfWeek, endOfWeek);
    } else {
      // Logic for current month
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(
        now.year,
        now.month + 1,
        0,
      ); // Day 0 of next month is last day of this month
      return provider.readExpensesByDateRange(startOfMonth, endOfMonth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, child) {
          final filteredExpenses = _getFilteredExpenses(expenseProvider);
          final categoryTotals = expenseProvider.getCategoryTotals(
            filteredExpenses,
          );
          final totalAmount = filteredExpenses.fold(
            0.0,
            (sum, item) => sum + item.amount,
          );

          // Data for the NEW Line Chart (Last 6 months)
          final monthlyTotals = expenseProvider.getMonthlyTotalsForRange(6);

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // --- 1. Filter Toggle ---
              SegmentedButton<StatFilter>(
                // ... (Keep SegmentedButton as is)
                segments: const <ButtonSegment<StatFilter>>[
                  ButtonSegment<StatFilter>(
                    value: StatFilter.daily,
                    label: Text('Daily'),
                  ),
                  ButtonSegment<StatFilter>(
                    value: StatFilter.weekly,
                    label: Text('Weekly'),
                  ),
                  ButtonSegment<StatFilter>(
                    value: StatFilter.monthly,
                    label: Text('Monthly'),
                  ),
                ],
                selected: <StatFilter>{_currentFilter},
                onSelectionChanged: (Set<StatFilter> newSelection) {
                  setState(() {
                    _currentFilter = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 20),

              // --- 2. Pie Chart (Category Breakdown) ---
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Category Breakdown',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      ExpensePieChart(
                        categoryTotals: categoryTotals,
                        totalAmount: totalAmount,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- NEW CHART: Monthly Spending Trend (Line Chart) ---
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Spending Trend (Last 6 Months)',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Divider(),
                      // NEW WIDGET
                      ExpenseLineChart(monthlyTotals: monthlyTotals),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- 3. Economy/Comparison Chart (Bar Chart for Weekly Comparison) ---
              // NOTE: The title is changed from 'Monthly Spending Comparison' to reflect
              // the actual data (Last 7 Days) in ExpenseBarChart.
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Spending (Last 7 Days)',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Divider(),
                      const SizedBox(height: 200, child: ExpenseBarChart()),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
