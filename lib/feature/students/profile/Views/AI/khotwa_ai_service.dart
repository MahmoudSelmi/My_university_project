import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'khotwa_fallback_responses.dart';

class KhotwaAIService {
  static const String _webhookUrl =
      'https://khotwaplatform.app.n8n.cloud/webhook/9609c13b-98ba-493f-a7a0-91ce5eb79990/chat';

  static const String _memoryKey = 'khotwa_chat_history';
  static const int _maxHistory = 20;

  // 🚀 إرسال رسالة للـ AI مع نظام Fallback
  static Future<String> sendMessage(
    String message, {
    List<Map<String, dynamic>>? history,
  }) async {
    try {
      // ✅ جلب تاريخ المحادثة
      final chatHistory = await _getChatHistory();

      // ✅ تحويل التاريخ إلى الشكل المطلوب
      final List<Map<String, dynamic>> formattedHistory =
          chatHistory.map((item) {
            return {
              'user': item['user'] ?? '',
              'bot': item['bot'] ?? '',
              'time': item['time'] ?? '',
            };
          }).toList();

      final payload = {
        'message': message,
        'chatId': 'khotwa_mobile_${DateTime.now().millisecondsSinceEpoch}',
        'sessionId': await _getSessionId(),
        'history': (history ?? formattedHistory).take(10).toList(),
        'timestamp': DateTime.now().toIso8601String(),
        'platform': 'khwota_mobile',
        'version': '2.0.0',
        'source': 'flutter_app',
      };

      print('📤 Sending to n8n: ${jsonEncode(payload)}');

      final response = await http
          .post(
            Uri.parse(_webhookUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'User-Agent': 'Khotwa-Mobile/2.0',
            },
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 15));

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        String reply =
            data['reply'] ??
            data['response'] ??
            data['message'] ??
            data['text'] ??
            data['output'] ??
            data['data']?['reply'] ??
            data['data']?['message'] ??
            KhotwaFallback.getResponse(message);

        await _saveChatHistory(message, reply);
        return reply;
      } else {
        final fallbackReply = KhotwaFallback.getResponse(message);
        await _saveChatHistory(message, fallbackReply);
        return '⚠️ السيرفر مش شغال حالياً، بس أنا موجود!\n\n$fallbackReply';
      }
    } on SocketException {
      final fallbackReply = KhotwaFallback.getResponse(message);
      await _saveChatHistory(message, fallbackReply);
      return '📶 مفيش اتصال بالإنترنت، بس أنا معاك!\n\n$fallbackReply';
    } catch (e) {
      final fallbackReply = KhotwaFallback.getResponse(message);
      await _saveChatHistory(message, fallbackReply);
      return '⚠️ عذراً، في مشكلة، بس أنا معاك!\n\n$fallbackReply';
    }
  }

  // 🔑 جلب Session ID
  static Future<String> _getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('khotwa_session_id');
    if (sessionId == null) {
      sessionId =
          'khw_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}';
      await prefs.setString('khotwa_session_id', sessionId);
    }
    return sessionId;
  }

  // 💾 حفظ تاريخ المحادثة
  static Future<void> _saveChatHistory(String userMsg, String botReply) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> history = prefs.getStringList(_memoryKey) ?? [];

      history.add(
        jsonEncode({
          'user': userMsg,
          'bot': botReply,
          'time': DateTime.now().toIso8601String(),
        }),
      );

      if (history.length > _maxHistory) {
        history.removeAt(0);
      }

      await prefs.setStringList(_memoryKey, history);
    } catch (e) {
      print('❌ Error saving chat history: $e');
    }
  }

  // 📥 جلب تاريخ المحادثة - النسخة المعدلة
  static Future<List<Map<String, dynamic>>> _getChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> history = prefs.getStringList(_memoryKey) ?? [];

      final List<Map<String, dynamic>> result = [];

      for (var item in history) {
        try {
          final decoded = jsonDecode(item);
          if (decoded is Map<String, dynamic>) {
            // ✅ تأكد من وجود المفاتيح الأساسية
            result.add({
              'user': decoded['user'] ?? '',
              'bot': decoded['bot'] ?? '',
              'time': decoded['time'] ?? '',
            });
          }
        } catch (_) {
          // ❌ تخطي العناصر التي لا يمكن فك تشفيرها
          continue;
        }
      }

      return result;
    } catch (e) {
      print('❌ Error loading chat history: $e');
      return [];
    }
  }

  // 🧪 اختبار الاتصال بالـ Webhook
  static Future<bool> testConnection() async {
    try {
      final response = await http
          .post(
            Uri.parse(_webhookUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'message': 'ping', 'test': true}),
          )
          .timeout(const Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // 🗑️ مسح تاريخ المحادثة
  static Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_memoryKey);
    } catch (e) {
      print('❌ Error clearing history: $e');
    }
  }

  // 📊 جلب إحصائيات المحادثة
  static Future<Map<String, dynamic>> getStats() async {
    try {
      final history = await _getChatHistory();
      return {
        'totalMessages': history.length * 2,
        'conversations': history.length,
        'lastChat': history.isNotEmpty ? history.last['time'] : null,
      };
    } catch (e) {
      return {'totalMessages': 0, 'conversations': 0, 'lastChat': null};
    }
  }
}
