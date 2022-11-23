import 'dart:convert';
import 'dart:io';

import 'package:dropdown_aninhado/models/post.dart';
import 'package:http/http.dart' as http;

class PostRepository {
  static Future<List<Post>> fetchPosts(int userId) async {
    final url =
        Uri.parse('https://jsonplaceholder.typicode.com/posts?userId=$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as List;
        return Future.delayed(
            const Duration(seconds: 2),
            () =>
                jsonResponse.map<Post>((json) => Post.fromMap(json)).toList());
        // return jsonResponse.map<Post>((json) => Post.fromMap(json)).toList();
      } else {
        throw Exception('Erro ao buscar os posts');
      }
    } on HttpException {
      throw Exception('Erro na requisição');
    } catch (e) {
      throw Exception(e);
    }
  }
}
