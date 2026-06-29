import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

// ──────────────────────────────────────────────────────────────
// 🔑  ضع مفاتيحك هنا
// ──────────────────────────────────────────────────────────────
const String _anthropicKey = 'YOUR_ANTHROPIC_API_KEY';
const String _elevenLabsKey = 'YOUR_ELEVENLABS_API_KEY';

// ──────────────────────────────────────────────────────────────
// 🎙️  أصوات ElevenLabs المتاحة
//     جيب المزيد من: https://api.elevenlabs.io/v1/voices
// ──────────────────────────────────────────────────────────────
const List<Map<String, String>> kElevenVoices = [
  {
    'label': '🇪🇬 أحمد — صوت رجالي مصري',
    'id': 'ErXwobaYiN019PkySvjV', // Antoni (عربي ناعم)
    'gender': 'male',
  },
  {
    'label': '🇪🇬 ليلى — صوت ستاتي مصري',
    'id': 'EXAVITQu4vr4xnSDxMaL', // Bella
    'gender': 'female',
  },
  {
    'label': '🌍 Adam — صوت إنجليزي عميق',
    'id': 'pNInz6obpgDQGcFmaJgB', // Adam
    'gender': 'male',
  },
  {
    'label': '🌍 Rachel — صوت إنجليزي ناعم',
    'id': '21m00Tcm4TlvDq8ikWAM', // Rachel
    'gender': 'female',
  },
];

// ──────────────────────────────────────────────────────────────
//  Model
// ──────────────────────────────────────────────────────────────
class ChatMessage {
  final String role; // 'user' | 'bot'
  final String text;
  final DateTime time;

  const ChatMessage({
    required this.role,
    required this.text,
    required this.time,
  });
}

// ──────────────────────────────────────────────────────────────
//  View
// ──────────────────────────────────────────────────────────────
class VoiceAssistantView extends StatefulWidget {
  const VoiceAssistantView({super.key});

  @override
  State<VoiceAssistantView> createState() => _VoiceAssistantViewState();
}

