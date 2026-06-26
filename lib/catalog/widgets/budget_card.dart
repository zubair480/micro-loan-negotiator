import 'package:flutter/material.dart';
import '../../utils/helpers.dart';

class BudgetCard extends StatefulWidget {
  final Map<String, dynamic> props;

  const BudgetCard({super.key, required this.props});

  @override
  State<BudgetCard> createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard>
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
    final income = (widget.props['monthly_income'] as num?)?.toDouble() ?? 0;
    final expenses =
        (widget.props['monthly_expenses'] as num?)?.toDouble() ?? 0;
    final savings = (widget.props['monthly_savings'] as num?)?.toDouble() ?? 0;
    final rent = (widget.props['rent'] as num?)?.toDouble();
    final food = (widget.props['food'] as num?)?.toDouble();
    final transport = (widget.props['transport'] as num?)?.toDouble();
    final utilities = (widget.props['utilities'] as num?)?.toDouble();

    final categories = <String, double>{};
    if (rent != null) categories['Housing'] = rent;
    if (food != null) categories['Food'] = food;
    if (transport != null) categories['Transport'] = transport;
    if (utilities != null) categories['Utilities'] = utilities;

    final available = income - expenses;

    return SizeTransition(
      sizeFactor: _controller,
      axisAlignment: -1,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.account_balance_wallet,
                      color: Colors.teal),
                  const SizedBox(width: 12),
                  Text(
                    'Budget Overview',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _BudgetRow(
                label: 'Monthly Income',
                amount: income,
                color: Colors.green,
              ),
              const SizedBox(height: 8),
              _BudgetRow(
                label: 'Monthly Expenses',
                amount: expenses,
                color: Colors.orange,
              ),
              if (savings > 0) ...[
                const SizedBox(height: 8),
                _BudgetRow(
                  label: 'Monthly Savings',
                  amount: savings,
                  color: Colors.blue,
                ),
              ],
              const Divider(height: 24),
              Text(
                'Disposable Income',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                Helpers.formatCurrency(available),
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: available > 0 ? Colors.green : Colors.red,
                    ),
              ),
              if (categories.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Expense Breakdown',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...categories.entries.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.key,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium),
                              Text(
                                Helpers.formatCurrency(e.value),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: e.value / expenses,
                              backgroundColor:
                                  Colors.grey.withValues(alpha: 0.2),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
              const SizedBox(height: 12),
              _AffordabilityIndicator(
                dtiRatio: expenses / income,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BudgetRow extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const _BudgetRow({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        Text(
          Helpers.formatCurrency(amount),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class _AffordabilityIndicator extends StatelessWidget {
  final double dtiRatio;

  const _AffordabilityIndicator({required this.dtiRatio});

  @override
  Widget build(BuildContext context) {
    final color = dtiRatio < 0.36
        ? Colors.green
        : dtiRatio < 0.43
            ? Colors.orange
            : Colors.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Debt-to-Income Ratio',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '${(dtiRatio * 100).toStringAsFixed(1)}%',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: color),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: dtiRatio.clamp(0, 0.6) / 0.6,
            backgroundColor: Colors.grey.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          dtiRatio < 0.36
              ? 'Healthy ratio'
              : dtiRatio < 0.43
                  ? 'Moderate ratio'
                  : 'High ratio - consider reducing debt',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: color),
        ),
      ],
    );
  }
}
