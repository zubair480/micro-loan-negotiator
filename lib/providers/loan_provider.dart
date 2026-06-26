import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/loan_offer.dart';
import '../models/financial_profile.dart';
import '../models/risk_analysis.dart';
import '../models/negotiation_state.dart';

class LoanProvider extends ChangeNotifier {
  LoanOffer? _currentOffer;
  FinancialProfile? _financialProfile;
  RiskAnalysis? _riskAnalysis;
  NegotiationState? _negotiationState;
  List<LoanOffer> _alternativeOffers = [];
  bool _isLoading = false;

  LoanOffer? get currentOffer => _currentOffer;
  FinancialProfile? get financialProfile => _financialProfile;
  RiskAnalysis? get riskAnalysis => _riskAnalysis;
  NegotiationState? get negotiationState => _negotiationState;
  List<LoanOffer> get alternativeOffers =>
      List.unmodifiable(_alternativeOffers);
  bool get isLoading => _isLoading;

  void setCurrentOffer(LoanOffer offer) {
    _currentOffer = offer;
    notifyListeners();
  }

  void setFinancialProfile(FinancialProfile profile) {
    _financialProfile = profile;
    notifyListeners();
  }

  void setRiskAnalysis(RiskAnalysis analysis) {
    _riskAnalysis = analysis;
    notifyListeners();
  }

  void setNegotiationState(NegotiationState state) {
    _negotiationState = state;
    notifyListeners();
  }

  void setAlternativeOffers(List<LoanOffer> offers) {
    _alternativeOffers = offers;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void updateNegotiationApr(double newApr) {
    if (_negotiationState == null || _currentOffer == null) return;
    final updatedMonthly =
        _calculateMonthlyPayment(_currentOffer!.loanAmount, newApr);
    final updatedState = NegotiationState(
      currentApr: newApr,
      targetApr: _negotiationState!.targetApr,
      currentMonthlyPayment: updatedMonthly,
      targetMonthlyPayment: _negotiationState!.targetMonthlyPayment,
      negotiationRound: _negotiationState!.negotiationRound + 1,
      status: 'negotiating',
      offers: _negotiationState!.offers,
      suggestions: _negotiationState!.suggestions,
    );
    _negotiationState = updatedState;
    notifyListeners();
  }

  double _calculateMonthlyPayment(double principal, double annualRate) {
    final monthlyRate = annualRate / 12 / 100;
    final term = 360;
    if (monthlyRate == 0) return principal / term;
    final factor = (1 + monthlyRate).toDouble();
    final payment =
        principal * (monthlyRate * pow(factor, term).toDouble()) / (pow(factor, term).toDouble() - 1);
    return payment;
  }

  void clear() {
    _currentOffer = null;
    _financialProfile = null;
    _riskAnalysis = null;
    _negotiationState = null;
    _alternativeOffers = [];
    notifyListeners();
  }
}
