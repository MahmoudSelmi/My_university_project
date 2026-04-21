import 'dart:async';

import 'package:auth_slmi/feature/students/profile/Views/VoiceAssistantView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:file_picker/file_picker.dart';
// تأكد من استيراد صفحة الفويس أسيست

class EgyptianBotView extends StatefulWidget {
  const EgyptianBotView({super.key});

  @override
  State<EgyptianBotView> createState() => _EgyptianBotViewState();
}

class _EgyptianBotViewState extends State<EgyptianBotView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final stt.SpeechToText _speech = stt.SpeechToText();

  final bool _isListening = false;
  bool _isTyping = false;

  final List<Map<String, dynamic>> _messages = [
    {
      "role": "bot",
      "message":
          "تم تفعيل نظام الذكاء الاصطناعي الأكاديمي. أنا هنا لدعمك في تطوير مشروع التخرج الخاص بك بأعلى معايير الجودة التقنية. تفضل بطرح استفسارك.",
    },
  ];

  final meshGradient = const LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
  );

  @override
  void initState() {
    super.initState();
    _speech.initialize();
  }

  // ميثود الانتقال لصفحة المساعد الصوتي
  void _openVoiceAssistant() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VoiceAssistantView()),
    );
  }

  // ميثود اختيار الملفات
  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (result != null) {
      _addMessage("user", "مرفق تقني: ${result.files.first.name}");
      _processSystemResponse(
        "تم فحص الملف المرفوع بنجاح. البروتوكولات مطابقة للمعايير. هل ترغب في تحليل هيكلي للمحتوى؟",
      );
    }
  }

  // إرسال الرسالة
  void _handleResponse() {
    if (_controller.text.trim().isEmpty) return;
    String input = _controller.text.trim();
    _controller.clear();

    _addMessage("user", input);
    String response = _getSmartResponse(input.toLowerCase());
    _processSystemResponse(response);
  }

  // --- محرك الـ Auto-Scroll والكتابة الذكية ---
  void _processSystemResponse(String fullText) {
    setState(() => _isTyping = true);
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      setState(() {
        _isTyping = false;
        _messages.add({"role": "bot", "message": ""});
      });

      int charIndex = 0;
      Timer.periodic(const Duration(milliseconds: 25), (timer) {
        if (charIndex < fullText.length) {
          if (mounted) {
            setState(() {
              _messages.last["message"] += fullText[charIndex];
            });
            _scrollToBottom(); // بينزل لوحده مع كل حرف
            charIndex++;
          }
        } else {
          timer.cancel();
          _scrollToBottom(); // تأكيد النزول للآخر بعد انتهاء الجملة
        }
      });
    });
  }

  void _addMessage(String role, String msg) {
    setState(() {
      _messages.add({"role": role, "message": msg});
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // محرك الردود الرسمي القوي
  String _getSmartResponse(String input) {
    if (input.contains("hello") || input.contains("hi")) {
      return "Greetings. Academic Core System is operational. How can I assist you with your software development lifecycle today?";
    }
    if (input.contains("flutter") || input.contains("code")) {
      return "Analyzing Flutter parameters... We recommend implementing a Clean Architecture with robust State Management to ensure project scalability.";
    }
    if (input.contains("أهلا") ||
        input.contains("ازيك") ||
        input.contains("مرحبا")) {
      return "مرحباً بك. النظام في حالة استعداد تام لمراجعة متطلبات مشروعك الأكاديمي. كيف يمكنني توجيه قدراتي التقنية لمساعدتك الآن؟";
    }
    if (input.contains("مشكلة") || input.contains("خطأ")) {
      return "يرجى تزويدي بالوصف التقني للخطأ. النظام مبرمج لتحليل الاستثناءات البرمجية وتقديم حلول فورية لتجاوز العقبات التقنية.";
    }
    return "تم استلام مدخلاتك بنجاح. النظام يقوم حالياً بمطابقة استفسارك مع المعايير الأكاديمية المعتمدة. هل يمكنك تقديم مزيد من الإيضاح؟";
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F1219) : const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text(
          "ACADEMIC CORE AI",
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isBot = _messages[index]["role"] == "bot";
                return _buildMessageTile(
                  isBot,
                  _messages[index]["message"]!,
                  isDark,
                );
              },
            ),
          ),
          if (_isTyping) _buildTypingIndicator(isDark),
          _buildInputArea(isDark),
        ],
      ),
    );
  }

  Widget _buildMessageTile(bool isBot, String msg, bool isDark) {
    return AnimationConfiguration.staggeredList(
      position: _messages.length,
      child: FadeInAnimation(
        child: Align(
          alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            decoration: BoxDecoration(
              gradient: isBot ? null : meshGradient,
              color:
                  isBot
                      ? (isDark ? const Color(0xFF1E2530) : Colors.white)
                      : null,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isBot ? 4 : 20),
                bottomRight: Radius.circular(isBot ? 20 : 4),
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
              ],
            ),
            child: Text(
              msg,
              style: TextStyle(
                color:
                    isBot
                        ? (isDark ? Colors.white : Colors.black87)
                        : Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(bool isDark) {
    return const Padding(
      padding: EdgeInsets.only(left: 30, bottom: 15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: 15,
          height: 15,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildInputArea(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 35),
      child: Row(
        children: [
          _iconCircle(Icons.add_box_outlined, _pickFile, isDark),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E2530) : Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _controller,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: const InputDecoration(
                  hintText: "أدخل استفسارك...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 13),
                ),
                onSubmitted: (_) => _handleResponse(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // زرار المايك بيفتح صفحة الفويس أسيست
          _iconCircle(
            Icons.mic_rounded,
            _openVoiceAssistant,
            isDark,
            active: true,
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _handleResponse,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: meshGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconCircle(
    IconData icon,
    VoidCallback onTap,
    bool isDark, {
    bool active = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2530) : Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color:
              active
                  ? const Color(0xFF6366F1)
                  : (isDark ? Colors.white70 : Colors.grey),
          size: 24,
        ),
      ),
    );
  }
}
