import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tkecom/models/products_model.dart';

class ProductsProvider with ChangeNotifier {
  static List<ProductModel> _productsList = [];

  List<ProductModel> get getProducts {
    return _productsList;
  }

  List<ProductModel> get getOnSaleProducts {
    return getProducts.where((element) => element.isOnSale == true).toList();
  }

  ProductModel findProdById({required String productId}) {
    return _productsList.firstWhere((element) => element.id == productId);
  }

  Future<void> fetchProducts() async {
    await FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot productSnapshot) {
      for (var element in productSnapshot.docs) {
        final priceValue = element.get('price').toString();
        final price = double.tryParse(priceValue) ?? 0.0;
        final salePriceValue = element.get('salePrice').toString();
        final salePrice = double.tryParse(salePriceValue) ?? 0.0;
        final isOnSale = element.get('isOnSale') as bool;
        final isPieceValue = element.get('isPiece') as bool;
        final isPiece = isPieceValue ?? false;
        _productsList = [];
        _productsList.clear();
        _productsList.insert(
          0,
          ProductModel(
            id: element.get('id'),
            title: element.get('title'),
            imageUrl: element.get('imageUrl'),
            productCategoryName: element.get('productCategoryName'),
            price: price,
            salePrice: salePrice,
            isOnSale: isOnSale,
            isPiece: isPiece,
          ),
        );
      }
    });
    notifyListeners();
  }

  List<ProductModel> findByCategory({required String categoryName}) {
    List<ProductModel> categoryList = _productsList
        .where((element) => element.productCategoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
    return categoryList;
  }

  List<ProductModel> searchQuery(String searchText) {
    List<ProductModel> searchList = _productsList
        .where((element) =>
            element.title.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    return searchList;
  }
}
