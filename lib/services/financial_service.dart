import 'dart:math';
import '../models/loan_offer.dart';
import '../models/financial_profile.dart';
import '../models/risk_analysis.dart';

class FinancialService {
  RiskAnalysis analyzeRisk({
    required FinancialProfile profile,
    required LoanOffer offer,
  }) {
    final dti = profile.monthlyExpenses > 0
        ? (offer.monthlyPayment / profile.monthlyExpenses) * 100
        : 0.0;

    final factors = <String>[];
    final positiveFactors = <String>[];

    if (dti > 40) {
      factors.add('Debt-to-income ratio exceeds 40%');
    } else if (dti > 30) {
      factors.add('Debt-to-income ratio is elevated');
    } else {
      positiveFactors.add('Healthy debt-to-income ratio');
    }

    if (profile.creditScore < 600) {
      factors.add('Credit score below 600');
    } else if (profile.creditScore < 700) {
      factors.add('Credit score could be improved');
    } else if (profile.creditScore >= 720) {
      positiveFactors.add('Excellent credit score');
    } else {
      positiveFactors.add('Good credit score');
    }

    if (profile.savings < offer.loanAmount * 0.1) {
      factors.add('Limited savings relative to loan amount');
    } else {
      positiveFactors.add('Adequate savings reserve');
    }

    if (profile.yearsAtCurrentJob < 2) {
      factors.add('Short employment tenure');
    } else {
      positiveFactors.add('Stable employment history');
    }

    if (profile.existingDebt > profile.annualIncome * 0.5) {
      factors.add('High existing debt load');
    } else {
      positiveFactors.add('Manageable existing debt');
    }

    final defaultProb = _calculateDefaultProbability(
      profile.creditScore,
      dti,
      profile.savings,
      offer.loanAmount,
    );

    final riskScore = _calculateRiskScore(factors.length, profile.creditScore);
    final riskLevel = _determineRiskLevel(riskScore);

    return RiskAnalysis(
      riskScore: riskScore,
      riskLevel: riskLevel,
      riskFactors: factors,
      positiveFactors: positiveFactors,
      defaultProbability: defaultProb,
      debtToIncomeRatio: dti,
      creditScoreRange: _creditScoreRange(profile.creditScore),
    );
  }

  double _calculateDefaultProbability(
    int creditScore,
    double dti,
    double savings,
    double loanAmount,
  ) {
    final scoreContribution = max(0, (800 - creditScore) / 800) * 0.3;
    final dtiContribution = min(1, dti / 50) * 0.3;
    final savingsContribution =
        savings > 0 ? max(0, 1 - (savings / loanAmount)) * 0.2 : 0.2;
    final baseRate = 0.02;
    return double.parse(
      ((scoreContribution + dtiContribution + savingsContribution + baseRate) *
              100)
          .toStringAsFixed(1),
    );
  }

  double _calculateRiskScore(int riskFactorCount, int creditScore) {
    final baseScore = 70.0;
    final factorPenalty = riskFactorCount * 8.0;
    final creditBonus = ((creditScore - 500) / 300) * 15;
    final finalScore = baseScore - factorPenalty + creditBonus;
    return double.parse(finalScore.clamp(0, 100).toStringAsFixed(0));
  }

  String _determineRiskLevel(double score) {
    if (score >= 70) return 'low';
    if (score >= 40) return 'medium';
    return 'high';
  }

  String _creditScoreRange(int score) {
    if (score >= 800) return '800-850';
    if (score >= 740) return '740-799';
    if (score >= 670) return '670-739';
    if (score >= 580) return '580-669';
    return '300-579';
  }

  double calculateMonthlyPayment(double principal, double annualRate, int termMonths) {
    final monthlyRate = annualRate / 12 / 100;
    if (monthlyRate == 0) return principal / termMonths;
    final factor = (1 + monthlyRate).toDouble();
    return principal *
        (monthlyRate * pow(factor, termMonths).toDouble()) /
        (pow(factor, termMonths).toDouble() - 1);
  }

  List<double> generateAmortizationSchedule({
    required double principal,
    required double annualRate,
    required int termMonths,
  }) {
    final monthlyRate = annualRate / 12 / 100;
    final monthlyPayment = calculateMonthlyPayment(
      principal,
      annualRate,
      termMonths,
    );
    final schedule = <double>[];
    var balance = principal;
    for (int i = 0; i < termMonths && balance > 0; i++) {
      final interest = balance * monthlyRate;
      final principalPaid = monthlyPayment - interest;
      balance -= principalPaid;
      schedule.add(balance > 0 ? balance : 0);
    }
    return schedule;
  }
}
