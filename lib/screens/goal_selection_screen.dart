// lib/screens/goal_selection_screen.dart

import 'package:flutter/material.dart';

class GoalSelectionScreen extends StatefulWidget {
  /// A list of goals that were already selected (can be empty).
  final List<String> selectedGoals;

  /// Pass in any previously-chosen goals here.
  const GoalSelectionScreen({
    Key? key,
    this.selectedGoals = const [],
  }) : super(key: key);

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  late List<String> _currentSelection;

  final List<String> _allGoals = [
    'Stress Relief',
    'Better Sleep',
    'Anxiety Reduction',
    'Confidence Boost',
    'Mindfulness',
    // …your other topics
  ];

  @override
  void initState() {
    super.initState();
    // Start with any goals passed in
    _currentSelection = List.from(widget.selectedGoals);
  }

  void _toggleGoal(String goal) {
    setState(() {
      if (_currentSelection.contains(goal)) {
        _currentSelection.remove(goal);
      } else {
        _currentSelection.add(goal);
      }
    });
  }

  void _submit() {
    // e.g. pass back to previous screen
    Navigator.of(context).pop(_currentSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Goals'),
        actions: [
          TextButton(
            onPressed: _currentSelection.isEmpty ? null : _submit,
            child: const Text(
              'Done',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: _allGoals.map((goal) {
          final selected = _currentSelection.contains(goal);
          return ListTile(
            title: Text(goal),
            trailing: Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: selected ? Colors.greenAccent : Colors.grey,
            ),
            onTap: () => _toggleGoal(goal),
          );
        }).toList(),
      ),
    );
  }
}
