import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/services/api/api_service.dart';

Box box = Hive.box('appBox');
final productRepositoryProvider = AsyncNotifierProvider<ProductRepositoryNotifier, List>(ProductRepositoryNotifier.new);

class ProductRepositoryNotifier extends AsyncNotifier<List> {
  @override
  FutureOr<List> build() async {
    Response response = await DioClient.instance.get('/items/pizza');
    // logInfo('Pizza from server ==> ${response.data['data']}');
    box.put('offlineData', response.data['data']);
    return response.data['data'];
  }
}
