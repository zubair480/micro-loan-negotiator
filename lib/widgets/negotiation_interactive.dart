import 'package:flutter/material.dart';
import '../models/negotiation_state.dart';
import '../utils/helpers.dart';

class NegotiationCounterSlider extends StatelessWidget {
  final NegotiationState state;
  final double value;
  final ValueChanged<double> onChanged;

  const NegotiationCounterSlider({
    super.key,
    required this.state,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Counter Offer',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Center(
              child: Text(
                Helpers.formatRate(value),
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(color: Colors.amber),
              ),
            ),
            const SizedBox(height: 16),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: Colors.amber,
                inactiveTrackColor: Colors.amber.withValues(alpha: 0.2),
                thumbColor: Colors.amber,
              ),
              child: Slider(
                value: value,
                min: state.targetApr,
                max: state.currentApr,
                divisions: 100,
                onChanged: onChanged,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Helpers.formatRate(state.targetApr),
                    style: Theme.of(context).textTheme.bodySmall),
                Text(Helpers.formatRate(state.currentApr),
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NegotiationActionButtons extends StatelessWidget {
  final NegotiationState state;
  final VoidCallback onSubmit;
  final VoidCallback onSuggest;

  const NegotiationActionButtons({
    super.key,
    required this.state,
    required this.onSubmit,
    required this.onSuggest,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onSuggest,
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Suggest Rate'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed:
                state.status == 'max_rounds_reached' ? null : onSubmit,
            icon: const Icon(Icons.send),
            label: const Text('Submit Offer'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}
