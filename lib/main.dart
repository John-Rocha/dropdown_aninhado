import 'package:dropdown_aninhado/models/post.dart';
import 'package:dropdown_aninhado/repositories/post_repository.dart';
import 'package:dropdown_aninhado/repositories/user_repository.dart';
import 'package:flutter/material.dart';

import 'models/user.dart';

Future<void> main() async {
  // print(await PostRepository.fetchPosts(2));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const DropDownExample(),
    );
  }
}

class DropDownExample extends StatefulWidget {
  const DropDownExample({super.key});

  @override
  State<DropDownExample> createState() => _DropDownExampleState();
}

class _DropDownExampleState extends State<DropDownExample> {
  List<User> users = [];
  List<Post> posts = [];
  User? userDropdownValue;
  Post? postsDropdownValue;
  bool isLoadingUsers = false;
  bool isLoadingError = false;

  @override
  void initState() {
    super.initState();
    fetchUsersDropDown();
  }

  Future<void> fetchUsersDropDown() async {
    isLoadingUsers = true;
    await UserRepository.fetchUsers().then((user) {
      setState(() {
        users = user;
        isLoadingUsers = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        isLoadingUsers = false;
        isLoadingError = true;
      });
    });
  }

  Future<void> fetchPostsDropDown(int userId) async {
    _buildShowDialog(context);
    await PostRepository.fetchPosts(userId).then((post) {
      setState(() {
        posts = post;
        postsDropdownValue = posts.first;
        Navigator.of(context).pop();
      });
    }).onError((error, stackTracer) {
      setState(() {
        Navigator.of(context).pop();
        isLoadingError = true;
      });
      _buildErrorShowDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dependent DropDown'),
        actions: [
          IconButton(
            onPressed: () async => fetchUsersDropDown(),
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Center(
        child: isLoadingUsers
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : isLoadingError
                ? const Center(
                    child: Text('Erro ao carregar dados :('),
                  )
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButton(
                          isExpanded: true,
                          hint: const Text('Escolha um usuário'),
                          value: userDropdownValue,
                          alignment: AlignmentDirectional.center,
                          items: users
                              .map<DropdownMenuItem<User>>(
                                  (user) => DropdownMenuItem<User>(
                                        value: user,
                                        child: Text(user.name),
                                      ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              userDropdownValue = value!;
                              fetchPostsDropDown(value.id);
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        DropdownButton(
                          isExpanded: true,
                          hint: const Text('Posts'),
                          value: postsDropdownValue,
                          alignment: AlignmentDirectional.center,
                          items: posts
                              .map<DropdownMenuItem<Post>>(
                                  (post) => DropdownMenuItem<Post>(
                                        value: post,
                                        child: Text(post.title),
                                      ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              postsDropdownValue = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Future<void> _buildErrorShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ops!!!'),
        content: const Text('Erro ao buscar os posts deste usuário!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ok'),
          )
        ],
      ),
    );
  }
}

Future<void> _buildShowDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}
