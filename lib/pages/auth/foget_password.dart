import 'package:advanc_task_10/utils/color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_auth.provider.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword>
    with AutomaticKeepAliveClientMixin {
  // bool isPressed = false;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        backgroundColor: ColorsUtil.badgeColor,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Consumer<AppAuthProvider>(
            builder: (ctx, appAuthProvider, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 30,
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 60.0),
                          child: Column(
                            children: [
                              Text(
                                "Enter the email address you used to ",
                                style: TextStyle(
                                    color: Color(0xff515C6F), fontSize: 17),
                              ),
                              Text(
                                "your account and we will email you a link to ",
                                style: TextStyle(
                                    color: Color(0xff515C6F), fontSize: 15),
                              ),
                              Center(
                                child: Text(
                                  "reset your password",
                                  style: TextStyle(
                                      color: Color(0xff515C6F), fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(20),
                            height: 90,
                            width: 350,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 251, 253),
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                          labelText: "EMAIL",
                                          labelStyle: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff727C8E),
                                          ),
                                          hintText: "aalaahesha1@mail.com",
                                          icon: Icon(Icons.mail_outline,
                                              color: Color(0xFF3F3D56)),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      padding: const EdgeInsets.all(8),
                      height: 70,
                      width: 350,
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xffFF6969),
                          //padding: const EdgeInsets.all(16.0),
                          textStyle: const TextStyle(fontSize: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                                email: emailController?.text ?? '');
                          } catch (e) {
                            print('>>>>${e}');
                          }
                        },
                        child: const Row(
                          children: [
                            SizedBox(
                              width: 100,
                            ),
                            Center(
                                child: Text(
                              'SEND EMAIL',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            )),
                            SizedBox(
                              width: 100,
                            ),
                            Expanded(
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.arrow_right,
                                  color: Colors.red,
                                  weight: 100,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
