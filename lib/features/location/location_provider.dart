import 'package:flutter_riverpod/flutter_riverpod.dart';

final locationProvider = NotifierProvider<LocationNotifier, String>(LocationNotifier.new);

class LocationNotifier extends Notifier<String> {
  setLocation(String place) {
    state = place;
  }

  @override
  build() {
    return '';
  }
}
