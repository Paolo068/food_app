import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

Box box = Hive.box('appBox');
final cartItemQtyProvider = StateProvider<int>((ref) => 1);

final cartListProvider = NotifierProvider<CartListNotifier, List>(CartListNotifier.new);

class CartListNotifier extends Notifier<List> {
  addToCart(List value) {
    state = [...state, value];
  }

  @override
  build() {
    return [];
  }
}
