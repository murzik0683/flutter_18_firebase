import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_18_firebase/firebase_helper.dart';
import 'package:flutter_18_firebase/login_screen.dart';
import 'package:flutter_18_firebase/widget/text_button_class.dart';
import 'package:get/get.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreenStorage extends StatefulWidget {
  const ProfileScreenStorage({Key? key}) : super(key: key);

  @override
  State<ProfileScreenStorage> createState() => _ProfileScreenStorageState();
}

class _ProfileScreenStorageState extends State<ProfileScreenStorage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final CollectionReference _notes =
      FirebaseFirestore.instance.collection('notes');

  var username = '';
  var useremail = '';

  Future<void> _initUseEmail() async {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';
    setState(() {
      useremail = email;
    });
  }

  Future<void> _initUseName() async {
    final name = FirebaseAuth.instance.currentUser?.displayName ?? '';
    setState(() {
      username = name;
    });
  }

  @override
  void initState() {
    super.initState();
    _initUseEmail();
    _initUseName();
  }

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _titleController.text = documentSnapshot['title'];
      _descController.text = documentSnapshot['desc'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // предотвращение перекрытия текстовых полей мягкой клавиатурой
                bottom: MediaQuery.of(context).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String title = _titleController.text;
                    final String desc = _descController.text;
                    if (title != null && desc != null) {
                      if (action == 'create') {
                        // добавляем новую заметку в Firestore
                        _notes.add({"title": title, "desc": desc});
                      }
                      if (action == 'update') {
                        // обновить заметку
                        await _notes
                            .doc(documentSnapshot!.id)
                            .update({"title": title, "desc": desc});
                      }
                      // очистить поле
                      _titleController.text = '';
                      _descController.text = '';

                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  // удалить заметку
  Future<void> _deleteNote(String noteId) async {
    await _notes.doc(noteId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text('You have successfully deleted a note')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 213, 233, 249),
      appBar: AppBar(
        title: const Text('Profile Screen'),
        actions: [
          TextButton(
            onPressed: () {
              FirebaseHelper.logout();
              Get.offAll(() => const LoginScreen());
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            onPressed: () {
              _showDialogDeleteUser();
            },
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Stack(
              children: const [
                CircleAvatar(
                  radius: 83,
                  backgroundColor: Colors.blue,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://phonoteka.org/uploads/posts/2021-05/1621965253_31-phonoteka_org-p-kotiki-art-krasivo-32.jpg'),
                    radius: 80,
                  ),
                ),
                Positioned(
                  right: 2,
                  top: 2,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 25,
                    child: Icon(
                      Icons.create_rounded,
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Center(child: Text('Hello, $username!')),
                Center(child: Text('Hello, $useremail!')),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: _notes.snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    return ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.all(5),
                          child: ListTile(
                            title: Text(documentSnapshot['title']),
                            subtitle: Text(documentSnapshot['desc']),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () =>
                                          _createOrUpdate(documentSnapshot)),
                                  IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () =>
                                          _deleteNote(documentSnapshot.id)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future _showDialogDeleteUser() => showGeneralDialog(
        context: context,
        barrierDismissible: false,
        pageBuilder: (_, __, ___) {
          return AlertDialog(
            title: const Text('Delete your Account?'),
            actions: [
              TextButton(
                onPressed: () async {
                  FirebaseAuth.instance.currentUser?.delete();
                  Get.offAll(() => const LoginScreen());
                },
                child: const Text('Y E S'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: const Text('N O'),
              ),
            ],
          );
        },
      );
}
