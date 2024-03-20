import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/core/models/product_model.dart';

final productQtyProvider = StateProvider<int>((ref) => 1);

final productProvider = NotifierProvider<ProductNotifier, List<ProductModel>>(ProductNotifier.new);

class ProductNotifier extends Notifier<List<ProductModel>> {
  fetchProducts(List rawProducts) {
    List<ProductModel> products = rawProducts.map((e) => ProductModel.fromMap(e)).toList();
    state = products;
  }

  @override
  build() {
    return [];
  }
}
