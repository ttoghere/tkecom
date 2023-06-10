import 'package:flutter/material.dart';
import 'package:tkecom/models/recently_viewed_model.dart';

class RecentlyViewedProvider with ChangeNotifier {
  Map<String, RecentlyViewedModel> _viewedProductList = {};
  Map<String, RecentlyViewedModel> get viewedProductsList {
    return _viewedProductList;
  }

  void addToHistory({required String productId}) {
    _viewedProductList.putIfAbsent(
        productId,
        () => RecentlyViewedModel(
            id: DateTime.now().toString(), productId: productId));
    notifyListeners();
  }

   void removeOneItem(String productId) {
    _viewedProductList.remove(productId);
    notifyListeners();
  }

  void clearHistory() {
    _viewedProductList.clear();
    notifyListeners();
  }
}
