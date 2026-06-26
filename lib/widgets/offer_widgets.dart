import 'package:flutter/material.dart';
import '../models/loan_offer.dart';
import '../utils/helpers.dart';

class OfferHeader extends StatelessWidget {
  final LoanOffer offer;
  const OfferHeader({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.account_balance, color: Colors.green),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(offer.lenderName,
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _Badge(
                        label: offer.loanType,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      if (offer.isFixedRate)
                        const _Badge(label: 'Fixed Rate', color: Colors.blue),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: color),
      ),
    );
  }
}

class OfferAmountSection extends StatelessWidget {
  final LoanOffer offer;
  const OfferAmountSection({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Loan Amount',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(
              Helpers.formatCurrency(offer.loanAmount),
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: Colors.green),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatItem(
                  label: 'APR',
                  value: Helpers.formatRate(offer.apr),
                  color: Colors.orange,
                ),
                StatItem(
                  label: 'Monthly',
                  value: Helpers.formatCurrency(offer.monthlyPayment),
                  color: Colors.blue,
                ),
                StatItem(
                  label: 'Term',
                  value: Helpers.formatTerm(offer.termMonths),
                  color: Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const StatItem({
    super.key,
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

class OfferBreakdown extends StatelessWidget {
  final LoanOffer offer;
  const OfferBreakdown({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cost Breakdown',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            _Row(
              label: 'Total Interest',
              amount: offer.totalInterest,
              color: Colors.orange,
            ),
            const SizedBox(height: 8),
            _Row(
              label: 'Origination Fee',
              amount: offer.originationFee,
              color: Colors.red,
            ),
            const Divider(height: 24),
            _Row(
              label: 'Total Cost',
              amount: offer.totalCost,
              color: Colors.white,
              bold: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final bool bold;
  const _Row({
    required this.label,
    required this.amount,
    required this.color,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: bold
                ? Theme.of(context).textTheme.titleMedium
                : Theme.of(context).textTheme.bodyMedium),
        Text(
          Helpers.formatCurrency(amount),
          style: (bold
                  ? Theme.of(context).textTheme.titleMedium
                  : Theme.of(context).textTheme.bodyLarge)
              ?.copyWith(color: color),
        ),
      ],
    );
  }
}

class OfferTerms extends StatelessWidget {
  final LoanOffer offer;
  const OfferTerms({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Terms', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TermRow(label: 'Loan Type', value: offer.loanType),
            TermRow(
              label: 'Rate Type',
              value: offer.isFixedRate ? 'Fixed' : 'Variable',
            ),
            TermRow(
              label: 'Term',
              value: Helpers.formatTerm(offer.termMonths),
            ),
            TermRow(
              label: 'APR',
              value: Helpers.formatRate(offer.apr),
            ),
          ],
        ),
      ),
    );
  }
}

class TermRow extends StatelessWidget {
  final String label;
  final String value;
  const TermRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
