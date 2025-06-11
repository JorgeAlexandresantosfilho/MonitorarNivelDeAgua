import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  static Future<UserModel?> getUserData(String login) async {
    final response = await http.get(
      Uri.parse('http://192.168.80.113:3000/monitoapi/usuarios/$login'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data);
    } else {
      return null;
    }
  }
  static Future<bool> deleteUser(int id) async {
  final response = await http.delete(
    Uri.parse('http://192.168.80.113:3000/monitoapi/usuarios/$id'),
  );

  return response.statusCode == 200;
}
}
