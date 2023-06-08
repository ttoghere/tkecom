// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ProductModel with ChangeNotifier {
  final String id, title, imageUrl, productCategoryName;
  final double price, salePrice;
  final bool isOnSale, isPiece;
  ProductModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.productCategoryName,
    required this.salePrice,
    required this.isPiece,
    required this.price,
    required this.isOnSale,
  });
}
