import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/conversation_message.dart';

class ConversationProvider extends ChangeNotifier {
  final List<ConversationMessage> _messages = [];
  bool _isProcessing = false;
  final _uuid = const Uuid();

  List<ConversationMessage> get messages => List.unmodifiable(_messages);
  bool get isProcessing => _isProcessing;

  void addMessage({
    required String role,
    required String content,
    Map<String, dynamic>? metadata,
  }) {
    final message = ConversationMessage(
      id: _uuid.v4(),
      role: role,
      content: content,
      metadata: metadata,
    );
    _messages.add(message);
    notifyListeners();
  }

  void setProcessing(bool value) {
    _isProcessing = value;
    notifyListeners();
  }

  String get conversationHistory {
    return _messages
        .where((m) => m.isUser || m.isAI)
        .map((m) => '${m.isUser ? "User" : "AI"}: ${m.content}')
        .join('\n');
  }

  void clear() {
    _messages.clear();
    _isProcessing = false;
    notifyListeners();
  }

  ConversationMessage? get lastMessage {
    return _messages.isNotEmpty ? _messages.last : null;
  }
}
