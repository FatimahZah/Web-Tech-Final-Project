import 'package:flutter/material.dart';

class ViewProfilePage extends StatelessWidget {
  final String studentId;
  final String name;
  final String email;
  final String dateOfBirth;
  final String yearGroup;
  final String major;
  final bool hasCampusResidence;
  final String bestFood;
  final String bestMovie;

  const ViewProfilePage({
    Key? key,
    required this.studentId,
    required this.name,
    required this.email,
    required this.dateOfBirth,
    required this.yearGroup,
    required this.major,
    required this.hasCampusResidence,
    required this.bestFood,
    required this.bestMovie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text('View Profile'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Your Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 40),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('32992024'),
              subtitle: Text(studentId),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Fatimata Issifu'),
              subtitle: Text(name),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: Text(email),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.cake),
              title: const Text('date'),
              subtitle: Text(dateOfBirth),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('group'),
              subtitle: Text(yearGroup),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('major'),
              subtitle: Text(major),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Campus Residence'),
              subtitle: Text(hasCampusResidence ? 'Yes' : 'No'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.food_bank),
              title: const Text('best food'),
              subtitle: Text(bestFood),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('bestMovie'),
              subtitle: Text(bestMovie),
            ),
          ],
        ),
      ),
    );
  }
}
