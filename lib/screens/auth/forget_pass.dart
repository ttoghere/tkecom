// ignore_for_file: library_private_types_in_public_api

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:tkecom/screens/auth/auth_shelf.dart';
import 'package:tkecom/services/utils.dart';
import 'package:tkecom/widgets/back_widget.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../../consts/contss.dart';
import '../../widgets/auth_button.dart';
import '../../widgets/text_widget.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const routeName = '/ForgetPasswordScreen';
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _emailTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // bool _isLoading = false;
  @override
  void dispose() {
    _emailTextController.dispose();

    super.dispose();
  }

  bool _isLoading = false;
  void _forgerPassFCT() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return null;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });
    if (isValid) {
      _formKey.currentState!.save();
      try {
        await auth.FirebaseAuth.instance
            .sendPasswordResetEmail(
              email: _emailTextController.text.toLowerCase().trim(),
            )
            .whenComplete(() => Navigator.of(context)
                .pushReplacementNamed(LoginScreen.routeName));
      } on auth.FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$e"),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      // backgroundColor: Colors.blue,
      body: Stack(
        children: [
          Swiper(
            itemBuilder: (BuildContext context, int index) {
              return Image.asset(
                Constss.authImagesPaths[index],
                fit: BoxFit.cover,
              );
            },
            autoplay: true,
            itemCount: Constss.authImagesPaths.length,

            // control: const SwiperControl(),
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                const BackWidget(),
                const SizedBox(
                  height: 20,
                ),
                TextWidget(
                  text: 'Forget password',
                  color: Colors.white,
                  textSize: 30,
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _emailTextController,
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == "" || value!.isEmpty) {
                        return "Please Enter Your Email";
                      }
                      showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                                content: Text(
                                    "Your Password Reset Link,\nHas been sent to your email!"),
                              ));
                    },
                    decoration: const InputDecoration(
                      hintText: 'Email address',
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                AuthButton(
                  buttonText: 'Reset now',
                  fct: () {
                    _forgerPassFCT();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
