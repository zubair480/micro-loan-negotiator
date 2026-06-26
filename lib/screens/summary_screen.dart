import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/conversation_provider.dart';
import '../providers/loan_provider.dart';
import '../providers/generated_ui_provider.dart';
import '../widgets/summary_widgets.dart';
import '../utils/helpers.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _startOver(context),
            tooltip: 'Start Over',
          ),
        ],
      ),
      body: Consumer<LoanProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SummaryHeader(),
                const SizedBox(height: 16),
                if (provider.currentOffer != null)
                  _offerSummary(provider.currentOffer!),
                if (provider.financialProfile != null) ...[
                  const SizedBox(height: 16),
                  _profileSummary(provider.financialProfile!),
                ],
                if (provider.riskAnalysis != null) ...[
                  const SizedBox(height: 16),
                  SummaryRiskBadge(
                    riskLevel: provider.riskAnalysis!.riskLevel,
                    riskScore: provider.riskAnalysis!.riskScore,
                  ),
                ],
                if (provider.negotiationState != null) ...[
                  const SizedBox(height: 16),
                  _negotiationSummary(provider.negotiationState!),
                ],
                const SizedBox(height: 16),
                SummaryNextSteps(
                  screenContext: context,
                  onStartOver: () => _startOver(context),
                ),
                const SizedBox(height: 32),
                _footer(context),
              ],
            ),
          );
        },
      ),
    );
  }

  void _startOver(BuildContext context) {
    context.read<ConversationProvider>().clear();
    context.read<LoanProvider>().clear();
    context.read<GeneratedUIProvider>().clear();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }
}

Widget _offerSummary(dynamic offer) {
  return SummaryCard(
    icon: Icons.description,
    iconColor: Colors.blue,
    title: 'Loan Offer',
    rows: [
      SummaryRow(label: 'Lender', value: offer.lenderName),
      SummaryRow(
          label: 'Loan Amount',
          value: Helpers.formatCurrency(offer.loanAmount)),
      SummaryRow(label: 'APR', value: Helpers.formatRate(offer.apr)),
      SummaryRow(
          label: 'Monthly Payment',
          value: Helpers.formatCurrency(offer.monthlyPayment)),
      SummaryRow(
          label: 'Total Cost',
          value: Helpers.formatCurrency(offer.totalCost)),
    ],
  );
}

Widget _profileSummary(dynamic profile) {
  return SummaryCard(
    icon: Icons.person,
    iconColor: Colors.teal,
    title: 'Financial Profile',
    rows: [
      SummaryRow(
          label: 'Annual Income',
          value: Helpers.formatCurrency(profile.annualIncome)),
      SummaryRow(label: 'Credit Score', value: profile.creditScore.toString()),
      SummaryRow(label: 'Employment', value: profile.employmentStatus),
      SummaryRow(
          label: 'Debt-to-Income',
          value: '${profile.debtToIncomeRatio.toStringAsFixed(1)}%'),
    ],
  );
}

Widget _negotiationSummary(dynamic state) {
  return SummaryCard(
    icon: Icons.handshake,
    iconColor: Colors.amber,
    title: 'Negotiation Result',
    rows: [
      SummaryRow(
          label: 'Final APR',
          value: Helpers.formatRate(state.currentApr)),
      SummaryRow(
          label: 'Monthly Payment',
          value: Helpers.formatCurrency(state.currentMonthlyPayment)),
      SummaryRow(label: 'Rounds', value: '${state.negotiationRound}'),
    ],
  );
}

Widget _footer(BuildContext context) {
  return Center(
    child: Column(
      children: [
        Text(
          'Powered by Negotia AI',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          'Every borrower deserves a loan interface designed specifically for them.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[700],
                fontSize: 11,
              ),
        ),
      ],
    ),
  );
}
