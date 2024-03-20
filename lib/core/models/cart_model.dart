import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:food_app/features/product_addon/addon_model.dart';

class CartModel {
  String name;
  int quantity;
  int price;
  List<String> description;
  List<AddonModel> addons;
  String image;
  CartModel({
    required this.name,
    required this.quantity,
    required this.price,
    required this.description,
    required this.addons,
    required this.image,
  });

  CartModel copyWith({
    String? name,
    int? quantity,
    int? price,
    List<String>? description,
    List<AddonModel>? addons,
    String? image,
  }) {
    return CartModel(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      description: description ?? this.description,
      addons: addons ?? this.addons,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
      'description': description,
      'addons': addons.map((x) => x.toMap()).toList(),
      'image': image,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      name: map['name'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
      price: map['price']?.toInt() ?? 0,
      description: List<String>.from(map['description']),
      addons: List<AddonModel>.from(map['addons']?.map((x) => AddonModel.fromMap(x))),
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) => CartModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CartModel(name: $name, quantity: $quantity, price: $price, description: $description, addons: $addons, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartModel &&
        other.name == name &&
        other.quantity == quantity &&
        other.price == price &&
        listEquals(other.description, description) &&
        listEquals(other.addons, addons) &&
        other.image == image;
  }

  @override
  int get hashCode {
    return name.hashCode ^ quantity.hashCode ^ price.hashCode ^ description.hashCode ^ addons.hashCode ^ image.hashCode;
  }
}
