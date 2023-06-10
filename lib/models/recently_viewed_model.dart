import 'package:flutter/material.dart';

class RecentlyViewedModel with ChangeNotifier {
  final String id;
  final String productId;
  RecentlyViewedModel({required this.id, required this.productId});
}
