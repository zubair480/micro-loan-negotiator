import 'package:flutter/material.dart';
import '../../utils/helpers.dart';

class TradeoffSlider extends StatefulWidget {
  final Map<String, dynamic> props;

  const TradeoffSlider({super.key, required this.props});

  @override
  State<TradeoffSlider> createState() => _TradeoffSliderState();
}

class _TradeoffSliderState extends State<TradeoffSlider> {
  double _sliderValue = 0.5;

  @override
  Widget build(BuildContext context) {
    final labelA = (widget.props['option_a_label'] as String?) ?? 'Lower Payment';
    final labelB =
        (widget.props['option_b_label'] as String?) ?? 'Shorter Term';
    final valueA =
        (widget.props['option_a_value'] as num?)?.toDouble() ?? 1200;
    final valueB =
        (widget.props['option_b_value'] as num?)?.toDouble() ?? 1800;
    final termA = (widget.props['option_a_term'] as num?)?.toInt() ?? 30;
    final termB = (widget.props['option_b_term'] as num?)?.toInt() ?? 15;

    final t = _sliderValue;
    final currentPayment = valueA + (valueB - valueA) * t;
    final currentTerm = (termA + (termB - termA) * t).round();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.swap_horiz, color: Colors.purple),
                const SizedBox(width: 12),
                Text(
                  'Trade-off Analysis',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(labelA,
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 4),
                      Text(
                        Helpers.formatCurrency(valueA),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.green),
                      ),
                      Text('${termA}yr term',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(labelB,
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 4),
                      Text(
                        Helpers.formatCurrency(valueB),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.orange),
                      ),
                      Text('${termB}yr term',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: Colors.purple,
                inactiveTrackColor: Colors.purple.withValues(alpha: 0.2),
                thumbColor: Colors.purple,
                overlayColor: Colors.purple.withValues(alpha: 0.12),
                trackHeight: 6,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 10),
              ),
              child: Slider(
                value: _sliderValue,
                onChanged: (v) => setState(() => _sliderValue = v),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.withValues(alpha: 0.1),
                    Colors.purple.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('Monthly',
                          style: Theme.of(context).textTheme.bodySmall),
                      Text(
                        Helpers.formatCurrency(currentPayment),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    width: 1, height: 30, color: Colors.grey.withValues(alpha: 0.3),
                  ),
                  Column(
                    children: [
                      Text('Term',
                          style: Theme.of(context).textTheme.bodySmall),
                      Text(
                        '$currentTerm years',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    width: 1, height: 30, color: Colors.grey.withValues(alpha: 0.3),
                  ),
                  Column(
                    children: [
                      Text('Total',
                          style: Theme.of(context).textTheme.bodySmall),
                      Text(
                        Helpers.formatCurrency(currentPayment * currentTerm * 12),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
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
