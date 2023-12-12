import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils.dart';

final locationRepositoryProvider =
    AsyncNotifierProviderFamily<LocationRepositoryNotifier, List, String>(LocationRepositoryNotifier.new);

class LocationRepositoryNotifier extends FamilyAsyncNotifier<List, String> {
  @override
  FutureOr<List> build(arg) async {
    Response response = await Dio(BaseOptions(queryParameters: {
      "key": "rSxB87q4amXPkn7FQ7xj",
      "limit": 5,
      "country": "cm",
    })).get('https://api.maptiler.com/geocoding/$arg.json');
    final addresses = response.data['features'];
    logInfo('FETCHED ADDRESSES ====> $addresses');
    return addresses ?? [];
  }
}
