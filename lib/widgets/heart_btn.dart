// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:tkecom/consts/firebase_contants.dart';

import 'package:tkecom/provider/wishlist_provider.dart';
import 'package:tkecom/services/global_methods.dart';

import '../services/utils.dart';

class HeartBTN extends StatelessWidget {
  final String productId;
  final bool isInWishlist;
  const HeartBTN({
    Key? key,
    required this.productId,
    this.isInWishlist = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final Color color = Utils(context).color;
    return GestureDetector(
      onTap: () {
        final User? user = authInstance.currentUser;
        if (user == null) {
          GlobalMethods.warningDialog(
              title: "User is not availible",
              subtitle: "Please login to your account",
              fct: () {
                Navigator.of(context).pop();
              },
              context: context);
          return;
        }
        wishlistProvider.addProductToList(productId: productId);
      },
      child: Icon(
        isInWishlist ? IconlyBold.heart : IconlyLight.heart,
        size: 22,
        color: isInWishlist ? Colors.red[900] : color,
      ),
    );
  }
}
