import 'dart:convert';

class AddonModel {
  String name;
  int price;
  AddonModel({
    required this.name,
    required this.price,
  });

  AddonModel copyWith({
    String? name,
    int? price,
  }) {
    return AddonModel(
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
    };
  }

  factory AddonModel.fromMap(Map<String, dynamic> map) {
    return AddonModel(
      name: map['name'] ?? '',
      price: map['price']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddonModel.fromJson(String source) => AddonModel.fromMap(json.decode(source));

  @override
  String toString() => 'AddonModel(name: $name, price: $price)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddonModel && other.name == name && other.price == price;
  }

  @override
  int get hashCode => name.hashCode ^ price.hashCode;
}
