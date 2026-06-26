import '../models/loan_offer.dart';
import '../models/financial_profile.dart';
import '../models/risk_analysis.dart';
import '../models/negotiation_state.dart';
import '../models/generated_surface.dart';
import '../models/generated_widget.dart';
import '../services/featherless_service.dart';
import '../services/financial_service.dart';
import '../services/negotiation_service.dart';

class LoanAgent {
  final FeatherlessService _aiService;
  final FinancialService _financialService;
  final NegotiationService _negotiationService;

  LoanAgent({
    required FeatherlessService aiService,
    required FinancialService financialService,
    required NegotiationService negotiationService,
  })  : _aiService = aiService,
        _financialService = financialService,
        _negotiationService = negotiationService;

  Future<RiskAnalysis> analyzeRisk({
    required FinancialProfile profile,
    required LoanOffer offer,
  }) async {
    try {
      final json = await _aiService.generateUISurface(
        'Analyze risk for profile with credit score ${profile.creditScore}',
      );
      return RiskAnalysis.fromJson(json);
    } catch (_) {
      return _financialService.analyzeRisk(profile: profile, offer: offer);
    }
  }

  Future<GeneratedSurface> generateSurface({
    required String surfaceType,
    required String title,
    required FinancialProfile profile,
    LoanOffer? offer,
    RiskAnalysis? riskAnalysis,
  }) async {
    final context = '''
User financial profile:
- Income: \$${profile.annualIncome.toStringAsFixed(0)}
- Credit Score: ${profile.creditScore}
- Employment: ${profile.employmentStatus}
- Monthly Expenses: \$${profile.monthlyExpenses.toStringAsFixed(0)}

Generate a $surfaceType surface with widgets.
''';

    try {
      final json = await _aiService.generateUISurface(context);
      return GeneratedSurface.fromJson(json);
    } catch (_) {
      return _fallbackSurface(surfaceType, title);
    }
  }

  Future<NegotiationState> initializeNegotiation({
    required LoanOffer offer,
    required FinancialProfile profile,
  }) async {
    try {
      final result = await _aiService.negotiateLoan(
        offer.apr,
        offer.apr * 0.85,
        offer.loanAmount,
        profile.creditScore,
      );

      final targetApr = (result['suggested_apr'] as num?)?.toDouble() ?? offer.apr * 0.85;
      final savings = (result['monthly_savings'] as num?)?.toDouble() ?? 0;
      final talkingPoints =
          (result['talking_points'] as List<dynamic>?)?.cast<String>() ?? [];

      return NegotiationState(
        currentApr: offer.apr,
        targetApr: targetApr,
        currentMonthlyPayment: offer.monthlyPayment,
        targetMonthlyPayment: offer.monthlyPayment - savings,
        negotiationRound: 0,
        status: 'ready',
        offers: [
          NegotiationOffer(
            id: 'initial',
            label: 'Initial Offer',
            apr: offer.apr,
            monthlyPayment: offer.monthlyPayment,
            totalCost: offer.totalCost,
            isCurrentOffer: true,
          ),
        ],
        suggestions: talkingPoints,
      );
    } catch (_) {
      return _negotiationService.initializeNegotiation(
        offer: offer,
        profile: profile,
      );
    }
  }

  GeneratedSurface _fallbackSurface(String surfaceType, String title) {
    List<GeneratedWidget> widgets;

    switch (surfaceType) {
      case 'risk_analysis':
        widgets = [
          GeneratedWidget(
            type: 'RiskCard',
            props: {
              'risk_score': 70,
              'risk_level': 'medium',
              'risk_factors': ['Review needed'],
              'positive_factors': ['Profile submitted'],
              'default_probability': 10,
            },
          ),
          GeneratedWidget(
            type: 'WarningCard',
            props: {
              'warnings': ['This is a preliminary analysis'],
              'severity': 'info',
              'title': 'Preliminary Assessment',
            },
          ),
        ];
      case 'offer_details':
        widgets = [
          GeneratedWidget(
            type: 'LoanChart',
            props: {
              'chart_type': 'apr_comparison',
              'current_apr': 7.5,
              'average_apr': 6.8,
              'best_apr': 5.9,
            },
          ),
          GeneratedWidget(
            type: 'MonthlyBreakdown',
            props: {
              'principal_payment': 400,
              'interest_payment': 600,
              'remaining_balance': 150000,
              'month': 1,
              'total_months': 360,
            },
          ),
        ];
      case 'budget_planning':
        widgets = [
          GeneratedWidget(
            type: 'BudgetCard',
            props: {
              'monthly_income': 5000,
              'monthly_expenses': 3200,
              'monthly_savings': 800,
            },
          ),
          GeneratedWidget(
            type: 'FinancialHealthCard',
            props: {
              'health_score': 65,
              'metrics': {
                'credit_score': 680,
                'savings_ratio': 0.15,
                'dti': 0.35,
              },
            },
          ),
        ];
      case 'negotiation':
        widgets = [
          GeneratedWidget(
            type: 'NegotiationPanel',
            props: {
              'current_apr': 7.5,
              'target_apr': 6.5,
              'current_monthly_payment': 1400,
              'target_monthly_payment': 1250,
              'negotiation_round': 0,
              'status': 'ready',
              'offers': [],
            },
          ),
          GeneratedWidget(
            type: 'TradeoffSlider',
            props: {
              'option_a_label': 'Lower Rate',
              'option_b_label': 'Lower Fees',
            },
          ),
        ];
      case 'summary':
      default:
        widgets = [
          GeneratedWidget(
            type: 'RecommendationCard',
            props: {
              'title': 'Loan Summary',
              'description': 'Your loan analysis is ready for review',
              'type': 'info',
              'confidence': 0.85,
              'action_items': ['Review full details', 'Consider negotiation'],
              'reasoning': 'Based on your complete financial profile',
            },
          ),
          GeneratedWidget(
            type: 'ActionCard',
            props: {
              'title': 'Next Steps',
              'actions': [
                {
                  'label': 'View Offer Details',
                  'description': 'Full terms breakdown',
                  'icon': 'description',
                  'primary': true,
                },
                {
                  'label': 'Start Negotiation',
                  'description': 'Try for better terms',
                  'icon': 'compare',
                },
              ],
            },
          ),
        ];
    }

    return GeneratedSurface(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      surfaceType: surfaceType,
      widgets: widgets,
    );
  }
}
