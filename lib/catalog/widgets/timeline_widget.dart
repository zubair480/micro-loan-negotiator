import 'package:flutter/material.dart';
import '../../utils/helpers.dart';

class TimelineWidget extends StatefulWidget {
  final Map<String, dynamic> props;

  const TimelineWidget({super.key, required this.props});

  @override
  State<TimelineWidget> createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
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
    final milestones =
        (widget.props['milestones'] as List<dynamic>?)
            ?.map((e) => Map<String, dynamic>.from(e as Map))
            .toList() ??
        _defaultMilestones();
    final currentYear =
        (widget.props['current_year'] as num?)?.toInt() ?? 1;

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
                  const Icon(Icons.timeline, color: Colors.blue),
                  const SizedBox(width: 12),
                  Text(
                    'Payment Timeline',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...List.generate(milestones.length, (index) {
                final milestone = milestones[index];
                final year = milestone['year'] as int? ?? index + 1;
                final label = milestone['label'] as String? ?? '';
                final amount =
                    (milestone['amount'] as num?)?.toDouble() ?? 0;
                final isActive = year <= currentYear;
                final isCurrent = year == currentYear;

                return _TimelineEntry(
                  year: year,
                  label: label,
                  amount: amount,
                  isActive: isActive,
                  isCurrent: isCurrent,
                  isLast: index == milestones.length - 1,
                  animationValue: (index + 1) / milestones.length,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _defaultMilestones() {
    return [
      {'year': 1, 'label': 'First Payment', 'amount': 5000},
      {'year': 5, 'label': '20% Equity', 'amount': 12000},
      {'year': 10, 'label': '40% Paid', 'amount': 25000},
      {'year': 20, 'label': '75% Paid', 'amount': 45000},
      {'year': 30, 'label': 'Loan Paid Off', 'amount': 60000},
    ];
  }
}

class _TimelineEntry extends StatelessWidget {
  final int year;
  final String label;
  final double amount;
  final bool isActive;
  final bool isCurrent;
  final bool isLast;
  final double animationValue;

  const _TimelineEntry({
    required this.year,
    required this.label,
    required this.amount,
    required this.isActive,
    required this.isCurrent,
    required this.isLast,
    required this.animationValue,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: isCurrent ? 20 : 14,
                  height: isCurrent ? 20 : 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? (isCurrent ? Colors.blue : Colors.green)
                        : Colors.grey.withValues(alpha: 0.3),
                    border: isCurrent
                        ? Border.all(color: Colors.white, width: 3)
                        : null,
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: Colors.blue.withValues(alpha: 0.4),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isActive
                          ? Colors.green.withValues(alpha: 0.4)
                          : Colors.grey.withValues(alpha: 0.2),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Year $year',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: isActive ? Colors.green : Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    Helpers.formatCurrency(amount * (isActive ? 1 : 0)),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isActive ? null : Colors.grey,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
