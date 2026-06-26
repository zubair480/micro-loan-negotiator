import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/conversation_provider.dart';
import '../services/featherless_service.dart';
import '../widgets/chat_bubble.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _aiService = FeatherlessService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendInitialGreeting();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendInitialGreeting() async {
    final provider = context.read<ConversationProvider>();
    provider.setProcessing(true);
    final response = await _aiService.sendMessage(
      'Start the conversation. Greet the user and ask about their financial situation and loan needs.',
    );
    if (mounted) {
      provider.addMessage(role: 'ai', content: response);
      provider.setProcessing(false);
      _scrollToBottom();
    }
  }

  void _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    final convProvider = context.read<ConversationProvider>();

    convProvider.addMessage(role: 'user', content: text);
    convProvider.setProcessing(true);
    _scrollToBottom();

    final response = await _aiService.sendMessage(text);
    if (!mounted) return;

    convProvider.addMessage(role: 'ai', content: response);
    convProvider.setProcessing(false);
    _scrollToBottom();

    _checkForProceed(response);
  }

  void _checkForProceed(String response) {
    if (response.toLowerCase().contains('"surface_type"') &&
        response.contains('"widgets"')) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.of(context).pushNamed('/loading');
        }
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: 'app_logo',
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      Color(0xFF0D7C3F),
                      Color(0xFF12A350),
                      Color(0xFFFFB300),
                      Color(0xFF0D7C3F),
                    ],
                  ),
                ),
                child: const Center(
                  child: Text('N',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('Negotia AI'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            onPressed: () {
              Navigator.of(context).pushNamed('/loading');
            },
            tooltip: 'Generate UI',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ConversationProvider>(
              builder: (context, provider, child) {
                if (provider.messages.isEmpty) {
                  return const Center(
                    child: Text('Starting conversation...'),
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: provider.messages.length,
                  itemBuilder: (context, index) {
                    final message = provider.messages[index];
                    if (message.isSystem) {
                      return const SizedBox.shrink();
                    }
                    return ChatBubble(message: message);
                  },
                );
              },
            ),
          ),
          if (context.watch<ConversationProvider>().isProcessing)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Thinking...',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              border: Border(
                top: BorderSide(
                  color: Colors.grey.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Tell me about your finances...',
                        border: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      minLines: 1,
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Consumer<ConversationProvider>(
                    builder: (context, provider, child) {
                      return IconButton.filled(
                        onPressed: provider.isProcessing ? null : _sendMessage,
                        icon: const Icon(Icons.send),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
