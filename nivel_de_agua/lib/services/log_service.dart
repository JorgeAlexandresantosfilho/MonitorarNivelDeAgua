import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/log_model.dart';

class LogService {
  static Future<List<LogModel>> getLogsByLogin(String login) async {
    final response = await http.get(
      Uri.parse('https://backendprojetouninassau-production.up.railway.app/monitoapi/log/usuario/$login'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => LogModel.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao buscar logs');
    }
  }
}
