// ignore_for_file: depend_on_referenced_packages, unused_import, unused_element, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;



class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final logger = Logger();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Add any other validation checks for email format
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _postController,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'What would you like to share?',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a post';
                  }
                  // Add any other validation checks for post length, etc.
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save post to database or send to server
                    final email = _emailController.text;
                    final post = _postController.text;
                    // Implement saving or sending logic here
                    void _handleSubmit() async {
                      if (_formKey.currentState!.validate()) {
                        final email = _emailController.text;
                        final post = _postController.text;

                        final response = await http.post(
                          Uri.parse(' http://127.0.0.1:5000/posts'),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                          body: jsonEncode(<String, dynamic>{
                            'email': email,
                            'content': post,
                          }),
                        );

                        if (response.statusCode == 201) {
                          // Show snackbar to confirm post creation
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Post created successfully!'),
                            ),
                          );
                          // Clear form fields
                          _emailController.clear();
                          _postController.clear();
                        } else {
                          throw Exception('Failed to create post');
                        }
                      }
                    }

                    logger.info('Email: $email');
                    logger.info('Post: $post');
                    // Show snackbar to confirm post creation
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Post created successfully!'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Logger {
  void info(String s) {}
}

