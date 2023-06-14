// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:tkecom/consts/firebase_contants.dart';
import 'package:tkecom/provider/auth_provider.dart';
import 'package:tkecom/provider/provider_shelf.dart';
import 'package:tkecom/screens/screens_shelf.dart';
import 'package:tkecom/screens/user/widgets/widgets_shelf.dart';
import 'package:tkecom/services/services_shelf.dart';
import 'package:tkecom/widgets/loading_manager.dart';
import 'package:tkecom/widgets/widgets_shelf.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressTextController =
      TextEditingController(text: "");
  bool isLoading = false;
  String? email;
  String? name;
  String? address;

  @override
  void dispose() {
    _addressTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    setState(() {
      isLoading = true;
    });
    if (user == null) {
      return;
    }
    try {
      String uid = user!.uid;
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      email = userDoc.get("email");
      name = userDoc.get("name");
      address = userDoc.get("shipping-address");
      _addressTextController.text = userDoc.get("shipping-address");
    } catch (e) {
      GlobalMethods.warningDialog(
        title: "An error occured",
        subtitle: "Error: $e",
        fct: () {
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        },
        context: context,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
        body: LoadingManager(
      isLoading: isLoading,
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 15,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Hi,  ',
                    style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: name ?? "User",
                          style: TextStyle(
                            color: color,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              log('My name is pressed');
                            }),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextWidget(
                  text: email ?? "Email",
                  color: color,
                  textSize: 18,
                  // isTitle: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  thickness: 2,
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTiles(
                  title: "Address",
                  subtitle: address ?? 'My subtitle',
                  icon: IconlyLight.profile,
                  onPressed: () async {
                    await _showAddressDialog();
                  },
                  color: color,
                ),
                ListTiles(
                  title: 'Orders',
                  icon: IconlyLight.bag,
                  onPressed: () {
                    GlobalMethods.navigateTo(
                        ctx: context, routeName: OrdersScreen.routeName);
                  },
                  color: color,
                ),
                ListTiles(
                  title: 'Wishlist',
                  icon: IconlyLight.heart,
                  onPressed: () {
                    GlobalMethods.navigateTo(
                        ctx: context, routeName: WishlistScreen.routeName);
                  },
                  color: color,
                ),
                ListTiles(
                  title: 'Viewed',
                  icon: IconlyLight.show,
                  onPressed: () {
                    GlobalMethods.navigateTo(
                        ctx: context,
                        routeName: ViewedRecentlyScreen.routeName);
                  },
                  color: color,
                ),
                ListTiles(
                  title: 'Forget password',
                  icon: IconlyLight.unlock,
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(ForgetPasswordScreen.routeName);
                  },
                  color: color,
                ),
                SwitchListTile(
                  title: TextWidget(
                    text: themeState.getDarkTheme ? 'Dark mode' : 'Light mode',
                    color: color,
                    textSize: 18,
                    // isTitle: true,
                  ),
                  secondary: Icon(themeState.getDarkTheme
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined),
                  onChanged: (bool value) {
                    setState(() {
                      themeState.setDarkTheme = value;
                    });
                  },
                  value: themeState.getDarkTheme,
                ),
                ListTiles(
                  title: user == null ? 'Sign In' : 'Logout',
                  icon: user == null ? IconlyLight.login : IconlyLight.logout,
                  onPressed: user == null
                      ? () => Navigator.of(context)
                          .pushReplacementNamed(RegisterScreen.routeName)
                      : () {
                          GlobalMethods.warningDialog(
                              title: 'Sign out',
                              subtitle: 'Do you wanna sign out?',
                              fct: () {
                                authProvider.signOut();

                                Navigator.of(context).pushReplacementNamed(
                                    LoginScreen.routeName);
                              },
                              context: context);
                        },
                  color: color,
                ),
                // listTileAsRow(),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Future<void> _showAddressDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update'),
            content: TextField(
              onChanged: (value) {
                log('_addressTextController.text ${_addressTextController.text}');
              },
              controller: _addressTextController,
              maxLines: 5,
              decoration: const InputDecoration(hintText: "Your address"),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  String uid = user!.uid;
                  try {
                    setState(() {
                      isLoading = true;
                    });
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(uid)
                        .update(
                            {"shipping-address": _addressTextController.text});
                    Navigator.of(context).pop();
                    setState(() {
                      address = _addressTextController.text;
                    });
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    GlobalMethods.warningDialog(
                        title: "An occured has been appeared",
                        subtitle: "Error: $e",
                        fct: () {
                          Navigator.of(context).pop();
                        },
                        context: context);
                  } finally {
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                child: const Text('Update'),
              ),
            ],
          );
        });
  }
}
