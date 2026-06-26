import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/constants.dart';
import '../models/loan_offer.dart';
import '../models/financial_profile.dart';
import '../models/conversation_message.dart';

class SupabaseService {
  SupabaseClient? _client;

  SupabaseClient get client {
    _client ??= SupabaseClient(
      AppConstants.supabaseUrl,
      AppConstants.supabaseAnonKey,
    );
    return _client!;
  }

  Future<void> saveConversation({
    required String sessionId,
    required List<ConversationMessage> messages,
  }) async {
    try {
      await client.from('conversations').upsert({
        'session_id': sessionId,
        'messages': messages.map((m) => m.toJson()).toList(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (_) {}
  }

  Future<void> saveLoanOffer({
    required String sessionId,
    required LoanOffer offer,
  }) async {
    try {
      await client.from('loan_offers').insert({
        'session_id': sessionId,
        ...offer.toJson(),
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (_) {}
  }

  Future<void> saveFinancialProfile({
    required String sessionId,
    required FinancialProfile profile,
  }) async {
    try {
      await client.from('financial_profiles').insert({
        'session_id': sessionId,
        ...profile.toJson(),
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (_) {}
  }

  Future<List<LoanOffer>?> getLoanOffers(String sessionId) async {
    try {
      final data = await client
          .from('loan_offers')
          .select()
          .eq('session_id', sessionId);
      return data
          .map((e) => LoanOffer.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> initialize() async {
    try {
      await client.from('conversations').select().limit(1);
    } catch (_) {}
  }
}
