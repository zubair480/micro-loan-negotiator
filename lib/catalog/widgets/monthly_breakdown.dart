import 'package:flutter/material.dart';
import '../../utils/helpers.dart';

class MonthlyBreakdown extends StatefulWidget {
  final Map<String, dynamic> props;

  const MonthlyBreakdown({super.key, required this.props});

  @override
  State<MonthlyBreakdown> createState() => _MonthlyBreakdownState();
}

class _MonthlyBreakdownState extends State<MonthlyBreakdown>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final principal =
        (widget.props['principal_payment'] as num?)?.toDouble() ?? 0;
    final interest =
        (widget.props['interest_payment'] as num?)?.toDouble() ?? 0;
    final taxes =
        (widget.props['taxes'] as num?)?.toDouble() ?? 0;
    final insurance =
        (widget.props['insurance'] as num?)?.toDouble() ?? 0;
    final remainingBalance =
        (widget.props['remaining_balance'] as num?)?.toDouble() ?? 0;
    final month = (widget.props['month'] as num?)?.toInt() ?? 1;
    final totalMonths =
        (widget.props['total_months'] as num?)?.toInt() ?? 360;

    final totalMonthly = principal + interest + taxes + insurance;
    final principalPercent = principal / totalMonthly;
    final interestPercent = interest / totalMonthly;
    final taxesPercent = taxes / totalMonthly;
    final insurancePercent = insurance / totalMonthly;

    return FadeTransition(
      opacity: _controller,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_month, color: Colors.teal),
                  const SizedBox(width: 12),
                  Text(
                    'Monthly Breakdown',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Payment $month of $totalMonths',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 24,
                  child: Row(
                    children: [
                      Expanded(
                        flex: (principalPercent * 100).round(),
                        child: Container(
                          color: Colors.green,
                          child: const Center(
                            child: Text('P', style: TextStyle(fontSize: 11)),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: (interestPercent * 100).round(),
                        child: Container(
                          color: Colors.orange,
                          child: const Center(
                            child: Text('I', style: TextStyle(fontSize: 11)),
                          ),
                        ),
                      ),
                      if (taxes > 0)
                        Expanded(
                          flex: (taxesPercent * 100).round(),
                          child: Container(
                            color: Colors.red,
                            child: const Center(
                              child: Text('T', style: TextStyle(fontSize: 11)),
                            ),
                          ),
                        ),
                      if (insurance > 0)
                        Expanded(
                          flex: (insurancePercent * 100).round(),
                          child: Container(
                            color: Colors.blue,
                            child: const Center(
                              child: Text('Ins',
                                  style: TextStyle(fontSize: 11)),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _BreakdownRow(
                label: 'Principal',
                amount: principal,
                color: Colors.green,
              ),
              _BreakdownRow(
                label: 'Interest',
                amount: interest,
                color: Colors.orange,
              ),
              if (taxes > 0)
                _BreakdownRow(
                  label: 'Taxes',
                  amount: taxes,
                  color: Colors.red,
                ),
              if (insurance > 0)
                _BreakdownRow(
                  label: 'Insurance',
                  amount: insurance,
                  color: Colors.blue,
                ),
              const Divider(height: 24),
              _BreakdownRow(
                label: 'Total Monthly',
                amount: totalMonthly,
                color: Colors.white,
                bold: true,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Remaining Balance',
                      style: Theme.of(context).textTheme.bodyMedium),
                  Text(
                    Helpers.formatCurrency(remainingBalance),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.teal,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final bool bold;

  const _BreakdownRow({
    required this.label,
    required this.amount,
    required this.color,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: bold
                    ? Theme.of(context).textTheme.titleMedium
                    : Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          Text(
            Helpers.formatCurrency(amount),
            style: bold
                ? Theme.of(context).textTheme.titleMedium
                : Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
