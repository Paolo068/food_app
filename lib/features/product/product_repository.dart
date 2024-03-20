import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/features/product/product_provider.dart';
import 'package:food_app/utils.dart';

import '../../core/services/api/api_service.dart';

final productRepositoryProvider = AsyncNotifierProvider<ProductRepositoryNotifier, List>(ProductRepositoryNotifier.new);

class ProductRepositoryNotifier extends AsyncNotifier<List> {
  @override
  FutureOr<List> build() async {
    try {
      Response response = await DioClient.instance.get('/items/pizza');
      logInfo(response.data['data']);
      ref.watch(productProvider.notifier).fetchProducts(response.data['data']);
      logInfo('Product provider ===> ${ref.watch(productProvider)}');
      return response.data['data'];
    } catch (e) {
      rethrow;
    }
  }
}
