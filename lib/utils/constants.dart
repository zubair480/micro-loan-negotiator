class AppConstants {
  AppConstants._();

  static const String appName = 'Negotia AI';
  static const String tagline =
      'Every borrower deserves a loan interface designed specifically for them.';

  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
  static const String featherlessApiKey = 'YOUR_FEATHERLESS_API_KEY';
  static const String featherlessBaseUrl = 'https://api.featherless.ai/v1';
  static const String featherlessModel = 'meta-llama/Llama-3.3-70B-Instruct';

  static const double maxWidgetWidth = 600;
  static const double cardBorderRadius = 16;
  static const double cardElevation = 2;
  static const double paddingSmall = 8;
  static const double paddingMedium = 16;
  static const double paddingLarge = 24;
  static const double animationDuration = 300;

  static const List<String> financialGoalOptions = [
    'Buy a home',
    'Start a business',
    'Consolidate debt',
    'Pay for education',
    'Make home improvements',
    'Buy a vehicle',
    'Emergency fund',
    'Other',
  ];

  static const List<String> employmentOptions = [
    'Employed full-time',
    'Employed part-time',
    'Self-employed',
    'Unemployed',
    'Retired',
    'Student',
  ];

  static const List<String> housingOptions = [
    'Own',
    'Rent',
    'Live with family',
    'Other',
  ];
}
