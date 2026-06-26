import 'package:flutter/material.dart';
import '../../utils/helpers.dart';

class NegotiationPanel extends StatefulWidget {
  final Map<String, dynamic> props;

  const NegotiationPanel({super.key, required this.props});

  @override
  State<NegotiationPanel> createState() => _NegotiationPanelState();
}

class _NegotiationPanelState extends State<NegotiationPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
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
    final currentApr =
        (widget.props['current_apr'] as num?)?.toDouble() ?? 0;
    final targetApr =
        (widget.props['target_apr'] as num?)?.toDouble() ?? 0;
    final currentPayment =
        (widget.props['current_monthly_payment'] as num?)?.toDouble() ?? 0;
    final targetPayment =
        (widget.props['target_monthly_payment'] as num?)?.toDouble() ?? 0;
    final round = (widget.props['negotiation_round'] as num?)?.toInt() ?? 0;
    final status = (widget.props['status'] as String?) ?? 'ready';
    final offers =
        (widget.props['offers'] as List<dynamic>?) ?? [];

    final savings = currentPayment - targetPayment;

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
                  const Icon(Icons.handshake, color: Colors.amber),
                  const SizedBox(width: 12),
                  Text(
                    'Negotiation Panel',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(status).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status.replaceAll('_', ' ').toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        color: _statusColor(status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _OfferStat(
                      label: 'Current APR',
                      value: Helpers.formatRate(currentApr),
                      color: Colors.red,
                    ),
                  ),
                  const Icon(Icons.arrow_forward, color: Colors.grey),
                  Expanded(
                    child: _OfferStat(
                      label: 'Target APR',
                      value: Helpers.formatRate(targetApr),
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _OfferStat(
                      label: 'Current Payment',
                      value: Helpers.formatCurrency(currentPayment),
                      color: Colors.orange,
                    ),
                  ),
                  const Icon(Icons.arrow_forward, color: Colors.grey),
                  Expanded(
                    child: _OfferStat(
                      label: 'Target Payment',
                      value: Helpers.formatCurrency(targetPayment),
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              if (savings > 0) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.savings, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        'Potential Savings: ${Helpers.formatCurrency(savings)}/mo',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ],
              if (offers.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Offer History',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...offers.map((offer) {
                  final data = offer as Map<String, dynamic>;
                  return ListTile(
                    dense: true,
                    leading: Icon(
                      (data['is_current_offer'] as bool? ?? false)
                          ? Icons.circle
                          : Icons.circle_outlined,
                      color: Colors.amber,
                      size: 16,
                    ),
                    title: Text(data['label'] as String? ?? ''),
                    subtitle: Text(
                      'APR: ${Helpers.formatRate((data['apr'] as num?)?.toDouble() ?? 0)}',
                    ),
                    trailing: Text(
                      Helpers.formatCurrency(
                          (data['monthly_payment'] as num?)?.toDouble() ?? 0),
                    ),
                  );
                }),
              ],
              const SizedBox(height: 16),
              Text(
                'Round $round',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'ready':
        return Colors.blue;
      case 'negotiating':
        return Colors.orange;
      case 'ready_to_accept':
        return Colors.green;
      case 'max_rounds_reached':
        return Colors.red;
      case 'accepted':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class _OfferStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _OfferStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
