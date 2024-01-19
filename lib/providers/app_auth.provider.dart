import 'package:advanc_task_10/pages/auth/login.dart';
import 'package:advanc_task_10/pages/auth/signup.dart';
import 'package:advanc_task_10/pages/master_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppAuthProvider extends ChangeNotifier {
  GlobalKey<FormState>? formKey;
  TextEditingController? emailController;
  TextEditingController? passwordController;
  bool obscureText = true;

  void init() async {
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  void providerDispose() {
    emailController = null;
    passwordController = null;
    formKey = null;
  }

  void toggleObscure() {
    obscureText = !obscureText;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    if ((formKey?.currentState?.validate() ?? false)) {
      try {
        QuickAlert.show(context: context, type: QuickAlertType.loading);
        var credintials = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController?.text ?? '',
                password: passwordController?.text ?? '');
        if (context.mounted) {
          Navigator.pop(context);
          if (credintials.user != null) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const MasterPage()));
            providerDispose();
          } else {
            await QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                title: 'Error In Signup');
          }
        }
      } on FirebaseAuthException catch (e) {
        if (!context.mounted) return;
        Navigator.pop(context);

        if (e.code == 'user-not-found') {
          await QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'user not found');
        } else if (e.code == 'wrong-password') {
          await QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'wrong password');
        } else {
          await QuickAlert.show(
              context: context, type: QuickAlertType.error, title: e.code);
        }
      } catch (e) {
        if (!context.mounted) return;
        Navigator.pop(context);

        await QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Login Error $e');
      }
    }
  }

  Future<void> signup(BuildContext context) async {
    if ((formKey?.currentState?.validate() ?? false)) {
      try {
        QuickAlert.show(context: context, type: QuickAlertType.loading);

        UserCredential credintials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController?.text ?? '',
                password: passwordController?.text ?? '');
        FirebaseFirestore.instance
            .collection("users")
            .doc(credintials.user!.email)
            .set({
          'username': emailController?.text.split("@")[0],
          'address': 'hkkl',
          'age': '67',
          'phone': '0000',
        });

        if (context.mounted) {
          Navigator.pop(context);
          if (credintials.user != null) {
            await QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                title: 'You Signup Successfully');

            if (context.mounted) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const MasterPage()));
              providerDispose();
            }
          } else {
            await QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                title: 'Error In Signup');
          }
        }
      } on FirebaseAuthException catch (e) {
        if (!context.mounted) return;
        Navigator.pop(context);
        if (e.code == 'email-already-in-use') {
          await QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'This Email Already in use');
        } else if (e.code == 'weak-password') {
          await QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'Weak Password');
        }
      } catch (e) {
        if (!context.mounted) return;
        Navigator.pop(context);

        await QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Signup Error $e');
      }
    }
  }

  Future<void> onLogout(BuildContext contextEx) async {
    QuickAlert.show(context: contextEx, type: QuickAlertType.loading);

    await Future.delayed(const Duration(milliseconds: 300));

    await FirebaseAuth.instance.signOut();
    await GetIt.I.get<SharedPreferences>().clear();
    Navigator.pop(contextEx);
    Navigator.pushReplacement(
        contextEx, MaterialPageRoute(builder: (_) => const Login()));
  }

  void openSignupPage(BuildContext context) {
    providerDispose();
    if (context.mounted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const Signup()));
    }
  }

  // Future<void> resetPassword(BuildContext context) async {
  //   if ((formKey?.currentState?.validate() ?? false)) {
  //     try {
  //       QuickAlert.show(context: context, type: QuickAlertType.loading);
  //       await FirebaseAuth.instance.sendPasswordResetEmail(
  //         email: emailController?.text ?? '',
  //       );
  //       if (context.mounted) {
  //         Navigator.pop(context);
  //         await QuickAlert.show(
  //           context: context,
  //           type: QuickAlertType.success,
  //           title: 'Password reset email sent',
  //         );
  //       }
  //     } on FirebaseAuthException catch (e) {
  //       if (!context.mounted) return;
  //       Navigator.pop(context);

  //       if (e.code == 'user-not-found') {
  //         await QuickAlert.show(
  //           context: context,
  //           type: QuickAlertType.error,
  //           title: 'User not found',
  //         );
  //       } else {
  //         await QuickAlert.show(
  //           context: context,
  //           type: QuickAlertType.error,
  //           title: 'Error resetting password',
  //         );
  //       }
  //     } catch (e) {
  //       if (!context.mounted) return;
  //       Navigator.pop(context);

  //       await QuickAlert.show(
  //         context: context,
  //         type: QuickAlertType.error,
  //         title: 'Error resetting password',
  //       );
  //     }
  //   }
  // }
}
