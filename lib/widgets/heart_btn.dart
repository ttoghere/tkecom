// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:tkecom/consts/firebase_contants.dart';
import 'package:tkecom/provider/products_provider.dart';

import 'package:tkecom/provider/wishlist_provider.dart';
import 'package:tkecom/screens/auth/auth_shelf.dart';
import 'package:tkecom/services/global_methods.dart';

import '../services/utils.dart';

class HeartBTN extends StatelessWidget {
  final String productId;
  final bool? isInWishlist;
  const HeartBTN({
    Key? key,
    required this.productId,
    this.isInWishlist = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrProduct = productProvider.findProdById(productId: productId);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final Color color = Utils(context).color;
    return GestureDetector(
      onTap: () async {
        try {
          final User? user = authInstance.currentUser;
          if (user == null) {
            GlobalMethods.warningDialog(
                title: "User is not availible",
                subtitle: "Please login to your account",
                fct: () {
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                },
                context: context);
            return;
          }
          if (isInWishlist == false && isInWishlist != null) {
            await GlobalMethods.addToWishlist(
                productId: productId, context: context);
          } else {
            await wishlistProvider.removeOneItem(
                wishlistId:
                    wishlistProvider.wishlistItems[getCurrProduct.id]!.id,
                productId: productId);
          }
          await wishlistProvider.fetchWishlist();
        } catch (error) {
          GlobalMethods.warningDialog(
              title: "An Error Occured",
              subtitle: "Error: $error",
              fct: () {
                Navigator.of(context).pop();
              },
              context: context);
        } finally {}
      },
      child: Icon(
        isInWishlist != null && isInWishlist == true
            ? IconlyBold.heart
            : IconlyLight.heart,
        size: 22,
        color: isInWishlist != null && isInWishlist == true
            ? Colors.red[900]
            : color,
      ),
    );
  }
}
