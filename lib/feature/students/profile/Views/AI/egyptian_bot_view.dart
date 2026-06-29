// ============================================================
//  KHOTWA OMNI AI — الإصدار المتصل بـ n8n 🚀
//  المطور: محمود سلمي | ma7moudselmi
// ============================================================

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// ✅ استيراد خدمة الـ AI
import 'khotwa_ai_service.dart';

class KhotwaOmniAI extends StatefulWidget {
  const KhotwaOmniAI({super.key});

  @override
  State<KhotwaOmniAI> createState() => _KhotwaOmniAIState();
}

class _KhotwaOmniAIState extends State<KhotwaOmniAI>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  bool _isTyping = false;
  bool _isConnected = true;
  File? _selectedImage;
  String _currentMode = "General";

  List<Map<String, dynamic>> _messages = [];

  final List<Map<String, dynamic>> _tools = [
    {"name": "💬 عام", "icon": Icons.chat_bubble_outline, "mode": "General"},
    {
      "name": "🎨 رسم",
      "icon": Icons.collections_rounded,
      "mode": "Create image",
    },
    {
      "name": "📚 تعلم",
      "icon": Icons.school_rounded,
      "mode": "Guided learning",
    },
    {"name": "🔍 بحث", "icon": Icons.search_rounded, "mode": "Search"},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(_animationController);

    _loadChatFromCache();
    _checkConnectivity();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    setState(() => _isConnected = result != ConnectivityResult.none);

    Connectivity().onConnectivityChanged.listen((result) {
      setState(() => _isConnected = result != ConnectivityResult.none);
      if (_isConnected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ تم الاتصال بالإنترنت'),
            backgroundColor: Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  Future<void> _loadChatFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cachedData = prefs.getString('khotwa_chat_cache');
    setState(() {
      if (cachedData != null) {
        _messages = List<Map<String, dynamic>>.from(json.decode(cachedData));
      } else {
        _messages.add({
          "role": "bot",
          "message":
              "👋 أهلاً بيك في KHOTWA OMNI AI!\n\nأنا متصل بـ n8n webhook وقادر أساعدك في أي حاجة.\n\n💡 جرب تسألني عن:\n• 📚 مشروع التخرج\n• 💻 برمجة Flutter\n• 📝 كتابة تقارير\n• 🎯 خطط دراسة",
          "type": "text",
          "time": DateTime.now().toIso8601String(),
        });
      }
      _isTyping = false;
    });
    _scrollToBottom();
  }

  Future<void> _saveChatToCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('khotwa_chat_cache', json.encode(_messages));
  }

  void _handleUserMessage() async {
    if (_controller.text.trim().isEmpty && _selectedImage == null) return;

    // ✅ التحقق من الاتصال
    if (!_isConnected) {
      _showSnackBar('❌ لا يوجد اتصال بالإنترنت', Colors.redAccent);
      return;
    }

    final userText = _controller.text.trim();
    final userImage = _selectedImage;

    setState(() {
      _messages.add({
        "role": "user",
        "message": userText,
        "type": "text",
        "image_path": userImage?.path,
        "time": DateTime.now().toIso8601String(),
      });
      _controller.clear();
      _selectedImage = null;
      _isTyping = true;
    });
    _scrollToBottom();
    await _saveChatToCache();

    // ✅ إرسال للـ AI عبر الـ Webhook
    try {
      final reply = await KhotwaAIService.sendMessage(userText);

      setState(() {
        _messages.add({
          "role": "bot",
          "message": reply,
          "type": "text",
          "time": DateTime.now().toIso8601String(),
        });
        _isTyping = false;
      });
      _scrollToBottom();
      await _saveChatToCache();
    } catch (e) {
      setState(() => _isTyping = false);
      _showSnackBar('❌ خطأ: ${e.toString()}', Colors.redAccent);
    }
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(20.r),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
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

  Future<void> _clearChat() async {
    await KhotwaAIService.clearHistory();
    setState(() {
      _messages = [];
      _messages.add({
        "role": "bot",
        "message": "🧹 تم مسح المحادثة! ابدأ من جديد.",
        "type": "text",
        "time": DateTime.now().toIso8601String(),
      });
    });
    _saveChatToCache();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildConnectionStatus(),
          _buildToolBar(),
          Expanded(
            child:
                _messages.isEmpty
                    ? _buildWelcomeScreen()
                    : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildMessageBubble(_messages[index]),
                            ),
                          ),
                        );
                      },
                    ),
          ),
          if (_isTyping) _buildTypingIndicator(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color:
          _isConnected
              ? const Color(0xFF10B981).withValues(alpha: 0.1)
              : Colors.redAccent.withValues(alpha: 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 8.r,
            height: 8.r,
            decoration: BoxDecoration(
              color: _isConnected ? const Color(0xFF10B981) : Colors.redAccent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _isConnected ? '🟢 متصل بـ n8n' : '🔴 غير متصل',
            style: TextStyle(
              color: _isConnected ? const Color(0xFF10B981) : Colors.redAccent,
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (_isConnected) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                '🚀 ${_messages.length} رسائل',
                style: TextStyle(
                  color: const Color(0xFF6366F1),
                  fontSize: 8.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/ai_typing.json',
            width: 150.w,
            height: 150.h,
            errorBuilder:
                (_, __, ___) => Container(
                  width: 150.w,
                  height: 150.h,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
          ),
          SizedBox(height: 20.h),
          Text(
            'KHOTWA OMNI AI 🚀',
            style: TextStyle(
              color: const Color(0xFF6366F1),
              fontSize: 24.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'متصل بـ n8n Webhook',
            style: TextStyle(
              color: Colors.grey.withValues(alpha: 0.5),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 30.h),
          Wrap(
            spacing: 10.w,
            alignment: WrapAlignment.center,
            children: [
              _buildSuggestionChip('📚 مشروع تخرج', 'ساعدني في مشروع تخرجي'),
              _buildSuggestionChip('💻 كود Flutter', 'اكتب لي كود Flutter لـ'),
              _buildSuggestionChip('📝 تقرير', 'ساعدني في كتابة تقرير عن'),
              _buildSuggestionChip('🎯 خطة دراسة', 'اعمل لي خطة دراسة لـ'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String label, String prefix) {
    return ActionChip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      onPressed: () {
        _controller.text = prefix;
        _handleUserMessage();
      },
      backgroundColor: const Color(0xFF1E293B),
      side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    final isBot = msg['role'] == 'bot';
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(maxWidth: 0.85.sw),
        decoration: BoxDecoration(
          gradient:
              isBot
                  ? LinearGradient(
                    colors: [
                      const Color(0xFF1E293B),
                      const Color(0xFF1E293B).withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          color: isBot ? null : const Color(0xFF6366F1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isBot ? 4.r : 16.r),
            topRight: Radius.circular(isBot ? 16.r : 4.r),
            bottomLeft: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
          ),
          border:
              isBot
                  ? Border.all(color: Colors.white.withValues(alpha: 0.05))
                  : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (msg['image_path'] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.file(
                    File(msg['image_path']),
                    height: 150.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Text(
              msg['message'] ?? '',
              style: TextStyle(
                color: isBot ? Colors.white : Colors.white,
                fontSize: 15.sp,
                height: 1.6,
              ),
            ),
            if (msg['time'] != null)
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  _formatTime(msg['time']),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                    fontSize: 8.sp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String iso) {
    try {
      final dt = DateTime.parse(iso);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return 'الآن';
      if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
      if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '';
    }
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFF6366F1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          const Text(
            'خُطوة بتفكر... 🤔',
            style: TextStyle(
              color: Colors.white54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolBar() {
    return Container(
      height: 50.h,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tools.length,
        itemBuilder: (c, i) {
          final tool = _tools[i];
          final selected = tool['mode'] == _currentMode;
          return GestureDetector(
            onTap: () => setState(() => _currentMode = tool['mode'] as String),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient:
                    selected
                        ? const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
                        )
                        : null,
                color: selected ? null : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color:
                      selected
                          ? Colors.transparent
                          : Colors.white.withValues(alpha: 0.05),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    tool['icon'] as IconData,
                    size: 16,
                    color: selected ? Colors.white : Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    tool['name'] as String,
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.grey,
                      fontWeight:
                          selected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0D1117),
      elevation: 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF6366F1),
                  Color(0xFFA855F7),
                  Color(0xFFEC4899),
                ],
              ),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            "KHOTWA OMNI AI",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 8),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: const Text(
              '🚀 LIVE',
              style: TextStyle(
                color: Color(0xFF10B981),
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent),
          onPressed: _clearChat,
        ),
      ],
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 35.h),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.add_photo_alternate,
              color: Color(0xFF6366F1),
            ),
            onPressed: () async {
              final img = await _picker.pickImage(source: ImageSource.gallery);
              if (img != null) setState(() => _selectedImage = File(img.path));
            },
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              onSubmitted: (_) => _handleUserMessage(),
              decoration: InputDecoration(
                hintText: _isConnected ? "اسأل خُطوة..." : "⚠️ غير متصل",
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color:
                      _isConnected
                          ? Colors.white24
                          : Colors.redAccent.withValues(alpha: 0.5),
                ),
                prefixIcon:
                    _selectedImage != null
                        ? IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Color(0xFF10B981),
                          ),
                          onPressed:
                              () => setState(() => _selectedImage = null),
                        )
                        : null,
              ),
            ),
          ),
          GestureDetector(
            onTap: _handleUserMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient:
                    _isConnected
                        ? const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
                        )
                        : null,
                color: _isConnected ? null : Colors.grey.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isConnected ? Icons.send : Icons.wifi_off,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
