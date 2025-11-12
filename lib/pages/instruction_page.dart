import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

class InstructionPage extends StatelessWidget {
  // FIX 1: Use the const Uri() constructor for compile-time constant initialization.
  // The named parameter 'path' is used for the URL string.
  final Uri _githubUri = Uri(
    scheme: 'https',
    host: 'github.com',
    path: 'HirushaReshan/ExNote',
  );

  // FIX 2: Keep the const constructor
  InstructionPage({super.key});

  // Function to launch the URL
  Future<void> _launchUrl() async {
    if (!await launchUrl(_githubUri, mode: LaunchMode.externalApplication)) {
      // Show an error message if the URL cannot be launched
      // You should add context handling here to display the error,
      // but for simplicity, we'll keep the throw for now.
      throw Exception('Could not launch $_githubUri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Instructions'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to ExNote!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Divider(height: 10),
            Text(
              'Built by -Hirusha',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Divider(height: 30),

            _buildInstructionCard(
              context,
              icon: Icons.add_circle_outline,
              title: 'Adding an Expense (Home Screen)',
              content:
                  'Use the **floating plus button** (FAB) on the Home screen to quickly log a new expense. Input the amount, category, and date.',
              onTap: null, // Not clickable
            ),

            _buildInstructionCard(
              context,
              icon: Icons.swipe_left_alt,
              title: 'Edit & Delete (Home Screen List)',
              content:
                  'In the **Recent Expenses** list, swipe an item left to **Delete** it, or swipe right to **Edit** the expense in a modal.',
              onTap: null, // Not clickable
            ),

            _buildInstructionCard(
              context,
              icon: Icons.bar_chart,
              title: 'Understanding Statistics',
              content:
                  'The Statistics tab features a **Pie Chart** (category breakdown) and **Line Chart** (spending trends). Use the filters to view data by day, week, or month.',
              onTap: null, // Not clickable
            ),

            _buildInstructionCard(
              context,
              icon: Icons.note_alt,
              title: 'Managing Notes',
              content:
                  'The Notes tab is for any reminders or financial planning notes. You can see important upcoming notes in the **carousel** on the Home screen.',
              onTap: null, // Not clickable
            ),

            // This card is now clickable and launches the URL
            _buildInstructionCard(
              context,
              icon: Icons.web,
              title: 'More Information and Updates',
              content:
                  'Visit https://github.com/HirushaReshan/ExNote for new updates. And more Information',
              onTap: () =>
                  _launchUrl(), // Wrap in a function call to ensure it's not const
            ),

            const SizedBox(height: 20),
            Text(
              'Tip: Use the Drawer to quickly access Settings and Dark Mode!',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    required VoidCallback? onTap, // Added onTap parameter
  }) {
    // Determine if the current theme is dark
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Choose icon color: White in dark mode, or primary color in light mode
    final iconColor = isDarkMode
        ? Colors.white
        : Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 3,
        // Wrap with InkWell and set onTap if provided
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Applied the dynamic icon color
                    Icon(icon, color: iconColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Add an arrow icon for clickable cards
                    if (onTap != null)
                      Icon(
                        Icons.open_in_new,
                        size: 18,
                        color: iconColor.withOpacity(0.7),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(content),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
