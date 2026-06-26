class LoanOffer {
  final String id;
  final String lenderName;
  final double loanAmount;
  final double apr;
  final double monthlyPayment;
  final int termMonths;
  final double originationFee;
  final double totalInterest;
  final double totalCost;
  final String loanType;
  final bool isFixedRate;

  LoanOffer({
    required this.id,
    required this.lenderName,
    required this.loanAmount,
    required this.apr,
    required this.monthlyPayment,
    required this.termMonths,
    required this.originationFee,
    required this.totalInterest,
    required this.totalCost,
    required this.loanType,
    required this.isFixedRate,
  });

  factory LoanOffer.fromJson(Map<String, dynamic> json) {
    return LoanOffer(
      id: json['id'] as String? ?? '',
      lenderName: json['lender_name'] as String? ?? '',
      loanAmount: (json['loan_amount'] as num?)?.toDouble() ?? 0,
      apr: (json['apr'] as num?)?.toDouble() ?? 0,
      monthlyPayment: (json['monthly_payment'] as num?)?.toDouble() ?? 0,
      termMonths: json['term_months'] as int? ?? 0,
      originationFee: (json['origination_fee'] as num?)?.toDouble() ?? 0,
      totalInterest: (json['total_interest'] as num?)?.toDouble() ?? 0,
      totalCost: (json['total_cost'] as num?)?.toDouble() ?? 0,
      loanType: json['loan_type'] as String? ?? '',
      isFixedRate: json['is_fixed_rate'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lender_name': lenderName,
      'loan_amount': loanAmount,
      'apr': apr,
      'monthly_payment': monthlyPayment,
      'term_months': termMonths,
      'origination_fee': originationFee,
      'total_interest': totalInterest,
      'total_cost': totalCost,
      'loan_type': loanType,
      'is_fixed_rate': isFixedRate,
    };
  }
}
