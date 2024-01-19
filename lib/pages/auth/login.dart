import 'package:advanc_task_10/providers/app_auth.provider.dart';
import 'package:advanc_task_10/utils/color_utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    Provider.of<AppAuthProvider>(context, listen: false).init();
  }

// dispose before Decactivate precede dispose
  @override
  void deactivate() {
    Provider.of<AppAuthProvider>(context, listen: false).providerDispose();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: ColorsUtil.badgeColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Consumer<AppAuthProvider>(builder: (ctx, appAuthProvider, _) {
          return Form(
            key: appAuthProvider.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 30,
                  ),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(20),
                      height: 150,
                      width: 350,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 251, 253),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: appAuthProvider.emailController,
                              validator: (value) {
                                if (value == null || value == '') {
                                  return 'email is required';
                                }
                                if (!EmailValidator.validate(value)) {
                                  return 'Enter Valid Email';
                                } else {
                                  if (!value
                                      .split('@')
                                      .last
                                      .contains('gmail')) {
                                    return 'Enter Valid Gmail';
                                  }
                                }
                                return null;
                              },
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
                            const SizedBox(height: 12.0),
                            Expanded(
                              child: TextFormField(
                                controller: appAuthProvider.passwordController,
                                obscureText: appAuthProvider.obscureText,
                                validator: (value) {
                                  if (value == null || value == '') {
                                    return 'password is required';
                                  }
                                  if (value.length < 8) {
                                    return 'Password length must be 8';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        appAuthProvider.toggleObscure();
                                      },
                                      child: appAuthProvider.obscureText
                                          ? const Icon(Icons.visibility_off)
                                          : const Icon(Icons.visibility),
                                    ),
                                    labelText: "Password",
                                    labelStyle: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff727C8E),
                                    ),
                                    hintText: "aalaahesham 789",
                                    icon: Icon(Icons.person_outline,
                                        color: ColorsUtil.iconColor),
                                    border: InputBorder.none),
                              ),
                            ),
                          ]),
                    ),
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
                        await appAuthProvider.login(context);
                      },
                      child: const Row(
                        children: [
                          SizedBox(
                            width: 100,
                          ),
                          Center(child: Text('Log In')),
                          SizedBox(
                            width: 100,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.arrow_right,
                              color: Colors.red,
                              weight: 100,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    const Text(
                      "Don/’t have an account? Swipe right to ",
                      style: TextStyle(color: Color(0xff515C6F), fontSize: 12),
                    ),
                    InkWell(
                      onTap: () => appAuthProvider.openSignupPage(context),
                      child: const Text(
                        "create a new account.",
                        style:
                            TextStyle(color: Color(0xffFF6969), fontSize: 12),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