class _VoiceAssistantViewState extends State<VoiceAssistantView>
    with TickerProviderStateMixin {
  // ── speech ──
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  // ── audio player ──
  final AudioPlayer _player = AudioPlayer();
  bool _isSpeaking = false;

  // ── state ──
  String _statusText = 'جاهز يا هندسة..';
  final List<ChatMessage> _messages = [];
  final List<Map<String, String>> _history = []; // Claude history
  final ScrollController _scrollCtrl = ScrollController();

  // ── voice selection ──
  Map<String, String> _selectedVoice = kElevenVoices.first;

  // ── streaming text buffer ──
  String _streamBuffer = '';
  bool _isStreaming = false;

  // ── Claude system prompt ──
  static const String _systemPrompt = '''
أنت "Khotwa AI" — مساعد برمجيات ذكي محترف.
- بتكلم بلهجة مصرية عامية تقنية راقية
- تنادي المستخدم بـ "يا هندسة"
- ردودك واضحة ومباشرة وعملية
- لما تشرح كود تبسّطه بأمثلة حقيقية
- لما الواحد يسألك سؤال عام تجاوب بشكل طبيعي زي صاحب بيحكي مع صاحبه
- ردودك مش طويلة أوي، موجزة ومفيدة
- لو المستخدم بيكلمك إنجليزي رد عليه إنجليزي
''';

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _greet();
  }

  @override
  void dispose() {
    _speech.stop();
    _player.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────────────────
  //  Init
  // ──────────────────────────────────────────────────────────
  Future<void> _initSpeech() async {
    await _speech.initialize(
      onError: (e) => _setStatus('مشكلة في الميكروفون: ${e.errorMsg}'),
    );
  }

  Future<void> _greet() async {
    const greeting =
        'أهلاً بك يا هندسة، أنا خُطوة آي آي. جاهز أساعدك في أي حاجة تقنية أو غيرها.';
    _addBotMessage(greeting);
    await _speak(greeting);
    // بعد السلام ابدأ الاستماع مباشرةً
    _startListening();
  }

  // ──────────────────────────────────────────────────────────
  //  Listening
  // ──────────────────────────────────────────────────────────
  Future<void> _startListening() async {
    if (_isStreaming || _isSpeaking) return;

    await _player.stop();
    bool ok = await _speech.initialize();
    if (!ok) {
      _setStatus('الميكروفون مش شغال يا هندسة');
      return;
    }

    setState(() {
      _isListening = true;
      _statusText = 'سامعك يا هندسة.. اتفضل';
    });

    _speech.listen(
      localeId: 'ar_EG',
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      onResult: (result) {
        if (result.finalResult && result.recognizedWords.isNotEmpty) {
          setState(() => _isListening = false);
          _speech.stop();
          _onUserSpoke(result.recognizedWords);
        }
      },
      onSoundLevelChange: (level) {}, // يمكنك عمل visualizer هنا
    );
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
      _statusText = 'جاهز يا هندسة..';
    });
  }

  // ──────────────────────────────────────────────────────────
  //  Process user input → Claude → ElevenLabs
  // ──────────────────────────────────────────────────────────
  Future<void> _onUserSpoke(String text) async {
    _addUserMessage(text);
    _history.add({'role': 'user', 'content': text});

    await _askClaude();
  }

  Future<void> _askClaude() async {
    _setStatus('بفكر في الرد..');
    setState(() => _isStreaming = true);

    // أضف placeholder للرسالة اللي هتتبني
    final botMsgIndex = _messages.length;
    setState(() {
      _messages.add(ChatMessage(role: 'bot', text: '', time: DateTime.now()));
      _streamBuffer = '';
    });

    try {
      final request = http.Request(
        'POST',
        Uri.parse('https://api.anthropic.com/v1/messages'),
      );
      request.headers.addAll({
        'x-api-key': _anthropicKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
        'anthropic-beta': 'messages-2023-12-15',
      });
      request.body = jsonEncode({
        'model': 'claude-haiku-4-5',
        'max_tokens': 1024,
        'stream': true,
        'system': _systemPrompt,
        'messages': _history,
      });

      final response = await request.send();

      if (response.statusCode != 200) {
        final body = await response.stream.bytesToString();
        throw Exception('Claude error ${response.statusCode}: $body');
      }

      // ── Stream SSE ──
      final fullReply = StringBuffer();
      await for (final chunk in response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())) {
        if (chunk.startsWith('data: ')) {
          final data = chunk.substring(6);
          if (data == '[DONE]') break;
          try {
            final json = jsonDecode(data) as Map<String, dynamic>;
            if (json['type'] == 'content_block_delta') {
              final delta = json['delta'] as Map<String, dynamic>?;
              final text = delta?['text'] as String? ?? '';
              if (text.isNotEmpty) {
                fullReply.write(text);
                setState(() {
                  _messages[botMsgIndex] = ChatMessage(
                    role: 'bot',
                    text: fullReply.toString(),
                    time: _messages[botMsgIndex].time,
                  );
                });
                _scrollToBottom();
              }
            }
          } catch (_) {
            // skip non-JSON lines
          }
        }
      }

      final reply = fullReply.toString().trim();
      if (reply.isEmpty) throw Exception('رد فاضي من Claude');

      _history.add({'role': 'assistant', 'content': reply});
      setState(() => _isStreaming = false);
      _setStatus('خُطوة يتكلم..');

      await _speak(reply);
    } catch (e) {
      setState(() => _isStreaming = false);
      const errMsg = 'معلش يا هندسة في مشكلة، ممكن تعيد السؤال؟';
      setState(() {
        _messages[botMsgIndex] = ChatMessage(
          role: 'bot',
          text: errMsg,
          time: DateTime.now(),
        );
      });
      await _speak(errMsg);
    }
  }

  // ──────────────────────────────────────────────────────────
  //  ElevenLabs TTS
  // ──────────────────────────────────────────────────────────
  Future<void> _speak(String text) async {
    if (text.isEmpty) return;
    setState(() {
      _isSpeaking = true;
      _statusText = 'خُطوة يتكلم..';
    });

    try {
      final uri = Uri.parse(
        'https://api.elevenlabs.io/v1/text-to-speech/${_selectedVoice['id']}/stream',
      );

      final response = await http.post(
        uri,
        headers: {
          'xi-api-key': _elevenLabsKey,
          'Content-Type': 'application/json',
          'Accept': 'audio/mpeg',
        },
        body: jsonEncode({
          'text': text,
          'model_id': 'eleven_multilingual_v2', // يدعم العربية
          'voice_settings': {
            'stability': 0.55,
            'similarity_boost': 0.80,
            'style': 0.35,
            'use_speaker_boost': true,
          },
          'language_code': 'ar', // تحديد العربي
        }),
      );

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final source = _BytesAudioSource(bytes);
        await _player.setAudioSource(source);
        await _player.play();
        // انتظر لحد ما يخلص
        await _player.playerStateStream.firstWhere(
          (s) => s.processingState == ProcessingState.completed,
        );
      } else {
        debugPrint('ElevenLabs error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      debugPrint('TTS error: $e');
    } finally {
      setState(() {
        _isSpeaking = false;
        _statusText = 'جاهز يا هندسة..';
      });
      // بعد ما يخلص الكلام ابدأ الاستماع تاني أوتوماتيكي
      Future.delayed(const Duration(milliseconds: 500), _startListening);
    }
  }

  // ──────────────────────────────────────────────────────────
  //  Helpers
  // ──────────────────────────────────────────────────────────
  void _addUserMessage(String text) {
    setState(() {
      _messages.add(
        ChatMessage(role: 'user', text: text, time: DateTime.now()),
      );
    });
    _scrollToBottom();
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(role: 'bot', text: text, time: DateTime.now()));
    });
    _scrollToBottom();
  }

  void _setStatus(String s) => setState(() => _statusText = s);

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ──────────────────────────────────────────────────────────
  //  Voice Picker Sheet
  // ──────────────────────────────────────────────────────────
  void _openVoicePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111827),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder:
          (ctx) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'اختار صوت يا هندسة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...kElevenVoices.map((v) {
                final isSelected = v['id'] == _selectedVoice['id'];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        isSelected ? const Color(0xFF6366F1) : Colors.white10,
                    child: Icon(
                      v['gender'] == 'male' ? Icons.male : Icons.female,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    v['label']!,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing:
                      isSelected
                          ? const Icon(
                            Icons.check_circle,
                            color: Color(0xFF6366F1),
                          )
                          : null,
                  onTap: () {
                    setState(() => _selectedVoice = v);
                    Navigator.pop(ctx);
                    _speak('تم تغيير الصوت يا هندسة. هل عجبك؟');
                  },
                );
              }),
              const SizedBox(height: 24),
            ],
          ),
    );
  }

  // ──────────────────────────────────────────────────────────
  //  UI
  // ──────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030712),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildStatusBar(),
          Expanded(child: _buildChat()),
          _buildMicButton(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  _isSpeaking || _isListening
                      ? Colors.greenAccent
                      : Colors.white24,
              boxShadow:
                  (_isSpeaking || _isListening)
                      ? [
                        const BoxShadow(
                          color: Colors.greenAccent,
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                      : null,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'KHOTWA AI',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.tune_rounded, color: Color(0xFF6366F1)),
          onPressed: _openVoicePicker,
        ),
      ],
    );
  }

  Widget _buildStatusBar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color:
            _isListening
                ? Colors.green.withValues(alpha: 0.12)
                : _isSpeaking
                ? const Color(0xFF4F46E5).withValues(alpha: 0.12)
                : Colors.blue.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              _isListening
                  ? Colors.greenAccent.withValues(alpha: 0.3)
                  : _isSpeaking
                  ? const Color(0xFF6366F1).withValues(alpha: 0.3)
                  : Colors.white10,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isListening || _isSpeaking || _isStreaming)
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color:
                    _isListening ? Colors.greenAccent : const Color(0xFF6366F1),
              ),
            ),
          if (_isListening || _isSpeaking || _isStreaming)
            const SizedBox(width: 8),
          Text(
            _statusText,
            style: TextStyle(
              color:
                  _isListening
                      ? Colors.greenAccent
                      : _isSpeaking
                      ? const Color(0xFF818CF8)
                      : Colors.blueAccent,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChat() {
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      itemCount: _messages.length,
      itemBuilder: (context, i) => _buildBubble(_messages[i], i),
    );
  }

  Widget _buildBubble(ChatMessage msg, int index) {
    final isUser = msg.role == 'user';
    return Animate(
      effects: [
        FadeEffect(duration: 300.ms),
        SlideEffect(
          begin: Offset(isUser ? 0.2 : -0.2, 0),
          duration: 300.ms,
          curve: Curves.easeOut,
        ),
      ],
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient:
                isUser
                    ? null
                    : const LinearGradient(
                      colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            color: isUser ? const Color(0xFF1F2937) : null,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: Radius.circular(isUser ? 20 : 4),
              bottomRight: Radius.circular(isUser ? 4 : 20),
            ),
            boxShadow: [
              BoxShadow(
                color:
                    isUser
                        ? Colors.black38
                        : const Color(0xFF6366F1).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        color: Colors.white54,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Khotwa AI',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      // Typing indicator
                      if (_isStreaming &&
                          index == _messages.length - 1 &&
                          msg.text.isEmpty)
                        const _TypingDots(),
                    ],
                  ),
                ),
              if (msg.text.isNotEmpty)
                Text(
                  msg.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.5,
                    height: 1.5,
                  ),
                  textDirection: TextDirection.rtl,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMicButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40, top: 16),
      child: Column(
        children: [
          // زر الميكروفون مع Glow
          AvatarGlow(
            animate: _isListening,
            glowColor: const Color(0xFF8B5CF6),
            child: GestureDetector(
              onTap: _isListening ? _stopListening : _startListening,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient:
                      _isListening
                          ? const LinearGradient(
                            colors: [Colors.greenAccent, Colors.teal],
                          )
                          : _isSpeaking
                          ? const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                          )
                          : const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
                          ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          _isListening
                              ? Colors.greenAccent.withValues(alpha: 0.4)
                              : const Color(0xFF6366F1).withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  _isListening
                      ? Icons.stop_rounded
                      : _isSpeaking
                      ? Icons.volume_up_rounded
                      : Icons.mic_rounded,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _isListening
                ? 'اضغط للإيقاف'
                : _isSpeaking
                ? 'يتكلم الآن...'
                : 'اضغط للتحدث',
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
//  Typing Dots Animation
// ──────────────────────────────────────────────────────────────
class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final offset = ((_ctrl.value * 3 - i) % 1.0).clamp(0.0, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Opacity(
                opacity: (0.3 + offset * 0.7).clamp(0.3, 1.0),
                child: const Text(
                  '•',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────
//  BytesAudioSource — بيخلي just_audio يشغل bytes مباشرة
// ──────────────────────────────────────────────────────────────
class _BytesAudioSource extends StreamAudioSource {
  final Uint8List _bytes;

  _BytesAudioSource(this._bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= _bytes.length;
    return StreamAudioResponse(
      sourceLength: _bytes.length,
      contentLength: end - start,
      offset: start,
      contentType: 'audio/mpeg',
      stream: Stream.value(_bytes.sublist(start, end)),
    );
  }
}
