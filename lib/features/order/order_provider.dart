import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/features/order/order_model.dart';

final orderProvider = NotifierProvider<OrderNotifier, List<OrderModel>>(OrderNotifier.new);

class OrderNotifier extends Notifier<List<OrderModel>> {
  void orderNow(OrderModel order) {
    state = [...state, order];
  }

  @override
  List<OrderModel> build() {
    return [];
  }
}
