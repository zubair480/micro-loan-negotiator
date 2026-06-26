import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/loan_provider.dart';
import '../widgets/offer_widgets.dart';

class OfferDetailsScreen extends StatelessWidget {
  const OfferDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offer Details')),
      body: Consumer<LoanProvider>(
        builder: (context, provider, child) {
          final offer = provider.currentOffer;
          if (offer == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.description_outlined,
                      size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No offer selected'),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OfferHeader(offer: offer),
                const SizedBox(height: 16),
                OfferAmountSection(offer: offer),
                const SizedBox(height: 16),
                OfferBreakdown(offer: offer),
                const SizedBox(height: 16),
                OfferTerms(offer: offer),
                const SizedBox(height: 16),
                buildActionButtons(context, offer),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget buildActionButtons(BuildContext context, _) {
  return Row(
    children: [
      Expanded(
        child: OutlinedButton.icon(
          onPressed: () => Navigator.of(context).pushNamed('/negotiation'),
          icon: const Icon(Icons.handshake),
          label: const Text('Negotiate'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pushNamed('/summary'),
          icon: const Icon(Icons.summarize),
          label: const Text('Summary'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    ],
  );
}
