import 'dart:convert';

import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
import 'package:http/http.dart' as http;

class ConnectTelegram {
  // static final ConnectTelegram instance = ConnectTelegram._();

  // ConnectTelegram._();

// ضع هنا التوكن الخاص بالبوت الذي حصلت عليه من BotFather
  final String botToken = '7858685883:AAFSUbPIUt38GItU3Wl1JPOvZrDWaCvG_RA';
// معرف المستخدم الذي تريد إرسال الرسالة له (Chat ID)

  final String chatId = '505765472';

  final String message = 'احمد شاكر';
  Future<void> sendMessage() async {
    final String apiUrl1 = 'https://api.telegram.org/bot$botToken/getUpdates';
    final String apiUrl =
        'https://api.telegram.org/bot$botToken/sendMessage?chat_id=$chatId&text=$message';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      print('Message sent successfully!');
    } else {
      print('Failed to send message: ${response.body}');
    }
  }

  Future<void> getUpdates() async {
    final String apiUrl1 = 'https://api.telegram.org/bot$botToken/getUpdates';

    final response = await http.get(Uri.parse(apiUrl1));

    if (response.statusCode == 200) {
      final updates = jsonDecode(response.body);
      Logger.logger('message : -- ${updates['result']}');
      // تحليل الرسائل واستعراض Chat ID والنص
      if (updates['result'].isNotEmpty) {
        for (var update in updates['result']) {
          var chatId = update['message']['chat']['id'];
          var messageText = update['message']['text'];
          print('Chat ID: $chatId');
          print('Message: $messageText');
        }
      } else {
        print('No updates found.');
      }
    } else {
      print('Failed to get updates: ${response.statusCode}');
    }
  }
}
