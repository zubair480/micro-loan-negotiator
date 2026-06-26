import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../utils/secrets.dart';

class FeatherlessService {
  final String _apiKey;
  final String _baseUrl;
  final String _model;

  FeatherlessService({
    String? apiKey,
    String? baseUrl,
    String? model,
  })  : _apiKey = apiKey ?? Secrets.featherlessKey,
        _baseUrl = baseUrl ?? AppConstants.featherlessBaseUrl,
        _model = model ?? AppConstants.featherlessModel;

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
- RiskCard, LoanChart, BudgetCard, TimelineWidget, RecommendationCard
- ConfidenceCard, NegotiationPanel, TradeoffSlider, WarningCard
- FinancialHealthCard, MonthlyBreakdown, ActionCard

If the user is just chatting, respond conversationally but stay focused on loan understanding.
When you detect enough information to generate a UI, include the JSON block.
''';
  }

  Future<String> sendMessage(String message, {List<Map<String, String>>? history}) async {
    try {
      final messages = [
        {'role': 'system', 'content': _systemPrompt()},
        if (history != null) ...history,
        {'role': 'user', 'content': message},
      ];

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 4096,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final choices = data['choices'] as List<dynamic>;
        if (choices.isNotEmpty) {
          return (choices[0]['message']['content'] as String?) ?? '';
        }
        return '';
      }

      return 'Error ${response.statusCode}: ${response.body}';
    } catch (e) {
      return 'Connection error: $e. Make sure the Featherless AI API key is set in config/keys.json or passed via --dart-define=FEATHERLESS_KEY.';
    }
  }

  Future<Map<String, dynamic>> generateUISurface(String context) async {
    try {
      final prompt = '''
Based on this conversation context, generate a UI surface with widgets:

$context

Respond with ONLY valid JSON. No markdown formatting. No explanation.
''';

      final messages = [
        {'role': 'system', 'content': _systemPrompt()},
        {'role': 'user', 'content': prompt},
      ];

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': messages,
          'temperature': 0.5,
          'max_tokens': 4096,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final text = (data['choices'] as List<dynamic>).isNotEmpty
            ? (data['choices'][0]['message']['content'] as String?) ?? ''
            : '';
        final jsonStart = text.indexOf('{');
        final jsonEnd = text.lastIndexOf('}') + 1;
        if (jsonStart >= 0 && jsonEnd > jsonStart) {
          return jsonDecode(text.substring(jsonStart, jsonEnd))
              as Map<String, dynamic>;
        }
      }
      return {
        'surface_type': 'error',
        'title': 'Error',
        'widgets': <Map<String, dynamic>>[],
      };
    } catch (e) {
      return {
        'surface_type': 'error',
        'title': 'Error',
        'widgets': <Map<String, dynamic>>[],
      };
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

      final messages = [
        {'role': 'system', 'content': 'You are a loan negotiation AI.'},
        {'role': 'user', 'content': prompt},
      ];

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': messages,
          'temperature': 0.5,
          'max_tokens': 2048,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final text = (data['choices'] as List<dynamic>).isNotEmpty
            ? (data['choices'][0]['message']['content'] as String?) ?? ''
            : '';
        final jsonStart = text.indexOf('{');
        final jsonEnd = text.lastIndexOf('}') + 1;
        if (jsonStart >= 0 && jsonEnd > jsonStart) {
          return jsonDecode(text.substring(jsonStart, jsonEnd))
              as Map<String, dynamic>;
        }
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
