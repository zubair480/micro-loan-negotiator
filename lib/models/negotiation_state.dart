class NegotiationState {
  final double currentApr;
  final double targetApr;
  final double currentMonthlyPayment;
  final double targetMonthlyPayment;
  final int negotiationRound;
  final String status;
  final List<NegotiationOffer> offers;
  final List<String> suggestions;

  NegotiationState({
    required this.currentApr,
    required this.targetApr,
    required this.currentMonthlyPayment,
    required this.targetMonthlyPayment,
    required this.negotiationRound,
    required this.status,
    required this.offers,
    required this.suggestions,
  });

  double get aprReduction => currentApr - targetApr;

  double get monthlySavings => currentMonthlyPayment - targetMonthlyPayment;

  factory NegotiationState.fromJson(Map<String, dynamic> json) {
    return NegotiationState(
      currentApr: (json['current_apr'] as num?)?.toDouble() ?? 0,
      targetApr: (json['target_apr'] as num?)?.toDouble() ?? 0,
      currentMonthlyPayment:
          (json['current_monthly_payment'] as num?)?.toDouble() ?? 0,
      targetMonthlyPayment:
          (json['target_monthly_payment'] as num?)?.toDouble() ?? 0,
      negotiationRound: json['negotiation_round'] as int? ?? 0,
      status: json['status'] as String? ?? 'pending',
      offers: (json['offers'] as List<dynamic>?)
              ?.map((e) =>
                  NegotiationOffer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      suggestions: (json['suggestions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_apr': currentApr,
      'target_apr': targetApr,
      'current_monthly_payment': currentMonthlyPayment,
      'target_monthly_payment': targetMonthlyPayment,
      'negotiation_round': negotiationRound,
      'status': status,
      'offers': offers.map((o) => o.toJson()).toList(),
      'suggestions': suggestions,
    };
  }
}

class NegotiationOffer {
  final String id;
  final String label;
  final double apr;
  final double monthlyPayment;
  final double totalCost;
  final bool isCurrentOffer;

  NegotiationOffer({
    required this.id,
    required this.label,
    required this.apr,
    required this.monthlyPayment,
    required this.totalCost,
    required this.isCurrentOffer,
  });

  factory NegotiationOffer.fromJson(Map<String, dynamic> json) {
    return NegotiationOffer(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? '',
      apr: (json['apr'] as num?)?.toDouble() ?? 0,
      monthlyPayment: (json['monthly_payment'] as num?)?.toDouble() ?? 0,
      totalCost: (json['total_cost'] as num?)?.toDouble() ?? 0,
      isCurrentOffer: json['is_current_offer'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'apr': apr,
      'monthly_payment': monthlyPayment,
      'total_cost': totalCost,
      'is_current_offer': isCurrentOffer,
    };
  }
}
