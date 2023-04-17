import 'dart:convert';
import 'dart:io';

import 'package:bot_chat_app/constants/constants.dart';
import 'package:http/http.dart' as http;

class ApiHandler {
  static Future<Map<String, dynamic>> getResponse(String prompt) async {
    try {
      final response = await http.post(
        Constants.apiLink,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.apiSecretKey}'
        },
        body: jsonEncode({
          "model": Constants.apiModel,
          "messages": [
            {"role": "user", "content": prompt}
          ]
        }),
      );

      var result =
          jsonDecode(response.body)['choices'][0]['message']['content'];

      bool success = true;
      if (result == null) {
        success = false;
        result = 'Some error occurred';
      }
      return _buildMap(result, success);
    } on SocketException {
      return _buildMap('Please check you internet connection', false);
    } catch (e) {
      return _buildMap(e.toString(), false);
    }
  }

  static Map<String, dynamic> _buildMap(String prompt, bool success) {
    return {'message': prompt, 'success': success};
  }
}
