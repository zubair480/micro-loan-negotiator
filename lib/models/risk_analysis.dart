class RiskAnalysis {
  final double riskScore;
  final String riskLevel;
  final List<String> riskFactors;
  final List<String> positiveFactors;
  final double defaultProbability;
  final double debtToIncomeRatio;
  final String creditScoreRange;

  RiskAnalysis({
    required this.riskScore,
    required this.riskLevel,
    required this.riskFactors,
    required this.positiveFactors,
    required this.defaultProbability,
    required this.debtToIncomeRatio,
    required this.creditScoreRange,
  });

  factory RiskAnalysis.fromJson(Map<String, dynamic> json) {
    return RiskAnalysis(
      riskScore: (json['risk_score'] as num?)?.toDouble() ?? 0,
      riskLevel: json['risk_level'] as String? ?? 'medium',
      riskFactors: (json['risk_factors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      positiveFactors: (json['positive_factors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      defaultProbability: (json['default_probability'] as num?)?.toDouble() ??
          0,
      debtToIncomeRatio:
          (json['debt_to_income_ratio'] as num?)?.toDouble() ?? 0,
      creditScoreRange: json['credit_score_range'] as String? ?? '600-700',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'risk_score': riskScore,
      'risk_level': riskLevel,
      'risk_factors': riskFactors,
      'positive_factors': positiveFactors,
      'default_probability': defaultProbability,
      'debt_to_income_ratio': debtToIncomeRatio,
      'credit_score_range': creditScoreRange,
    };
  }
}
