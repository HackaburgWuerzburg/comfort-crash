import 'package:flutter/material.dart';
import 'package:comfort_crash/theme/app_theme.dart';
import 'package:comfort_crash/screens/auth_screen.dart';
import 'package:comfort_crash/widgets/goal_chip.dart';

class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  final List<String> _goals = [
    'Confidence', 'Career', 'Creativity', 'Social Skills',
    'Public Speaking', 'Leadership', 'Fitness', 'Learning',
    'Relationships', 'Financial Growth', 'Emotional Intelligence',
  ];
  
  final Set<String> _selectedGoals = {};

  void _toggleGoal(String goal) {
    setState(() {
      if (_selectedGoals.contains(goal)) {
        _selectedGoals.remove(goal);
      } else {
        _selectedGoals.add(goal);
      }
    });
  }

  void _continueToAuth() {
    if (_selectedGoals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one goal area'),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
      return;
    }
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AuthScreen(selectedGoals: _selectedGoals.toList()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Choose Your Goals'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What areas do you want to grow in?',
                style: AppTheme.subheadingStyle,
              ),
              const SizedBox(height: 8),
              Text(
                'Select the areas where you want to push your comfort zone.',
                style: AppTheme.bodyStyle.copyWith(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _goals.map((goal) {
                    final isSelected = _selectedGoals.contains(goal);
                    return GoalChip(
                      label: goal,
                      isSelected: isSelected,
                      onTap: () => _toggleGoal(goal),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _continueToAuth,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: AppTheme.buttonTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
