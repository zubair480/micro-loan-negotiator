import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LoanChart extends StatefulWidget {
  final Map<String, dynamic> props;

  const LoanChart({super.key, required this.props});

  @override
  State<LoanChart> createState() => _LoanChartState();
}

class _LoanChartState extends State<LoanChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chartType =
        (widget.props['chart_type'] as String?) ?? 'apr_comparison';

    return FadeTransition(
      opacity: _animation,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.bar_chart, color: Colors.green),
                  const SizedBox(width: 12),
                  Text(
                    _chartTitle(chartType),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 220,
                child: _buildChart(chartType),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _chartTitle(String type) {
    switch (type) {
      case 'apr_comparison':
        return 'APR Comparison';
      case 'payment_breakdown':
        return 'Payment Breakdown';
      case 'interest_over_time':
        return 'Interest Over Time';
      default:
        return 'Loan Analysis';
    }
  }

  Widget _buildChart(String type) {
    switch (type) {
      case 'apr_comparison':
        return _buildAPRComparison();
      case 'payment_breakdown':
        return _buildPaymentBreakdown();
      case 'interest_over_time':
        return _buildInterestOverTime();
      default:
        return _buildAPRComparison();
    }
  }

  Widget _buildAPRComparison() {
    final currentApr =
        (widget.props['current_apr'] as num?)?.toDouble() ?? 0;
    final averageApr =
        (widget.props['average_apr'] as num?)?.toDouble() ?? 0;
    final bestApr = (widget.props['best_apr'] as num?)?.toDouble() ?? 0;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (currentApr + 2).ceilToDouble(),
        barGroups: [
          _makeBarGroup(0, 'Current', currentApr, Colors.orange),
          _makeBarGroup(1, 'Average', averageApr, Colors.blue),
          _makeBarGroup(2, 'Best', bestApr, Colors.green),
        ],
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const labels = ['Current', 'Average', 'Best'];
                if (value.toInt() < labels.length) {
                  return Text(
                    labels[value.toInt()],
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}%',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, String label, double y, Color color) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
        toY: y,
        color: color,
        width: 22,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
      ),
    ]);
  }

  Widget _buildPaymentBreakdown() {
    final principal =
        (widget.props['principal'] as num?)?.toDouble() ?? 0;
    final interest = (widget.props['interest'] as num?)?.toDouble() ?? 0;
    final fees = (widget.props['fees'] as num?)?.toDouble() ?? 0;
    final total = principal + interest + fees;

    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: principal,
            color: Colors.green,
            title: '${((principal / total) * 100).toStringAsFixed(0)}%',
            radius: 50,
            titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          PieChartSectionData(
            value: interest,
            color: Colors.orange,
            title: '${((interest / total) * 100).toStringAsFixed(0)}%',
            radius: 50,
            titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          PieChartSectionData(
            value: fees,
            color: Colors.red,
            title: '${((fees / total) * 100).toStringAsFixed(0)}%',
            radius: 50,
            titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
        sectionsSpace: 2,
        centerSpaceRadius: 30,
        centerSpaceColor: Colors.transparent,
      ),
    );
  }

  Widget _buildInterestOverTime() {
    final points =
        (widget.props['data_points'] as List<dynamic>?)
            ?.map((e) => (e as num).toDouble())
            .toList() ??
        [2000, 1800, 1600, 1400, 1200, 1000, 800, 600, 400, 200];

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              points.length,
              (i) => FlSpot(i.toDouble(), points[i]),
            ),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withValues(alpha: 0.1),
            ),
          ),
        ],
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 500,
        ),
        titlesData: FlTitlesData(
          show: true,
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '\$${value.toInt()}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  'Yr ${value.toInt() + 1}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
