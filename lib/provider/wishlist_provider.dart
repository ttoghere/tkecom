import 'package:flutter/cupertino.dart';
import 'package:tkecom/models/wishlist_model.dart';

class WishlistProvider with ChangeNotifier {
  Map<String, WishlistModel> _wishlistItems = {};
  Map<String, WishlistModel> get wishlistItems {
    return _wishlistItems;
  }

  void addProductToList({required String productId}) {
    if (_wishlistItems.containsKey(productId)) {
      removeOneItem(productId);
    } else {
      _wishlistItems.putIfAbsent(
        productId,
        () =>
            WishlistModel(id: DateTime.now().toString(), productId: productId),
      );
    }
    notifyListeners();
  }

  void removeOneItem(String productId) {
    _wishlistItems.remove(productId);
    notifyListeners();
  }

  void clearList() {
    _wishlistItems.clear();
    notifyListeners();
  }
}
