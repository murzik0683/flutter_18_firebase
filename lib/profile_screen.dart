import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_18_firebase/firebase_helper.dart';
import 'package:flutter_18_firebase/login_screen.dart';
import 'package:flutter_18_firebase/widget/text_button_class.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var username = '';
  var useremail = '';
  var usernumber = '';
  var notes = <String>[];
  var message = '';

  @override
  void initState() {
    super.initState();
    _initUserData();

    //_initData();
    _initData2();
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
              //Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            onPressed: () {
              _showDialogDelete();
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
            const SizedBox(height: 24),
            Column(
              children: [
                Center(child: Text('Hello, $username!')),
                Center(child: Text('Hello, $useremail!')),
                // Center(child: Text('Hello, ${usernumber}!')),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
                child: notes.length != 0
                    ? ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (_, i) => Card(
                          elevation: 4,
                          child: ListTile(
                            title: Text(notes[i]),
                            trailing: SizedBox(
                                width: 100,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () {
                                          _showDialogUpdate(i, notes[i]);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.blue),
                                        onPressed: () {
                                          setState(() {
                                            FirebaseHelper.delete(
                                                notes.removeAt(i));
                                          });
                                        },
                                      ),
                                    ])),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 70),
                        child: Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: const Center(
                                child: Text("Sorry No Notes found"))),
                      )),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 1,
            onPressed: () {
              _showDialog();
            },
            child: const Icon(Icons.add),
          ),
          // FloatingActionButton(
          //   heroTag: 2,
          //   onPressed: () {
          //     _showMsgDialog();
          //   },
          //   child: const Icon(Icons.message),
          // ),
        ],
      ),
    );
  }

  Future<void> _initUserData() async {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';
    final name = FirebaseAuth.instance.currentUser?.displayName ?? '';
    final number = FirebaseAuth.instance.currentUser?.phoneNumber ?? '';
    setState(() {
      useremail = email;
      username = name;
      usernumber = number;
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
  Future _showDialogDelete() => showGeneralDialog(
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
  Future _showDialogUpdate(i, String newNote) => showGeneralDialog(
        context: context,
        barrierDismissible: false,
        pageBuilder: (_, __, ___) {
          final nameController = TextEditingController();
          return AlertDialog(
            title: const Text('Edit note'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: notes[i]),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  /////////////////////////////////////////////////
                  final newNote = nameController.text;
                  FirebaseHelper.delete(notes.removeAt(i));
                  FirebaseHelper.write(newNote);
                  Navigator.pop(context);
                },
                child: const Text('Edit'),
              )
            ],
          );
        },
      );

  void _initData() {
    FirebaseHelper.getNotes().listen((event) {
      final map = event.snapshot.value as Map<dynamic, dynamic>?;
      if (map != null) {
        if (mounted) {
          setState(() {
            notes = map.values.map((e) => e as String).toList();
          });
        }
      }
    });
  }

  void _initData2() {
    FirebaseHelper.getNotes().listen((event) {
      final map = event.snapshot.value as Map<dynamic, dynamic>?;
      if (map != null) {
        if (mounted) {
          setState(() {
            notes = map.values.map((e) => e as String).toList();
          });
        }
      }
    });

    FirebaseHelper.readMessage().listen((event) {
      final value = event.snapshot.value as String?;
      if (value != null) {
        if (mounted) {
          setState(() {
            message = value;
          });
        }
      }
    });
  }

  void _showMsgDialog() => showGeneralDialog(
        context: context,
        barrierDismissible: false,
        pageBuilder: (_, __, ___) {
          final messageController = TextEditingController();
          return AlertDialog(
            title: const Text('New message'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: messageController,
                  decoration: const InputDecoration(hintText: 'Message'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final message = messageController.text;
                  FirebaseHelper.writeMessage(message);
                  Navigator.pop(context);
                },
                child: const Text('Send'),
              )
            ],
          );
        },
      );
}

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   String? name;
//   String? eMail;
//   @override

//   \

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: const Color(0xFFC3DFF6),
//     appBar: AppBar(
//       title: Text('Profile  $name'),
//       centerTitle: true,
//     ),
//     body: SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           const SizedBox(height: 20),
//           Stack(
//             children: const [
//               CircleAvatar(
//                 radius: 93,
//                 backgroundColor: Colors.blue,
//                 child: CircleAvatar(
//                   backgroundImage: NetworkImage(
//                       'https://phonoteka.org/uploads/posts/2021-05/1621965253_31-phonoteka_org-p-kotiki-art-krasivo-32.jpg'),
//                   radius: 90,
//                 ),
//               ),
//               Positioned(
//                 right: 2,
//                 top: 2,
//                 child: CircleAvatar(
//                   backgroundColor: Colors.white,
//                   radius: 25,
//                   child: Icon(
//                     Icons.create_rounded,
//                     color: Colors.blue,
//                   ),
//                 ),
//               )
//             ],
//           ),
//           const SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.only(left: 20, right: 20),
//             child: TextField(
//               controller: TextEditingController(text: name),
//               style: const TextStyle(fontSize: 20),
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 fillColor: Colors.white,
//                 filled: true,
//                 labelText: 'Name',
//                 suffixIcon: Icon(Icons.arrow_forward_ios),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.only(left: 20, right: 20),
//             child: TextField(
//               controller: TextEditingController(text: eMail),
//               style: const TextStyle(fontSize: 20),
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 fillColor: Colors.white,
//                 filled: true,
//                 labelText: 'E-mail',
//                 suffixIcon: Icon(Icons.arrow_forward_ios),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.only(left: 20, right: 20),
//             child: TextField(
//               controller: TextEditingController(),
//               maxLines: 5,
//               style: const TextStyle(fontSize: 20),
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 fillColor: Colors.white,
//                 filled: true,
//                 labelText: 'Tell us about yourself',
//                 suffixIcon: IconButton(
//                     onPressed: (() {
//                       setState(() {});
//                       TextEditingController().clear();
//                     }),
//                     icon: const Icon(Icons.close)),
//               ),
//             ),
//           ),
//           const SizedBox(height: 30),
//           // ListTile(
//           //   leading: Text('Name: $name'),
//           //   shape: const Border(
//           //     bottom: BorderSide(),
//           //   ),
//           //   trailing: const Icon(Icons.arrow_forward_ios),
//           // ),
//           // Text.rich(
//           //   textAlign: TextAlign.left,
//           //   TextSpan(
//           //     text: 'Name:    ',
//           //     style: const TextStyle(fontSize: 35),
//           //     children: <TextSpan>[
//           //       TextSpan(
//           //         text: '$name',
//           //         style: const TextStyle(
//           //           decoration: TextDecoration.underline,
//           //         ),
//           //       ),
//           //     ],
//           //   ),
//           // ),
//           TextButtonClass(
//             title: 'Exit',
//             function: () {
//               Get.offAll(() => const LoginScreen());
//             },
//           ),
//         ],
//       ),
//     ),
//   );
// }
// }
