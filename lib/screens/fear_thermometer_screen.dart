import 'package:flutter/material.dart';
import 'package:comfort_crash/theme/app_theme.dart';
import 'package:comfort_crash/providers/comfort_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class FearThermometerScreen extends StatefulWidget {
  const FearThermometerScreen({super.key});

  @override
  State<FearThermometerScreen> createState() => _FearThermometerScreenState();
}

class _FearThermometerScreenState extends State<FearThermometerScreen> {
  final TextEditingController _fearController = TextEditingController();
  bool _isRecording = false;
  
  @override
  void dispose() {
    _fearController.dispose();
    super.dispose();
  }

  void _startVoiceRecording() {
    setState(() {
      _isRecording = true;
    });
    
    // Simulate voice recording
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isRecording = false;
          _fearController.text = 'Public speaking';
        });
      }
    });
  }

  Future<void> _analyzeFear() async {
    if (_fearController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a fear first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    final comfortDataProvider = Provider.of<ComfortDataProvider>(context, listen: false);
    await comfortDataProvider.analyzeFear(_fearController.text);
  }

  @override
  Widget build(BuildContext context) {
    final comfortDataProvider = Provider.of<ComfortDataProvider>(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fear Thermometer',
            style: AppTheme.headingStyle,
          ),
          const SizedBox(height: 10),
          Text(
            'Measure and gradually reduce your fears',
            style: AppTheme.bodyStyle.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 30),
          
          // Fear Input
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What are you afraid of?',
                  style: AppTheme.subheadingStyle,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _fearController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Type your fear here...',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                          filled: true,
                          fillColor: AppTheme.backgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: _isRecording ? null : _startVoiceRecording,
                      icon: Icon(
                        _isRecording ? Icons.mic : Icons.mic_none,
                        color: _isRecording ? AppTheme.primaryColor : Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: comfortDataProvider.isAnalyzingFear
                        ? null
                        : _analyzeFear,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: comfortDataProvider.isAnalyzingFear
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Analyze Fear',
                            style: AppTheme.buttonTextStyle,
                          ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Fear Analysis Results
          if (comfortDataProvider.currentFear.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Fear Analysis',
                        style: AppTheme.subheadingStyle,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _getFearColor(comfortDataProvider.fearIntensity),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Level ${comfortDataProvider.fearIntensity}/10',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Fear Thermometer Visualization
                  SizedBox(
                    height: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: comfortDataProvider.fearIntensity / 10,
                        backgroundColor: Colors.grey.shade800,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getFearColor(comfortDataProvider.fearIntensity),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  Text(
                    'Micro-Task to Reduce Fear',
                    style: AppTheme.subheadingStyle.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppTheme.accentColor.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      comfortDataProvider.fearTask,
                      style: AppTheme.bodyStyle,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Mark as complete
                            comfortDataProvider.completeFearTask();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Task completed! Your fear level has decreased.'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Complete Task'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Skip task
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Task skipped. Try another one later.'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Skip'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          
          const SizedBox(height: 30),
          
          // Fear Progress Graph
          if (comfortDataProvider.fearHistory.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              height: 300,
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fear Progress',
                    style: AppTheme.subheadingStyle,
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 2,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.white.withOpacity(0.1),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  space: 8.0,
                                  child: Text(
                                    'Day ${value.toInt() + 1}',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 2,
                              getTitlesWidget: (value, meta) {
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  space: 8.0,
                                  child: Text(
                                    value.toInt().toString(),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              },
                              reservedSize: 30,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: comfortDataProvider.fearHistory.length.toDouble() - 1,
                        minY: 0,
                        maxY: 10,
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(
                              comfortDataProvider.fearHistory.length,
                              (index) => FlSpot(
                                index.toDouble(),
                                comfortDataProvider.fearHistory[index].toDouble(),
                              ),
                            ),
                            isCurved: true,
                            color: AppTheme.primaryColor,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppTheme.primaryColor.withOpacity(0.2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
  
  Color _getFearColor(int intensity) {
    if (intensity <= 3) {
      return Colors.green;
    } else if (intensity <= 6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
