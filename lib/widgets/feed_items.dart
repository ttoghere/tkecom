// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:tkecom/inner_screens/inner_screens_shelf.dart';
import 'package:tkecom/models/products_model.dart';
import 'package:tkecom/provider/cart_provider.dart';
import 'package:tkecom/provider/products_provider.dart';
import 'package:tkecom/services/services_shelf.dart';
import 'package:tkecom/widgets/widgets_shelf.dart';

class FeedsWidget extends StatefulWidget {
  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final ProductModel productModel = context.read<ProductModel>();
    final cartProvider = context.read<CartProvider>();
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).cardColor,
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetails.routeName, arguments: productModel.id);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(children: [
          FancyShimmerImage(
            imageUrl: productModel.imageUrl,
            height: size.width * 0.17,
            width: size.width * 0.17,
            boxFit: BoxFit.fill,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextWidget(
                      text: productModel.title,
                      color: color,
                      textSize: 15,
                      isTitle: true,
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: HeartBTN(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: PriceWidget(
                      salePrice: productModel.salePrice,
                      price: productModel.price,
                      textPrice: _quantityTextController.text,
                      isOnSale: productModel.isOnSale,
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  Flexible(
                    child: Row(
                      children: [
                        Flexible(
                          flex: 10,
                          child: FittedBox(
                            child: TextWidget(
                              text: productModel.isPiece ? "Piece" : "KG",
                              color: color,
                              textSize: 18,
                              isTitle: true,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                            flex: 2,
                            // TextField can be used also instead of the textFormField
                            child: TextFormField(
                              controller: _quantityTextController,
                              key: const ValueKey('10'),
                              style: TextStyle(color: color, fontSize: 18),
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              enabled: true,
                              onChanged: (valueee) {
                                setState(() {});
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.]'),
                                ),
                              ],
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                cartProvider.addProductsToCart(
                  productId: productModel.id,
                  quantity: int.parse(_quantityTextController.text),
                );
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).cardColor),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                    ),
                  ),
                ),
              ),
              child: TextWidget(
                text: 'Add to cart',
                maxLines: 1,
                color: color,
                textSize: 20,
              ),
            ),
          )
        ]),
      ),
    );
  }
}
