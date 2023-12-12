import 'dart:convert';

import 'package:flutter/foundation.dart';

class CartModel {
  String name;
  int itemQty;
  int price;
  List<String> addons;
  String image;
  CartModel({
    required this.name,
    required this.itemQty,
    required this.price,
    required this.addons,
    required this.image,
  });

  CartModel copyWith({
    String? name,
    int? itemQty,
    int? price,
    List<String>? addons,
    String? image,
  }) {
    return CartModel(
      name: name ?? this.name,
      itemQty: itemQty ?? this.itemQty,
      price: price ?? this.price,
      addons: addons ?? this.addons,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'itemQty': itemQty,
      'price': price,
      'addons': addons,
      'image': image,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      name: map['name'] ?? '',
      itemQty: map['itemQty']?.toInt() ?? 0,
      price: map['price']?.toInt() ?? 0,
      addons: List<String>.from(map['addons']),
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) => CartModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CartModel(name: $name, itemQty: $itemQty, price: $price, addons: $addons, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartModel &&
        other.name == name &&
        other.itemQty == itemQty &&
        other.price == price &&
        listEquals(other.addons, addons) &&
        other.image == image;
  }

  @override
  int get hashCode {
    return name.hashCode ^ itemQty.hashCode ^ price.hashCode ^ addons.hashCode ^ image.hashCode;
  }
}
