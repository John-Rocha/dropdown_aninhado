import 'dart:convert';
import 'dart:io';

import '../models/user.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  static Future<List<User>> fetchUsers() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/users');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as List;
        // return Future.delayed(const Duration(seconds: 3),
        //     (() => throw Exception('Erro ao buscar os usuários')));
        return Future.delayed(
          const Duration(seconds: 3),
          (() => jsonResponse.map<User>((user) => User.fromMap(user)).toList()),
        );
        // return jsonResponse.map<User>((user) => User.fromMap(user)).toList();
      } else {
        throw Exception('Erro ao buscar os usuários');
      }
    } on HttpException {
      throw Exception('Erro na requisição');
    } catch (e) {
      throw Exception(e);
    }
  }
}
