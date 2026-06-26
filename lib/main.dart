import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/conversation_provider.dart';
import 'providers/loan_provider.dart';
import 'providers/generated_ui_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/landing_screen.dart';
import 'screens/conversation_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/generated_surface_screen.dart';
import 'screens/offer_details_screen.dart';
import 'screens/negotiation_screen.dart';
import 'screens/summary_screen.dart';
import 'catalog/widget_registry.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetRegistry.registerAll();
  await _initSupabase();
  runApp(const NegotiaAIApp());
}

Future<void> _initSupabase() async {
  try {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      publishableKey: AppConstants.supabaseAnonKey,
    );
  } catch (_) {}
}

class NegotiaAIApp extends StatelessWidget {
  const NegotiaAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConversationProvider()),
        ChangeNotifierProvider(create: (_) => LoanProvider()),
        ChangeNotifierProvider(create: (_) => GeneratedUIProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Negotia AI',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.theme,
            initialRoute: '/',
            routes: {
              '/': (context) => const LandingScreen(),
              '/conversation': (context) => const ConversationScreen(),
              '/loading': (context) => const LoadingScreen(),
              '/generated': (context) => const GeneratedSurfaceScreen(),
              '/offer_details': (context) => const OfferDetailsScreen(),
              '/negotiation': (context) => const NegotiationScreen(),
              '/summary': (context) => const SummaryScreen(),
            },
          );
        },
      ),
    );
  }
}
