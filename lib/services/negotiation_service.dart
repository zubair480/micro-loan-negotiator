import 'dart:math';
import '../models/loan_offer.dart';
import '../models/negotiation_state.dart';
import '../models/financial_profile.dart';

class NegotiationService {
  static const double _aprReductionPerRound = 0.25;
  static const int _maxRounds = 5;

  NegotiationState initializeNegotiation({
    required LoanOffer offer,
    required FinancialProfile profile,
  }) {
    final targetApr = offer.apr * 0.85;
    final savings = _calculateMonthlyPayment(offer.loanAmount, offer.apr) -
        _calculateMonthlyPayment(offer.loanAmount, targetApr);

    final baseOffer = NegotiationOffer(
      id: 'initial',
      label: 'Initial Offer',
      apr: offer.apr,
      monthlyPayment: offer.monthlyPayment,
      totalCost: offer.totalCost,
      isCurrentOffer: true,
    );

    final stretchOffer = NegotiationOffer(
      id: 'stretch',
      label: 'Stretch Goal',
      apr: targetApr,
      monthlyPayment:
          _calculateMonthlyPayment(offer.loanAmount, targetApr),
      totalCost: _calculateTotalCost(offer.loanAmount, targetApr),
      isCurrentOffer: false,
    );

    return NegotiationState(
      currentApr: offer.apr,
      targetApr: targetApr,
      currentMonthlyPayment: offer.monthlyPayment,
      targetMonthlyPayment: savings,
      negotiationRound: 0,
      status: 'ready',
      offers: [baseOffer, stretchOffer],
      suggestions: _generateSuggestions(profile, offer),
    );
  }

  NegotiationState processCounter({
    required NegotiationState state,
    required double counterApr,
    required LoanOffer offer,
  }) {
    if (state.negotiationRound >= _maxRounds) {
      return NegotiationState(
        currentApr: state.currentApr,
        targetApr: state.targetApr,
        currentMonthlyPayment: state.currentMonthlyPayment,
        targetMonthlyPayment: state.targetMonthlyPayment,
        negotiationRound: state.negotiationRound,
        status: 'max_rounds_reached',
        offers: state.offers,
        suggestions: state.suggestions,
      );
    }

    final newApr = max(counterApr, offer.apr * 0.75);
    final newMonthly = _calculateMonthlyPayment(offer.loanAmount, newApr);
    final newTotal = _calculateTotalCost(offer.loanAmount, newApr);

    final counterOffer = NegotiationOffer(
      id: 'round_${state.negotiationRound + 1}',
      label: 'Counter Offer ${state.negotiationRound + 1}',
      apr: newApr,
      monthlyPayment: newMonthly,
      totalCost: newTotal,
      isCurrentOffer: true,
    );

    final updatedOffers = [
      ...state.offers.map((o) =>
          NegotiationOffer(
            id: o.id,
            label: o.label,
            apr: o.apr,
            monthlyPayment: o.monthlyPayment,
            totalCost: o.totalCost,
            isCurrentOffer: false,
          ),
      ),
      counterOffer,
    ];

    return NegotiationState(
      currentApr: newApr,
      targetApr: state.targetApr,
      currentMonthlyPayment: newMonthly,
      targetMonthlyPayment: state.targetMonthlyPayment,
      negotiationRound: state.negotiationRound + 1,
      status: state.negotiationRound + 1 >= _maxRounds
          ? 'ready_to_accept'
          : 'negotiating',
      offers: updatedOffers,
      suggestions: state.suggestions,
    );
  }

  double suggestCounterApr(NegotiationState state, FinancialProfile profile) {
    final baseReduction = state.currentApr - _aprReductionPerRound;
    final scoreBonus = (profile.creditScore - 600) / 100 * 0.1;
    final counterApr = baseReduction - scoreBonus;
    return double.parse(counterApr.toStringAsFixed(2));
  }

  List<String> _generateSuggestions(
    FinancialProfile profile,
    LoanOffer offer,
  ) {
    final suggestions = <String>[];
    if (profile.creditScore > 720) {
      suggestions.add(
        'Your excellent credit score qualifies you for better rates',
      );
    }
    if (profile.existingDebt > 0) {
      suggestions.add('Consider debt consolidation to lower overall payments');
    }
    if (offer.originationFee > offer.loanAmount * 0.02) {
      suggestions.add('Ask about waiving the origination fee');
    }
    suggestions.add('Request a rate lock to protect against market changes');
    return suggestions;
  }

  double _calculateMonthlyPayment(double principal, double annualRate) {
    final monthlyRate = annualRate / 12 / 100;
    const term = 360;
    if (monthlyRate == 0) return principal / term;
    final factor = (1 + monthlyRate).toDouble();
    return principal *
        (monthlyRate * pow(factor, term).toDouble()) /
        (pow(factor, term).toDouble() - 1);
  }

  double _calculateTotalCost(double principal, double annualRate) {
    final monthly = _calculateMonthlyPayment(principal, annualRate);
    return monthly * 360;
  }
}
