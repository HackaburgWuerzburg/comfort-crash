import 'package:flutter/material.dart';
import 'package:comfort_crash/theme/app_theme.dart';
import 'package:comfort_crash/providers/comfort_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class ComfortRadarScreen extends StatefulWidget {
  const ComfortRadarScreen({super.key});

  @override
  State<ComfortRadarScreen> createState() => _ComfortRadarScreenState();
}

class _ComfortRadarScreenState extends State<ComfortRadarScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    final comfortDataProvider = Provider.of<ComfortDataProvider>(context, listen: false);
    await comfortDataProvider.analyzeComfortPatterns();
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
            'Comfort Zone Radar',
            style: AppTheme.headingStyle,
          ),
          const SizedBox(height: 10),
          Text(
            'AI-powered analysis of your comfort patterns',
            style: AppTheme.bodyStyle.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 30),
          
          // Radar Chart
          Container(
            height: 300,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: comfortDataProvider.isAnalyzing
                ? const Center(child: CircularProgressIndicator())
                : _buildRadarChart(comfortDataProvider),
          ),
          
          const SizedBox(height: 30),
          
          // Comfort Patterns Summary
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
                  'Comfort Patterns',
                  style: AppTheme.subheadingStyle,
                ),
                const SizedBox(height: 15),
                if (comfortDataProvider.isAnalyzing)
                  const Center(child: CircularProgressIndicator())
                else if (comfortDataProvider.comfortPatterns.isEmpty)
                  const Text(
                    'No comfort patterns detected yet. Use the app more to get insights.',
                    style: TextStyle(color: Colors.white70),
                  )
                else
                  ...comfortDataProvider.comfortPatterns.map((pattern) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.insights,
                            color: AppTheme.accentColor,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              pattern,
                              style: AppTheme.bodyStyle,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Suggested Discomfort Goals
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
                  'Suggested Discomfort Goals',
                  style: AppTheme.subheadingStyle,
                ),
                const SizedBox(height: 15),
                if (comfortDataProvider.isAnalyzing)
                  const Center(child: CircularProgressIndicator())
                else if (comfortDataProvider.discomfortGoals.isEmpty)
                  const Text(
                    'No suggested goals yet. Use the app more to get personalized suggestions.',
                    style: TextStyle(color: Colors.white70),
                  )
                else
                  ...comfortDataProvider.discomfortGoals.map((goal) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.flag,
                              color: AppTheme.primaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  goal,
                                  style: AppTheme.bodyStyle.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // Add to my goals
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Added to your goals'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.accentColor,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: const Text('Add to My Goals'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRadarChart(ComfortDataProvider provider) {
    final categories = [
      'Social',
      'Career',
      'Learning',
      'Physical',
      'Creative',
    ];
    
    // Sample data - in a real app, this would come from the provider
    final comfortLevels = provider.comfortLevels.isEmpty
        ? [0.8, 0.6, 0.4, 0.7, 0.5]
        : provider.comfortLevels;
  
    return RadarChart(
      RadarChartData(
        radarShape: RadarShape.polygon,
        radarBorderData: BorderSide(color: AppTheme.accentColor.withOpacity(0.3)),
        gridBorderData: BorderSide(color: Colors.white.withOpacity(0.2), width: 1),
        tickCount: 5,
        ticksTextStyle: const TextStyle(color: Colors.transparent),
        tickBorderData: const BorderSide(color: Colors.transparent),
        titleTextStyle: AppTheme.bodyStyle.copyWith(fontSize: 12),
        getTitle: (index, angle) {
          return RadarChartTitle(
            text: categories[index],
            angle: angle,
          );
        },
        dataSets: [
          RadarDataSet(
            fillColor: AppTheme.primaryColor.withOpacity(0.3),
            borderColor: AppTheme.primaryColor,
            borderWidth: 2,
            entryRadius: 5,
            dataEntries: List.generate(
              categories.length,
              (index) => RadarEntry(value: comfortLevels[index]),
            ),
          ),
        ],
      ),
    );
  }
}
