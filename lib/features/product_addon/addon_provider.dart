import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/features/product_addon/addon_model.dart';
import 'package:food_app/utils.dart';

/// Provide the list of addons. Riverpod Provider are lazy loaded. So this provider must be called first for FilterChip onSelected function to work properly
final addonProvider = NotifierProvider<AddonNotifier, List<AddonModel>>(AddonNotifier.new);

class AddonNotifier extends Notifier<List<AddonModel>> {
  addAddon(AddonModel value) {
    state = [...state, value];
    logInfo('Addon Added ==>: ${value.name}');
  }

  removeAddon(AddonModel value) {
    state = state.where((element) => element != value).toList();
  }

  @override
  List<AddonModel> build() {
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
