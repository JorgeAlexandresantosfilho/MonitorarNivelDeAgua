import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  static Future<UserModel?> getUserData(String login) async {
    final response = await http.get(
      Uri.parse('https://backendprojetouninassau-production.up.railway.app/monitoapi/usuarios/$login'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data);
    } else {
      return null;
    }
  }
}
