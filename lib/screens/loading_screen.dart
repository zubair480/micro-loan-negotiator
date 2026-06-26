import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/conversation_provider.dart';
import '../providers/generated_ui_provider.dart';
import '../models/generated_surface.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _rotateAnimation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
    _fadeAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeIn),
      ),
    );

    _simulateGeneration();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _simulateGeneration() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final convProvider = context.read<ConversationProvider>();
    final history = convProvider.conversationHistory;

    String jsonStr;
    if (history.contains('"surface_type"')) {
      final msgs = convProvider.messages;
      String? lastJson;
      for (final msg in msgs.reversed) {
        if (msg.isAI && msg.content.contains('"surface_type"')) {
          lastJson = msg.content;
          break;
        }
      }
      jsonStr = lastJson ?? _defaultSurfaceJson();
    } else {
      jsonStr = _defaultSurfaceJson();
    }

    try {
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      final surface = GeneratedSurface.fromJson(json);
      if (mounted) {
        context.read<GeneratedUIProvider>().setSurface(surface);
        Navigator.of(context).pushReplacementNamed('/generated');
      }
    } catch (e) {
      final surface = GeneratedSurface.fromJson(
        jsonDecode(_defaultSurfaceJson()) as Map<String, dynamic>,
      );
      if (mounted) {
        context.read<GeneratedUIProvider>().setSurface(surface);
        Navigator.of(context).pushReplacementNamed('/generated');
      }
    }
  }

  String _defaultSurfaceJson() {
    return '''{
      "id": "default_1",
      "title": "Your Loan Analysis",
      "surface_type": "offer_details",
      "widgets": [
        {
          "type": "RiskCard",
          "props": {
            "risk_score": 72,
            "risk_level": "medium",
            "risk_factors": ["Credit score could be improved"],
            "positive_factors": ["Stable employment", "Low existing debt"],
            "default_probability": 8.5
          }
        },
        {
          "type": "LoanChart",
          "props": {
            "chart_type": "apr_comparison",
            "current_apr": 7.5,
            "average_apr": 6.8,
            "best_apr": 5.9
          }
        },
        {
          "type": "RecommendationCard",
          "props": {
            "title": "Recommended Action",
            "description": "Consider improving your credit score before applying",
            "type": "info",
            "confidence": 0.85,
            "action_items": ["Review credit report", "Pay down existing debt"],
            "reasoning": "Based on your financial profile"
          }
        }
      ]
    }''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Transform.rotate(
                    angle: _rotateAnimation.value,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.green.withValues(alpha: 0.5),
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: const Center(
                            child: Text(
                              'N',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Column(
                    children: [
                      Text(
                        'Analyzing Your Profile',
                        style:
                            Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Generating your personalized loan interface...',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[400],
                            ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            backgroundColor:
                                Colors.grey.withValues(alpha: 0.2),
                            valueColor: const AlwaysStoppedAnimation(
                                Colors.green),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
