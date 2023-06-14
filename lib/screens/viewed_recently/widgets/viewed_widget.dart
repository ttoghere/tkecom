// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:tkecom/consts/firebase_contants.dart';
import 'package:tkecom/inner_screens/inner_screens_shelf.dart';
import 'package:tkecom/models/recently_viewed_model.dart';
import 'package:tkecom/provider/cart_provider.dart';
import 'package:tkecom/provider/products_provider.dart';
import 'package:tkecom/services/services_shelf.dart';
import 'package:tkecom/widgets/widgets_shelf.dart';

class ViewedRecentlyWidget extends StatefulWidget {
  const ViewedRecentlyWidget({Key? key}) : super(key: key);

  @override
  _ViewedRecentlyWidgetState createState() => _ViewedRecentlyWidgetState();
}

class _ViewedRecentlyWidgetState extends State<ViewedRecentlyWidget> {
  @override
  Widget build(BuildContext context) {
    Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductsProvider>(context);
    final viewedProdModel = Provider.of<RecentlyViewedModel>(context);
    final getCurrentProduct =
        productProvider.findProdById(productId: viewedProdModel.productId);
    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart =
        cartProvider.getCartItems.containsKey(getCurrentProduct.id);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(ProductDetails.routeName,
              arguments: getCurrentProduct.id);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FancyShimmerImage(
              imageUrl: getCurrentProduct.imageUrl,
              boxFit: BoxFit.fill,
              height: size.width * 0.27,
              width: size.width * 0.25,
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: TextWidget(
                    text: getCurrentProduct.title,
                    color: color,
                    textSize: 20,
                    isTitle: true,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextWidget(
                  text: '\$${usedPrice.toStringAsFixed(2)}',
                  color: color,
                  textSize: 16,
                  isTitle: false,
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Material(
                borderRadius: BorderRadius.circular(12),
                color: Colors.green,
                child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _isInCart
                        ? null
                        : () {
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
                            cartProvider.addProductsToCart(
                                productId: getCurrentProduct.id, quantity: 1);
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        _isInCart ? Icons.check : IconlyBold.plus,
                        color: Colors.white,
                        size: 20,
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
