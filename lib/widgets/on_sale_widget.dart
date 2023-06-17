import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:tkecom/consts/firebase_contants.dart';
import 'package:tkecom/inner_screens/inner_screens_shelf.dart';
import 'package:tkecom/models/products_model.dart';
import 'package:tkecom/provider/cart_provider.dart';
import 'package:tkecom/provider/wishlist_provider.dart';
import 'package:tkecom/screens/auth/auth_shelf.dart';
import 'package:tkecom/services/services_shelf.dart';
import 'package:tkecom/widgets/widgets_shelf.dart';

class OnSaleWidget extends StatefulWidget {
  const OnSaleWidget({Key? key}) : super(key: key);

  @override
  State<OnSaleWidget> createState() => _OnSaleWidgetState();
}

class _OnSaleWidgetState extends State<OnSaleWidget> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    // final theme = Utils(context).getTheme;
    Size size = Utils(context).getScreenSize;
    final ProductModel productModel = Provider.of<ProductModel>(context);
    final CartProvider cartProvider = Provider.of<CartProvider>(context);
    bool? isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? isInWishlist =
        wishlistProvider.wishlistItems.containsKey(productModel.id);

    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: color),
          borderRadius: BorderRadius.circular(10)),
      child: Material(
        color: Theme.of(context).cardColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetails.routeName,
                arguments: productModel.id);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FancyShimmerImage(
                        imageUrl: productModel.imageUrl,
                        height: size.width * 0.18,
                        width: size.width * 0.18,
                        boxFit: BoxFit.fill,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        children: [
                          TextWidget(
                            text: '1 ${productModel.isPiece ? "Piece" : "KG"}',
                            color: color,
                            textSize: 18,
                            isTitle: true,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final User? user = authInstance.currentUser;
                                  if (user == null) {
                                    GlobalMethods.warningDialog(
                                        title: "User is not availible",
                                        subtitle:
                                            "Please login to your account",
                                        fct: () {
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  LoginScreen.routeName);
                                        },
                                        context: context);
                                    return;
                                  }
                                  await GlobalMethods.addToCart(
                                    productId: productModel.id,
                                    quantity: 1,
                                    context: context,
                                  );
                                  await cartProvider.fetchCart();
                                },
                                child: Icon(
                                  isInCart ? IconlyBold.bag2 : IconlyLight.bag2,
                                  size: 22,
                                  color: isInCart ? Colors.green : color,
                                ),
                              ),
                              HeartBTN(
                                productId: productModel.id,
                                isInWishlist: isInWishlist,
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  PriceWidget(
                    salePrice: productModel.salePrice,
                    price: productModel.price,
                    textPrice: "1",
                    isOnSale: productModel.isOnSale,
                  ),
                  const SizedBox(height: 5),
                  TextWidget(
                    text: productModel.title,
                    color: color,
                    textSize: 16,
                    isTitle: true,
                  ),
                  const SizedBox(height: 5),
                ]),
          ),
        ),
      ),
    );
  }
}
