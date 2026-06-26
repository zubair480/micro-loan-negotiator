import 'package:flutter/material.dart';
import 'widgets/risk_card.dart';
import 'widgets/loan_chart.dart';
import 'widgets/budget_card.dart';
import 'widgets/timeline_widget.dart';
import 'widgets/recommendation_card.dart';
import 'widgets/confidence_card.dart';
import 'widgets/negotiation_panel.dart';
import 'widgets/tradeoff_slider.dart';
import 'widgets/warning_card.dart';
import 'widgets/financial_health_card.dart';
import 'widgets/monthly_breakdown.dart';
import 'widgets/action_card.dart';

typedef WidgetBuilder = Widget Function(Map<String, dynamic> props);

class WidgetRegistry {
  static final Map<String, WidgetBuilder> _registry = {};

  static void registerAll() {
    _registry['RiskCard'] = (props) => RiskCard(props: props);
    _registry['LoanChart'] = (props) => LoanChart(props: props);
    _registry['BudgetCard'] = (props) => BudgetCard(props: props);
    _registry['TimelineWidget'] = (props) => TimelineWidget(props: props);
    _registry['RecommendationCard'] = (props) =>
        RecommendationCard(props: props);
    _registry['ConfidenceCard'] = (props) => ConfidenceCard(props: props);
    _registry['NegotiationPanel'] = (props) => NegotiationPanel(props: props);
    _registry['TradeoffSlider'] = (props) => TradeoffSlider(props: props);
    _registry['WarningCard'] = (props) => WarningCard(props: props);
    _registry['FinancialHealthCard'] = (props) =>
        FinancialHealthCard(props: props);
    _registry['MonthlyBreakdown'] = (props) => MonthlyBreakdown(props: props);
    _registry['ActionCard'] = (props) => ActionCard(props: props);
  }

  static void register(String type, WidgetBuilder builder) {
    _registry[type] = builder;
  }

  static WidgetBuilder? getBuilder(String type) {
    return _registry[type];
  }

  static bool hasType(String type) {
    return _registry.containsKey(type);
  }

  static Widget build(String type, Map<String, dynamic> props) {
    final builder = _registry[type];
    if (builder == null) {
      return _buildFallback(type);
    }
    return builder(props);
  }

  static Widget _buildFallback(String type) {
    return Center(
      child: Text(
        'Unknown widget type: $type',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
