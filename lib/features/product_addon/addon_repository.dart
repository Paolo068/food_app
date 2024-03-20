import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/services/api/api_service.dart';

final _dio = DioClient.instance;
Box box = Hive.box('appBox'); // Get instance of opened box in the main.dart

final addonRepositoryProvider = AsyncNotifierProvider<AddonRepositoryNotifier, List>(AddonRepositoryNotifier.new);

class AddonRepositoryNotifier extends AsyncNotifier<List> {
  @override
  FutureOr<List> build() async {
    Response response = await _dio.get('/items/addon');
    return response.data['data'];
  }
}
