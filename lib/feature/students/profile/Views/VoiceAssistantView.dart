import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceAssistantView extends StatefulWidget {
  const VoiceAssistantView({super.key});

  @override
  State<VoiceAssistantView> createState() => _VoiceAssistantViewState();
}

class _VoiceAssistantViewState extends State<VoiceAssistantView> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  bool _isListening = false;
  String _botStatus = "في انتظار صوتك...";

  final String _apiKey = "YOUR_GEMINI_API_KEY";
  late GenerativeModel _model;
  late ChatSession _chat;

  final List<Map<String, String>> _messages = [];

  final meshGradient = const LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
  );

  @override
  void initState() {
    super.initState();

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      systemInstruction: Content.system(
        "أنت مساعد ذكي جداً، خبير برمجة وتفكير، بتفهم بسرعة وبترد بشكل مختصر وواضح بالمصري الطبيعي.",
      ),
    );

    _chat = _model.startChat();

    _tts.setLanguage("ar-EG");
    _tts.setSpeechRate(0.4);

    String welcome =
        "مرحباً يا بشمهندس  أخبارك ايه؟ تحب أساعدك في إيه النهارده؟";

    _messages.add({"role": "bot", "text": welcome});
    _tts.speak(welcome);

    _startListeningLoop();
  }

  Future<void> _startListeningLoop() async {
    bool available = await _speech.initialize();

    if (available) {
      setState(() {
        _isListening = true;
        _botStatus = "بتكلم... أنا سامعك";
      });

      _speech.listen(
        localeId: "ar_EG",
        partialResults: true,
        listenMode: stt.ListenMode.confirmation,
        onResult: (val) {
          if (val.recognizedWords.isNotEmpty) {
            setState(() {
              if (_messages.isNotEmpty && _messages.last["role"] == "user") {
                _messages.last["text"] = val.recognizedWords;
              } else {
                _messages.add({"role": "user", "text": val.recognizedWords});
              }
            });
          }

          if (val.finalResult) {
            _isListening = false;
            _botStatus = "بفكر...";

            _handleUserInput(val.recognizedWords);
          }
        },
      );
    }
  }

  Future<void> _handleUserInput(String text) async {
    await _speech.stop();
    await _getAIResponse(text);
  }

  Future<void> _getAIResponse(String input) async {
    try {
      final response = await _chat.sendMessage(Content.text(input));

      if (!mounted) return;

      String botReply = response.text ?? "قول تاني يا هندسة";

      setState(() {
        _messages.add({"role": "bot", "text": botReply});
        _botStatus = "بيرد...";
      });

      await _tts.stop();
      await _tts.speak(botReply);

      await Future.delayed(const Duration(milliseconds: 400));

      _startListeningLoop();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _messages.add({"role": "bot", "text": "في مشكلة حصلت، جرب تاني"});
        _botStatus = "Error";
      });

      _startListeningLoop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Text(_botStatus, style: const TextStyle(color: Colors.white54)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children:
                  _messages.map((msg) {
                    bool isUser = msg["role"] == "user";

                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: isUser ? null : meshGradient,
                          color: isUser ? Colors.blue : null,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          msg["text"]!,
                          style: const TextStyle(
                            color: Colors.white,
                            height: 1.4,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          AvatarGlow(
            animate: _isListening,
            glowColor: const Color(0xFF6366F1),
            duration: const Duration(milliseconds: 2000),
            repeat: true,
            child: GestureDetector(
              onTap: _startListeningLoop,
              child: Material(
                shape: const CircleBorder(),
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    size: 40,
                    color: const Color(0xFF6366F1),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
