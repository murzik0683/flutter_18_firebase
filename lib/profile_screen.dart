import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_18_firebase/firebase_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var username = '';
  var notes = <String>[];

  @override
  void initState() {
    super.initState();
    _initUsername();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          TextButton(
            onPressed: () {
              FirebaseHelper.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Center(child: Text('Hello, $username!')),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(notes[i]),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _initUsername() async {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';
    setState(() {
      username = email;
    });
  }

  Future _showDialog() => showGeneralDialog(
        context: context,
        barrierDismissible: false,
        pageBuilder: (_, __, ___) {
          final nameController = TextEditingController();
          return AlertDialog(
            title: const Text('New note'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Name'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final note = nameController.text;
                  FirebaseHelper.write(note);
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              )
            ],
          );
        },
      );

  void _initData() {
    FirebaseHelper.getNotes().listen((event) {
      final map = event.snapshot.value as Map<dynamic, dynamic>?;
      if (map != null) {
        setState(() {
          notes = map.values.map((e) => e as String).toList();
        });
      }
    });
  }
}
