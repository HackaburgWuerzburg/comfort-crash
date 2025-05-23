import 'package:flutter/material.dart';
import 'package:comfort_crash/theme/app_theme.dart';
import 'package:comfort_crash/providers/comfort_data_provider.dart';
import 'package:provider/provider.dart';

class ExcuseSlayerScreen extends StatefulWidget {
  const ExcuseSlayerScreen({super.key});

  @override
  State<ExcuseSlayerScreen> createState() => _ExcuseSlayerScreenState();
}

class _ExcuseSlayerScreenState extends State<ExcuseSlayerScreen> {
  final TextEditingController _excuseController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isRecording = false;
  
  @override
  void dispose() {
    _excuseController.dispose();
    _scrollController.dispose();
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
          _excuseController.text = 'I\'m not ready yet';
        });
      }
    });
  }

  Future<void> _analyzeExcuse() async {
    if (_excuseController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an excuse first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    final comfortDataProvider = Provider.of<ComfortDataProvider>(context, listen: false);
    await comfortDataProvider.analyzeExcuse(_excuseController.text);
    
    // Clear the input field
    _excuseController.clear();
    
    // Scroll to the bottom of the chat
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final comfortDataProvider = Provider.of<ComfortDataProvider>(context);
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Excuse Slayer',
                style: AppTheme.headingStyle,
              ),
              const SizedBox(height: 10),
              Text(
                'AI coach that calls out your excuses with tough love',
                style: AppTheme.bodyStyle.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        
        // Chat Messages
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: comfortDataProvider.excuseConversation.length,
              itemBuilder: (context, index) {
                final message = comfortDataProvider.excuseConversation[index];
                final isUser = message.isUser;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: isUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      if (!isUser)
                        Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.psychology,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: isUser
                                ? AppTheme.primaryColor
                                : AppTheme.cardColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            message.text,
                            style: AppTheme.bodyStyle,
                          ),
                        ),
                      ),
                      
                      if (isUser)
                        Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        
        // Input Field
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.darkBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _excuseController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Type your excuse here...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    filled: true,
                    fillColor: AppTheme.backgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
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
              const SizedBox(width: 5),
              IconButton(
                onPressed: comfortDataProvider.isAnalyzingExcuse
                    ? null
                    : _analyzeExcuse,
                icon: comfortDataProvider.isAnalyzingExcuse
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryColor,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.send,
                        color: AppTheme.primaryColor,
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
