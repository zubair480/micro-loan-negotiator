import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/loan_provider.dart';
import '../services/negotiation_service.dart';
import '../widgets/negotiation_display.dart';
import '../widgets/negotiation_interactive.dart';

class NegotiationScreen extends StatefulWidget {
  const NegotiationScreen({super.key});

  @override
  State<NegotiationScreen> createState() => _NegotiationScreenState();
}

class _NegotiationScreenState extends State<NegotiationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _negotiationService = NegotiationService();
  double _customApr = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _controller.forward();
    _initializeNegotiation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initializeNegotiation() {
    final loanProvider = context.read<LoanProvider>();
    final offer = loanProvider.currentOffer;
    final profile = loanProvider.financialProfile;
    if (offer != null && profile != null) {
      final state =
          _negotiationService.initializeNegotiation(offer: offer, profile: profile);
      loanProvider.setNegotiationState(state);
      _customApr = state.currentApr;
    }
  }

  void _submitCounter() {
    final loanProvider = context.read<LoanProvider>();
    final state = loanProvider.negotiationState;
    final offer = loanProvider.currentOffer;
    if (state != null && offer != null) {
      final newState = _negotiationService.processCounter(
        state: state,
        counterApr: _customApr,
        offer: offer,
      );
      loanProvider.setNegotiationState(newState);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Negotiate Your Loan')),
      body: Consumer<LoanProvider>(
        builder: (context, provider, child) {
          final state = provider.negotiationState;
          if (state == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.handshake, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No loan to negotiate'),
                ],
              ),
            );
          }
          return FadeTransition(
            opacity: _controller,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NegotiationStatusBanner(state: state),
                  const SizedBox(height: 16),
                  NegotiationAprComparison(state: state),
                  const SizedBox(height: 16),
                  NegotiationSavingsHighlight(state: state),
                  const SizedBox(height: 16),
                  NegotiationCounterSlider(
                    state: state,
                    value: _customApr,
                    onChanged: (v) => setState(() => _customApr = v),
                  ),
                  const SizedBox(height: 16),
                  NegotiationOfferHistory(state: state),
                  const SizedBox(height: 16),
                  NegotiationSuggestions(state: state),
                  const SizedBox(height: 16),
                  NegotiationActionButtons(
                    state: state,
                    onSubmit: _submitCounter,
                    onSuggest: () {
                      final profile =
                          context.read<LoanProvider>().financialProfile;
                      if (profile != null) {
                        final suggested =
                            _negotiationService.suggestCounterApr(
                                state, profile);
                        setState(() => _customApr = suggested);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
