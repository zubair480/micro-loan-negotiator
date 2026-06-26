import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../utils/constants.dart';

class GeminiService {
  late GenerativeModel _model;
  ChatSession? _chatSession;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: AppConstants.geminiApiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 4096,
      ),
    );
  }

  String _systemPrompt() {
    return '''
You are Negotia AI, a financial assistant that helps borrowers understand loan offers.

Your job is to:
1. Ask the borrower about their financial situation
2. Analyze loan offers they receive
3. Generate personalized UI surfaces using ONLY widgets from the catalog

When generating a UI surface, respond with ONLY valid JSON in this format:

{
  "surface_type": "offer_details" | "risk_analysis" | "negotiation" | "summary" | "budget_planning",
  "title": "Surface Title",
  "widgets": [
    {
      "type": "RiskCard",
      "props": {
        "risk_score": 75,
        "risk_level": "medium",
        "risk_factors": ["High DTI ratio"],
        "positive_factors": ["Stable employment"],
        "default_probability": 12.5
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
    }
  ]
}

Available widget types:
- RiskCard: Shows risk analysis with score, level, factors
- LoanChart: Shows loan charts (apr_comparison, payment_breakdown, interest_over_time)
- BudgetCard: Shows budget breakdown with income, expenses, savings
- TimelineWidget: Shows payment timeline or milestones
- RecommendationCard: Shows personalized recommendations
- ConfidenceCard: Shows confidence metric
- NegotiationPanel: Shows negotiation interface
- TradeoffSlider: Shows tradeoff comparison
- WarningCard: Shows warnings and cautions
- FinancialHealthCard: Shows overall financial health
- MonthlyBreakdown: Shows detailed monthly payment breakdown
- ActionCard: Shows action items

If the user is just chatting, respond conversationally but stay focused on loan understanding.
When you detect enough information to generate a UI, include the JSON block.
''';
  }

  Future<String> sendMessage(String message) async {
    try {
      _chatSession ??= _model.startChat(history: [
        Content.system(_systemPrompt()),
      ]);

      final response = await _chatSession!.sendMessage(Content.text(message));
      return response.text ?? 'I apologize, but I could not process that.';
    } catch (e) {
      return 'I encountered an error: $e';
    }
  }

  Future<String> generateUISurface(String context) async {
    try {
      final prompt = '''
Based on this conversation context, generate a UI surface with widgets:

$context

Respond with ONLY valid JSON. No markdown formatting.
''';
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text ?? '';
      final jsonStart = text.indexOf('{');
      final jsonEnd = text.lastIndexOf('}') + 1;
      if (jsonStart >= 0 && jsonEnd > jsonStart) {
        return text.substring(jsonStart, jsonEnd);
      }
      return text;
    } catch (e) {
      return '{"surface_type":"error","title":"Error","widgets":[]}';
    }
  }

  Future<Map<String, dynamic>> negotiateLoan(
    double currentApr,
    double targetApr,
    double loanAmount,
    int creditScore,
  ) async {
    try {
      final prompt = '''
Act as a loan negotiation AI. Given:
- Current APR: $currentApr%
- Target APR: $targetApr%
- Loan Amount: \$${loanAmount.toStringAsFixed(0)}
- Credit Score: $creditScore

Generate a negotiation strategy as JSON with keys: "feasible" (bool), "suggested_apr" (double), "monthly_savings" (double), "talking_points" (list of strings), "strategy" (string).
Respond with ONLY valid JSON.
''';
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text ?? '';
      final jsonStart = text.indexOf('{');
      final jsonEnd = text.lastIndexOf('}') + 1;
      if (jsonStart >= 0 && jsonEnd > jsonStart) {
        final json = jsonDecode(text.substring(jsonStart, jsonEnd));
        return json as Map<String, dynamic>;
      }
      return {
        'feasible': false,
        'suggested_apr': currentApr,
        'monthly_savings': 0,
        'talking_points': ['Unable to generate strategy'],
        'strategy': 'Error occurred',
      };
    } catch (e) {
      return {
        'feasible': false,
        'suggested_apr': currentApr,
        'monthly_savings': 0,
        'talking_points': ['Error: $e'],
        'strategy': 'Error occurred',
      };
    }
  }
}
