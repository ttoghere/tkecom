import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tkecom/models/orders_model.dart';

class OrderProvider with ChangeNotifier {
  static List<OrderModel> _orders = [];
  List<OrderModel> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    try {
      final orderSnapshot =
          await FirebaseFirestore.instance.collection('orders').get();

      _orders = []; // Clear the orders list

      for (var element in orderSnapshot.docs) {
        final orderData = element.data();

        log('Order Data: $orderData');

        final priceValue = orderData['price']?.toString() ?? '';
        final quantityValue = orderData['quantity']?.toString() ?? '';
        final userName = orderData['userName']?.toString() ?? 'User';

        _orders.insert(
          0,
          OrderModel(
            orderId: orderData['orderId']?.toString() ?? '',
            userId: orderData['userId']?.toString() ?? '',
            productId: orderData['productId']?.toString() ?? '',
            userName: userName,
            price: priceValue,
            imageUrl: orderData['imageUrl']?.toString() ?? '',
            quantity: quantityValue,
            orderDate: orderData['orderData'] ?? Timestamp.now(),
          ),
        );
      }

      notifyListeners();
    } catch (error) {
      log('Error fetching orders: $error');
    }
  }
}

// orderData['orderData']?? Timestamp.now(),