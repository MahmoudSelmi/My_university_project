import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:file_picker/file_picker.dart';

class EgyptianBotView extends StatefulWidget {
  const EgyptianBotView({super.key});

  @override
  State<EgyptianBotView> createState() => _EgyptianBotViewState();
}

class _EgyptianBotViewState extends State<EgyptianBotView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late stt.SpeechToText _speech;
  bool _isListening = false;

  final List<Map<String, String>> _messages = [
    {
      "role": "bot",
      "message":
          "أهلاً بيك يا هندسة، اتفضل محتاج إيه؟ أنا معاك عشان نخلي مشروع إدارة مشاريع الطلاب ده أقوى مشروع في الدفعة.",
    },
  ];

  final LinearGradient meshGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
  );

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult:
              (val) => setState(() => _controller.text = val.recognizedWords),
          localeId:
              _controller.text.contains(RegExp(r'[a-z]')) ? "en_US" : "ar_EG",
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _messages.add({
          "role": "user",
          "message": "رفعت ملف المشروع: ${result.files.first.name}",
        });
        _messages.add({
          "role": "bot",
          "message":
              "استلمت الملف يا هندسة. جاري فحصه بعمق.. نظام إدارة المشاريع بتاعك محتاج يتشاف من زاوية 'تجربة المستخدم'. هل تحب أقولك إزاي تدافع عن هيكلة البيانات دي قدام الدكاترة في المناقشة؟",
        });
      });
      _scrollToBottom();
    }
  }

  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    String input = _controller.text;
    bool isEnglish = RegExp(r'^[a-zA-Z]').hasMatch(input);
    bool isFormal =
        input.contains("أهلاً") ||
        input.contains("كيف") ||
        input.contains("هل");

    setState(() {
      _messages.add({"role": "user", "message": input});
      String botReply = "";

      if (isEnglish) {
        botReply =
            "Greetings! Designing a Student Project Management system is a sophisticated challenge. We must ensure the scalability of your architecture and the fluidity of task assignments. This technical journey requires precision. What is the specific module you wish to elaborate on right now?";
      } else if (isFormal) {
        botReply =
            "أهلاً بك في رحاب التخطيط الأكاديمي. إن مشروع إدارة مشاريع الطلاب يمثل الركيزة الأساسية لتنظيم النتاج الفكري الجامعي. يتطلب الأمر منا صياغة منطقية للعلاقات بين الطالب والمشرف لضمان جودة المخرجات. هل ترغب في مناقشة الجوانب التنظيمية أم ننتقل إلى التحليل التقني؟";
      } else {
        if (input.contains("ازيك") || input.contains("عامل ايه")) {
          botReply =
              "أنا زي الفل يا هندسة طول ما أنا شايفك بتعافر في مشروعك! بص يا سيدي، إحنا هدفنا إن السيستم بتاعك ده يكون 'المنقذ' للطلبة والمشرفين. يعني الطالب يدخل يحس إنه في بيته مش في تعقيدات ورقية. طمني، إيه أكتر جزء في السيستم حاسس إنه هو اللي هيدي 'اللقطة' في المناقشة؟";
        } else {
          botReply =
              "كلامك في الجون يا هندسة. فلسفة إدارة المشاريع بتقول إن 'البساطة هي قمة الرقي'. إحنا عاوزين السيستم بتاعك يكون سهل بس قوي جداً في الخلفية. المشروع ده لو اتنفذ صح، هيفضل بصمة ليك في الكلية. قولي بقى، محتاج ندردش في إيه تاني عشان نثبت أركان الفكرة دي؟";
        }
      }
      _messages.add({"role": "bot", "message": botReply});
      _controller.clear();
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF111113) : const Color(0xFFF5F5F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (bounds) => meshGradient.createShader(bounds),
          child: const Text(
            "Project Mentor AI",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimationLimiter(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  bool isBot = _messages[index]["role"] == "bot";
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 600),
                    child: SlideAnimation(
                      verticalOffset: 20,
                      child: FadeInAnimation(
                        child: Align(
                          alignment:
                              isBot
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(18),
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.85,
                            ),
                            decoration: BoxDecoration(
                              gradient: isBot ? null : meshGradient,
                              color:
                                  isBot
                                      ? (isDark
                                          ? const Color(0xFF1E1E22)
                                          : Colors.white)
                                      : null,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(22),
                                topRight: const Radius.circular(22),
                                bottomLeft: Radius.circular(isBot ? 4 : 22),
                                bottomRight: Radius.circular(isBot ? 22 : 4),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                    isDark ? 0.3 : 0.04,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              _messages[index]["message"]!,
                              style: TextStyle(
                                color:
                                    isBot
                                        ? (isDark
                                            ? Colors.white70
                                            : Colors.black87)
                                        : Colors.white,
                                fontSize: 15,
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 32),
            child: Row(
              children: [
                _circularBtn(
                  icon: Icons.add_rounded,
                  onTap: _pickFile,
                  isDark: isDark,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E22) : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 15,
                      ),
                      decoration: const InputDecoration(
                        hintText: "اسأل في مشروعك يا هندسة...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _circularBtn(
                  icon:
                      _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                  onTap: _listen,
                  isDark: isDark,
                  active: _isListening,
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
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
          ),
        ],
      ),
    );
  }

  Widget _circularBtn({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
    bool active = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              active
                  ? Colors.red.withOpacity(0.1)
                  : (isDark ? const Color(0xFF1E1E22) : Colors.white),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
          ],
        ),
        child: Icon(
          icon,
          color:
              active
                  ? Colors.red
                  : (isDark ? Colors.grey[400] : const Color(0xFF6366F1)),
          size: 22,
        ),
      ),
    );
  }
}
