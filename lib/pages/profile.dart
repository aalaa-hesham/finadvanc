import 'package:advanc_task_10/providers/app_auth.provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final usercollection = FirebaseFirestore.instance.collection("users");
  final currentUser = FirebaseAuth.instance.currentUser!;
  String userName = '';
  Future<void> editfield(
    String field,
    String phone,
    String address,
    String age,
  ) async {
    String newField = field;
    String newPhone = phone;
    String newAddress = address;
    String newAge = age;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 55, 53, 53),
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
        content: Container(
          height: 400,
          width: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: "Enter username",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {
                  newField = value;
                },
              ),
              TextField(
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: "Enter phone",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {
                  newPhone = value;
                },
              ),
              TextField(
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: "Enter address",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {
                  newAddress = value;
                },
              ),
              Container(
                height: 20,
                child: TextField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: "Enter age",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  onChanged: (value) {
                    newAge = value;
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              final Map<String, dynamic> changes = {};

              if (newField.trim().length > 0) {
                changes['username'] = newField;
              }
              if (newPhone.trim().length > 0) {
                changes['phone'] = newPhone;
              }
              if (newAddress.trim().length > 0) {
                changes['address'] = newAddress;
              }
              if (newAge.trim().length > 0) {
                changes['age'] = newAge;
              }

              if (changes.isNotEmpty) {
                usercollection.doc(currentUser.email).update(changes);
              }

              Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  void fetchUserName() async {
    var snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.email)
        .get();
    setState(() {
      userName = snapshot.data()?['username'];
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.cyan,
                        child: InkWell(
                          onTap: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              withData: true,
                              type: FileType.image,
                            );
                            var refrence = FirebaseStorage.instance
                                .ref('products/${result?.files.first.name}');

                            if (result?.files.first.bytes != null) {
                              var uploadResult = await refrence.putData(
                                  result!.files.first.bytes!,
                                  SettableMetadata(contentType: 'image/png'));

                              if (uploadResult.state == TaskState.success) {
                                print(
                                    '>>>>>>>>>>>>>>>>${await refrence.getDownloadURL()}');
                              }
                            }
                          },
                          child: Icon(Icons.camera_alt_outlined),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        userData['username'],
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 20),
                        softWrap: true,
                      ),
                      Text(
                        currentUser.email!,
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () => editfield(
                          userData['username'],
                          userData['phone'],
                          userData['address'],
                          userData['age'],
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor:
                              const Color.fromARGB(255, 237, 235, 235),
                          shadowColor: Theme.of(context).primaryColor,
                          fixedSize: const Size(150, 50),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Edit profile",
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 240, 238, 238),
                ),
                padding: EdgeInsets.only(left: 15, bottom: 15),
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Center(
                        child: Text(
                          'My Detail',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("username"),
                    Text(
                      userData['username'],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 20),
                      softWrap: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("age"),
                    Text(
                      userData['age'],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 20),
                      softWrap: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("address"),
                    Text(
                      userData['address'],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 20),
                      softWrap: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("phone"),
                    Text(
                      userData['phone'],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 20),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () =>
                      Provider.of<AppAuthProvider>(context, listen: false)
                          .onLogout(context),
                  child: const Text('LogOut')),
            ]);
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return CircularProgressIndicator();
        },
      ),
    ));
  }
}
