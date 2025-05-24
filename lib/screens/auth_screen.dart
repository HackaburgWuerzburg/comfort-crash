// lib/screens/auth_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/comfort_data_provider.dart';
import '../widgets/main_scaffold.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _q1Controller = TextEditingController();
  final _q2Controller = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _q1Controller.dispose();
    _q2Controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);

    // Gather answers
    final answers = <String, String?>{
      'question1': _q1Controller.text.trim(),
      'question2': _q2Controller.text.trim(),
    };

    // Simulate any async work (e.g. saving to server)
    await Future.delayed(const Duration(milliseconds: 300));

    // Always check mounted before using context after await
    if (!mounted) return;

    // Save into ComfortDataProvider
    context.read<ComfortDataProvider>().saveResults(answers);

    // Navigate into the main app
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainScaffold()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _q1Controller,
              decoration: const InputDecoration(
                labelText: 'What are you struggling with most?',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _q2Controller,
              decoration: const InputDecoration(
                labelText: 'What would success look like?',
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Text('Get Started'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
