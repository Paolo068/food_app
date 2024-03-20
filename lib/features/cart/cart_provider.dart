import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/core/models/cart_model.dart';

final cartItemsProvider = NotifierProvider<CartItemsNotifier, List<CartModel>>(CartItemsNotifier.new);

class CartItemsNotifier extends Notifier<List<CartModel>> {
  addToCart(CartModel value) {
    state = [...state, value];
  }

  removeItem(int index) {
    state.removeAt(index);
    ref.notifyListeners();
  }

  updateItem(int index, CartModel value) {
    state[index] = value;
    ref.notifyListeners();
  }

  @override
  List<CartModel> build() {
    return [];
  }
}
