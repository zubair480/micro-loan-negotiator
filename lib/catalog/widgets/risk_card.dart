import 'package:flutter/material.dart';

class RiskCard extends StatefulWidget {
  final Map<String, dynamic> props;

  const RiskCard({super.key, required this.props});

  @override
  State<RiskCard> createState() => _RiskCardState();
}

class _RiskCardState extends State<RiskCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
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
    final score = (widget.props['risk_score'] as num?)?.toDouble() ?? 0;
    final level = (widget.props['risk_level'] as String?) ?? 'medium';
    final factors =
        (widget.props['risk_factors'] as List<dynamic>?)?.cast<String>() ?? [];
    final positiveFactors =
        (widget.props['positive_factors'] as List<dynamic>?)?.cast<String>() ??
            [];
    final defaultProb =
        (widget.props['default_probability'] as num?)?.toDouble() ?? 0;

    final color = level == 'low'
        ? Colors.green
        : level == 'medium'
            ? Colors.orange
            : Colors.red;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.shield_outlined, color: color, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'Risk Analysis',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 140,
                  height: 140,
                  child: _RiskGauge(score: score, color: color),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  '${score.toStringAsFixed(0)}/100',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: color,
                      ),
                ),
              ),
              Center(
                child: Text(
                  '${level.toUpperCase()} RISK',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: color,
                        letterSpacing: 2,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              if (defaultProb > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Default Probability: ${defaultProb.toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              if (positiveFactors.isNotEmpty) ...[
                const SizedBox(height: 8),
                ...positiveFactors.map((f) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: Colors.green, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(f,
                                style: Theme.of(context).textTheme.bodyMedium),
                          ),
                        ],
                      ),
                    )),
              ],
              if (factors.isNotEmpty) ...[
                const SizedBox(height: 8),
                ...factors.map((f) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber,
                              color: Colors.orange[700], size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(f,
                                style: Theme.of(context).textTheme.bodyMedium),
                          ),
                        ],
                      ),
                    )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _RiskGauge extends StatelessWidget {
  final double score;
  final Color color;

  const _RiskGauge({required this.score, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GaugePainter(score: score, color: color),
      child: const SizedBox.expand(),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double score;
  final Color color;

  _GaugePainter({required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    final backgroundPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;

    canvas.drawCircle(center, radius, backgroundPaint);

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (score / 100) * 2 * 3.14159;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      sweepAngle,
      false,
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.score != score || oldDelegate.color != color;
  }
}
