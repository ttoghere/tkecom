import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tkecom/consts/firebase_contants.dart';
import 'package:tkecom/provider/cart_provider.dart';
import 'package:tkecom/provider/order_provider.dart';
import 'package:tkecom/provider/products_provider.dart';
import 'package:tkecom/services/services_shelf.dart';
import 'package:tkecom/widgets/widgets_shelf.dart';
import 'package:uuid/uuid.dart';
import 'cart_shelf.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems =
        cartProvider.getCartItems.values.toList().reversed.toList();
    return cartItems.isEmpty
        ? const EmptyScreen(
            title: 'Your cart is empty',
            subtitle: 'Add something and make me happy :)',
            buttonText: 'Shop now',
            imagePath: 'assets/images/cart.png',
          )
        : Scaffold(
            appBar: AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: TextWidget(
                  text: 'Cart (${cartItems.length})',
                  color: color,
                  isTitle: true,
                  textSize: 22,
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      GlobalMethods.warningDialog(
                          title: 'Empty your cart?',
                          subtitle: 'Are you sure?',
                          fct: () async {
                            await cartProvider.clearOnlineCart();
                            cartProvider.clearLocalCart();
                            Navigator.of(context).pop();
                          },
                          context: context);
                    },
                    icon: Icon(
                      IconlyBroken.delete,
                      color: color,
                    ),
                  ),
                ]),
            body: Column(
              children: [
                _checkout(ctx: context),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (ctx, index) {
                      return ChangeNotifierProvider.value(
                          value: cartItems[index],
                          child: CartWidget(
                            quantity: cartItems[index].quantity,
                          ));
                    },
                  ),
                ),
              ],
            ),
          );
  }

  Widget _checkout({required BuildContext ctx}) {
    final Color color = Utils(ctx).color;
    Size size = Utils(ctx).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(ctx);
    final productProvier = Provider.of<ProductsProvider>(ctx);
    final ordersProvider = Provider.of<OrderProvider>(ctx, listen: false);
    double total = 0.0;
    cartProvider.getCartItems.forEach((key, value) {
      final getCurrentProduct =
          productProvier.findProdById(productId: value.productId);
      total += (getCurrentProduct.isOnSale
              ? getCurrentProduct.salePrice
              : getCurrentProduct.price) *
          value.quantity;
    });
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(children: [
          Material(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () async {
                final orderId = const Uuid().v4();
                User? user = authInstance.currentUser;
                final productProvider =
                    Provider.of<ProductsProvider>(ctx, listen: false);

                cartProvider.getCartItems.forEach((key, value) async {
                  final getCurrentProduct =
                      productProvider.findProdById(productId: value.productId);

                  try {
                    await FirebaseFirestore.instance
                        .collection("orders")
                        .doc(orderId)
                        .set({
                      "orderId": orderId,
                      "userId": user!.uid,
                      "productId": value.productId,
                      "price": (getCurrentProduct.isOnSale
                              ? getCurrentProduct.salePrice
                              : getCurrentProduct.price) *
                          value.quantity,
                      "totalPrice": total,
                      "quantity": value.quantity,
                      "imageUrl": getCurrentProduct.imageUrl,
                      "userName": user.displayName,
                      "orderDate": Timestamp.now()
                    });
                    await cartProvider.clearOnlineCart();
                    cartProvider.clearLocalCart();
                    //TODO fetch the orders here
                    ordersProvider.fetchOrders();
                    await Fluttertoast.showToast(
                      msg: "Your Order Has Been Sent",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                    );
                  } catch (error) {
                    GlobalMethods.warningDialog(
                        title: "An error occured",
                        subtitle: "Error: $error",
                        fct: () {
                          Navigator.of(ctx).pop();
                        },
                        context: ctx);
                  } finally {}
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextWidget(
                  text: 'Order Now',
                  textSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Spacer(),
          FittedBox(
            child: TextWidget(
              text: 'Total: \$${total.toStringAsFixed(2)}',
              color: color,
              textSize: 18,
              isTitle: true,
            ),
          ),
        ]),
      ),
    );
  }
}
