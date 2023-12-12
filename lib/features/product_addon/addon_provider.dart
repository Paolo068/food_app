import 'package:flutter_riverpod/flutter_riverpod.dart';

final addonProvider = NotifierProvider<AddonNotifier, List<String>>(AddonNotifier.new);

class AddonNotifier extends Notifier<List<String>> {
  addAddon(String value) {
    state = [...state, value];
    // ref.notifyListeners();
  }

  removeAddon(String value) {
    state = state.where((element) => element != value).toList();
    // ref.notifyListeners();
  }

  @override
  List<String> build() {
    return [];
  }
}

final addonStateProvider = NotifierProviderFamily<AddonStateNotifier, List<bool>, int>(AddonStateNotifier.new);

class AddonStateNotifier extends FamilyNotifier<List<bool>, int> {
  @override
  List<bool> build(int arg) {
    return List.generate(arg, (index) => false);
  }
}
