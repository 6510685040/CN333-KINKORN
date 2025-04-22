import 'package:flutter/material.dart';


class CartProvider extends ChangeNotifier {
  String? _restaurantName;
  String? _restaurantId;
  String? _customerId;   
  List<Map<String, dynamic>> _cartItems = [];

  String? get restaurantName => _restaurantName;
  List<Map<String, dynamic>> get cartItems => _cartItems;
  
  String? get restaurantId => _restaurantId;
  String? get customerId => _customerId;

  void setCustomerId(String id) {
    _customerId = id;
    notifyListeners();
  }

  void setRestaurantId(String id) {
    _restaurantId = id;
    notifyListeners();
  }

  void setRestaurant(String name) {
    _restaurantName = name;
    notifyListeners();
  }

  void addToCart(Map<String, dynamic> item) {
  // ตรวจสอบว่า item มาจากร้านเดียวกันกับที่อยู่ใน cart หรือไม่
  if (_restaurantId != null && item['restaurantId'] != _restaurantId) {
  
    return;
  }

  _cartItems.add(item);
  notifyListeners();
}

  void removeFromCart(Map<String, dynamic> item) {
    _cartItems.remove(item); 
    notifyListeners();
  }

  void clearCart() {
    _cartItems = [];
    _restaurantName = null;
    notifyListeners();
  }
  void setCartItems(List<Map<String, dynamic>> newItems) {
    _cartItems = newItems;
    notifyListeners();
  }

  double get totalPrice => _cartItems.fold(
      0.0, (sum, item) => sum + (item['quantity'] * item['price']));
}
