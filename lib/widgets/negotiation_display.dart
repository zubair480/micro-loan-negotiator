import 'package:flutter/material.dart';
import '../models/negotiation_state.dart';
import '../utils/helpers.dart';

class NegotiationStatusBanner extends StatelessWidget {
  final NegotiationState state;
  const NegotiationStatusBanner({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(state.status);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(_statusIcon(state.status), color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_statusTitle(state.status),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: color)),
                  Text(_statusDesc(state.status),
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Round ${state.negotiationRound}',
                  style: TextStyle(
                      fontSize: 12, color: color, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String s) => switch (s) {
        'ready' => Colors.blue,
        'negotiating' => Colors.orange,
        'ready_to_accept' => Colors.green,
        'max_rounds_reached' => Colors.red,
        _ => Colors.grey,
      };
  IconData _statusIcon(String s) => switch (s) {
        'ready' => Icons.info,
        'negotiating' => Icons.swap_horiz,
        'ready_to_accept' => Icons.check_circle,
        _ => Icons.error,
      };
  String _statusTitle(String s) => switch (s) {
        'ready' => 'Ready to Negotiate',
        'negotiating' => 'Negotiation in Progress',
        'ready_to_accept' => 'Ready to Accept',
        'max_rounds_reached' => 'Max Rounds Reached',
        _ => s,
      };
  String _statusDesc(String s) => switch (s) {
        'ready' => 'Set your target APR and submit your first counter offer',
        'negotiating' => 'Your offer is being considered',
        'ready_to_accept' => 'Consider accepting the current offer',
        'max_rounds_reached' => 'Maximum negotiation rounds reached',
        _ => '',
      };
}

class NegotiationAprComparison extends StatelessWidget {
  final NegotiationState state;
  const NegotiationAprComparison({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final totalGap = state.currentApr - state.targetApr;
    final progress = totalGap <= 0 ? 1.0 : 0.0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Column(children: [
                Text('Current APR',
                    style: Theme.of(context).textTheme.bodySmall),
                Text(Helpers.formatRate(state.currentApr),
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(color: Colors.red)),
              ]),
              const Icon(Icons.arrow_forward, color: Colors.grey, size: 28),
              Column(children: [
                Text('Target APR',
                    style: Theme.of(context).textTheme.bodySmall),
                Text(Helpers.formatRate(state.targetApr),
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(color: Colors.green)),
              ]),
            ]),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation(
                    progress > 0.7 ? Colors.green : Colors.orange),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NegotiationSavingsHighlight extends StatelessWidget {
  final NegotiationState state;
  const NegotiationSavingsHighlight({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final savings = state.currentMonthlyPayment - state.targetMonthlyPayment;
    if (savings <= 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.green.withValues(alpha: 0.15),
          Colors.green.withValues(alpha: 0.05),
        ]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.savings, color: Colors.green),
        const SizedBox(width: 8),
        Text('Potential Monthly Savings: ',
            style: Theme.of(context).textTheme.titleMedium),
        Text(Helpers.formatCurrency(savings),
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.green)),
      ]),
    );
  }
}

class NegotiationOfferHistory extends StatelessWidget {
  final NegotiationState state;
  const NegotiationOfferHistory({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.offers.isEmpty) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Offer History',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...state.offers.map((offer) => ListTile(
                  dense: true,
                  leading: Icon(
                      offer.isCurrentOffer
                          ? Icons.circle
                          : Icons.circle_outlined,
                      color: offer.isCurrentOffer ? Colors.amber : Colors.grey,
                      size: 12),
                  title: Text(offer.label),
                  subtitle:
                      Text('APR: ${Helpers.formatRate(offer.apr)}'),
                  trailing: Text(
                    Helpers.formatCurrency(offer.monthlyPayment),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: offer.isCurrentOffer ? Colors.amber : null),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class NegotiationSuggestions extends StatelessWidget {
  final NegotiationState state;
  const NegotiationSuggestions({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.suggestions.isEmpty) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Suggestions',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...state.suggestions.map((s) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Icon(Icons.lightbulb_outline,
                        size: 16, color: Colors.amber),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(s,
                            style: Theme.of(context).textTheme.bodyMedium)),
                  ]),
                )),
          ],
        ),
      ),
    );
  }
}
