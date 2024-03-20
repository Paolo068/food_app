import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:food_app/core/models/cart_model.dart';

class OrderModel {
  String orderId; /*CLT120240112*/
  List<CartModel> products;
  int totalPrice;
  DateTime date;
  OrderModel({
    required this.orderId,
    required this.products,
    required this.totalPrice,
    required this.date,
  });

  OrderModel copyWith({
    String? orderId,
    List<CartModel>? products,
    int? totalPrice,
    DateTime? date,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      products: products ?? this.products,
      totalPrice: totalPrice ?? this.totalPrice,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'products': products.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'] ?? '',
      products: List<CartModel>.from(map['products']?.map((x) => CartModel.fromMap(x))),
      totalPrice: map['totalPrice']?.toInt() ?? 0,
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) => OrderModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderModel(orderId: $orderId, products: $products, totalPrice: $totalPrice, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderModel &&
        other.orderId == orderId &&
        listEquals(other.products, products) &&
        other.totalPrice == totalPrice &&
        other.date == date;
  }

  @override
  int get hashCode {
    return orderId.hashCode ^ products.hashCode ^ totalPrice.hashCode ^ date.hashCode;
  }
}
