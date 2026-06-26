class FinancialProfile {
  final double annualIncome;
  final double monthlyExpenses;
  final double existingDebt;
  final double savings;
  final int creditScore;
  final String employmentStatus;
  final int yearsAtCurrentJob;
  final String education;
  final String housingStatus;
  final List<String> financialGoals;

  FinancialProfile({
    required this.annualIncome,
    required this.monthlyExpenses,
    required this.existingDebt,
    required this.savings,
    required this.creditScore,
    required this.employmentStatus,
    required this.yearsAtCurrentJob,
    required this.education,
    required this.housingStatus,
    required this.financialGoals,
  });

  double get debtToIncomeRatio =>
      monthlyExpenses > 0 ? (existingDebt / monthlyExpenses) * 100 : 0;

  double get disposableIncome => annualIncome / 12 - monthlyExpenses;

  factory FinancialProfile.fromJson(Map<String, dynamic> json) {
    return FinancialProfile(
      annualIncome: (json['annual_income'] as num?)?.toDouble() ?? 0,
      monthlyExpenses: (json['monthly_expenses'] as num?)?.toDouble() ?? 0,
      existingDebt: (json['existing_debt'] as num?)?.toDouble() ?? 0,
      savings: (json['savings'] as num?)?.toDouble() ?? 0,
      creditScore: json['credit_score'] as int? ?? 650,
      employmentStatus: json['employment_status'] as String? ?? '',
      yearsAtCurrentJob: json['years_at_current_job'] as int? ?? 0,
      education: json['education'] as String? ?? '',
      housingStatus: json['housing_status'] as String? ?? '',
      financialGoals: (json['financial_goals'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'annual_income': annualIncome,
      'monthly_expenses': monthlyExpenses,
      'existing_debt': existingDebt,
      'savings': savings,
      'credit_score': creditScore,
      'employment_status': employmentStatus,
      'years_at_current_job': yearsAtCurrentJob,
      'education': education,
      'housing_status': housingStatus,
      'financial_goals': financialGoals,
    };
  }
}
