import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/core/models/product_model.dart';
import 'package:food_app/core/shared_widgets/icon_button.dart';
import 'package:food_app/features/cart/cart_provider.dart';
import 'package:food_app/features/home/widgets/header_widget.dart';
import 'package:food_app/features/product/widgets/food_item_widget.dart';
import 'package:food_app/features/product_addon/addon_repository.dart';
import 'package:food_app/utils.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/styles_constants.dart';
import '../../core/shared_widgets/button.dart';
import '../../core/shared_widgets/loader.dart';
import '../order/order_page.dart';
import '../product/product_repository.dart';
import '../product_addon/addon_model.dart';
import '../product_addon/addon_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // List<String> selectedAddons = [];
  Box box = Hive.box('appBox');
  List<int> pizzaPrices = [5000, 6500, 7500, 8000];
  List selectedPizzaPrices = [];
  String filterByName = '';
  List cartItems = [];
  List offlineData = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // box.delete('cartItems');
    // offlineData = getOfflineData();
  }

  // getOfflineData() {
  //   List data = box.get('offlineData', defaultValue: []);
  //   return data.map((e) => e.cast<String, dynamic>()).toList();
  // }

  void addToCart({
    required String name,
    required int price,
    required String image,
    required int quantity,
    required List<String> addons,
  }) async {
    cartItems.add({
      'name': name,
      'price': price,
      'image': image,
      'itemQty': quantity,
      'addons': addons,
    });
    // await box.put('cartItems', [...cartItems, cartItems]);
    ref.read(cartListProvider.notifier).addToCart(cartItems);
    // logError('Cart box values ===> ${box.values}s');
    logError('Item added to cart ===> ${ref.read(cartListProvider)}');
  }

  void onQtyRemove() {
    ref.read(cartItemQtyProvider.notifier).update((state) => state - 1);
  }

  void onQtyAdd() {
    ref.read(cartItemQtyProvider.notifier).update((state) => state + 1);
  }

  @override
  Widget build(BuildContext context) {
    logError('===> BuildContext Triggered <===');
    logInfo('Box values ===> ${box.get('cartItems', defaultValue: [])}');
    final productList = ref.watch(productRepositoryProvider);

    final priceFilter = offlineData.where((pizza) {
      return selectedPizzaPrices.isEmpty || selectedPizzaPrices.contains(pizza['price']);
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 2), () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const HeaderWidget(),
                ExpansionTile(
                  shape: const RoundedRectangleBorder(side: BorderSide.none),
                  expandedAlignment: Alignment.topLeft,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    'Price filter',
                    style: AppStyles.headLineText.copyWith(
                      fontSize: 20,
                    ),
                  ),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: pizzaPrices.map((price) {
                        return FilterChip(
                            showCheckmark: false,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  const BorderRadius.horizontal(left: Radius.circular(50), right: Radius.circular(50)),
                              side: BorderSide(
                                color: selectedPizzaPrices.contains(price) ? Pallete.orange : Colors.grey,
                              ),
                            ),
                            label: Text('$price'),
                            selected: selectedPizzaPrices.contains(price),
                            checkmarkColor: Pallete.orange,
                            onSelected: (onSelected) {
                              setState(() {
                                onSelected ? selectedPizzaPrices.add(price) : selectedPizzaPrices.remove(price);
                              });
                            });
                      }).toList(),
                    ),
                  ],
                ),
                const Gap(15),
                productList.when(
                  data: (data) {
                    return Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: priceFilter.isNotEmpty ? priceFilter.length : data.length,
                        itemBuilder: (context, index) {
                          final product = data.map((e) => ProductModel.fromMap(e)).toList();
                          final item = product[index];
                          return FoodItemWidget(
                            name: item.name,
                            price: item.price,
                            imageUrl: '${AppConstants.baseUrl}/assets/${item.image}',
                            description: item.description.toString(),
                            onTap: () {
                              showModalBottomSheet(
                                  useRootNavigator: true,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.white,
                                  useSafeArea: true,
                                  context: context,
                                  builder: (context) {
                                    return Consumer(
                                      builder: (context, ref, child) {
                                        List<String> selectedAddons = ref.watch(addonProvider);
                                        logInfo('List of selected addons ===> $selectedAddons');
                                        final cartItemQty = ref.watch(cartItemQtyProvider);
                                        int addons = (selectedAddons.length) * 1000;
                                        int itemPrice = item.price * cartItemQty + addons;
                                        final addonList = ref.watch(addonRepositoryProvider);

                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                                            CachedNetworkImage(
                                              imageUrl: '${AppConstants.baseUrl}/assets/${item.image}',
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                            Text(item.name, style: AppStyles.headLineText),
                                            const Gap(20),
                                            Row(
                                              children: [
                                                Consumer(
                                                  builder: (context, ref, child) {
                                                    return Text.rich(TextSpan(
                                                        style: GoogleFonts.robotoMono(
                                                            fontSize: 26, color: Pallete.darkBlue),
                                                        text: '$itemPrice',
                                                        children: [
                                                          TextSpan(
                                                            text: ' FCFA',
                                                            style: AppStyles.bodyText.copyWith(fontSize: 15),
                                                          )
                                                        ]));
                                                  },
                                                ),
                                                const Spacer(),
                                                AppIconBtn(
                                                  onPressed: cartItemQty <= 1 ? null : onQtyRemove,
                                                  icon: const Icon(Icons.remove),
                                                ),
                                                SizedBox(
                                                  width: 30,
                                                  height: 30,
                                                  child: Center(
                                                    child: Text('$cartItemQty ',
                                                        style: AppStyles.headLineText
                                                            .copyWith(fontWeight: FontWeight.normal)),
                                                  ),
                                                ),
                                                AppIconBtn(
                                                  onPressed: onQtyAdd,
                                                  icon: const Icon(Icons.add),
                                                ),
                                              ],
                                            ),
                                            const Divider(),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                Text(
                                                  'Contenu:',
                                                  style: AppStyles.headLineText.copyWith(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Text(
                                                  style: const TextStyle(fontSize: 17),
                                                  item.description
                                                      .toString()
                                                      .substring(1, item.description.toString().length - 1),
                                                ),
                                                const Gap(10),
                                                ExpansionTile(
                                                  maintainState: true,
                                                  tilePadding: const EdgeInsets.all(0),
                                                  shape: const RoundedRectangleBorder(side: BorderSide.none),
                                                  expandedAlignment: Alignment.topLeft,
                                                  controlAffinity: ListTileControlAffinity.leading,
                                                  title: Text(
                                                    'Supplements',
                                                    style: AppStyles.headLineText.copyWith(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  children: [
                                                    addonList.when(
                                                        data: (data) {
                                                          List addons = data.map((e) => AddonModel.fromMap(e)).toList();
                                                          return Consumer(builder: (context, ref, child) {
                                                            final isAddonSelected =
                                                                ref.watch(addonStateProvider(addons.length));
                                                            return Wrap(
                                                              children: List.generate(addons.length, (index) {
                                                                final addon = addons[index];
                                                                return Padding(
                                                                  padding: const EdgeInsets.only(right: 8.0),
                                                                  child: FilterChip(
                                                                    label: Text('${addon.name}'),
                                                                    selected: isAddonSelected[index],
                                                                    onSelected: (bool value) {
                                                                      isAddonSelected[index] = value;
                                                                      logError(
                                                                          'FilterChip onSelected value ===> $value');
                                                                      if (value) {
                                                                        ref
                                                                            .read(addonProvider.notifier)
                                                                            .addAddon(addon.name);
                                                                        logInfo('Added Addon ===> ${addon.name}');
                                                                      } else {
                                                                        ref
                                                                            .read(addonProvider.notifier)
                                                                            .removeAddon(addon.name);
                                                                        logInfo('Removed Addon ===> ${addon.name}');
                                                                      }
                                                                    },
                                                                  ),
                                                                );
                                                              }),
                                                            );
                                                          });
                                                        },
                                                        error: (Object error, StackTrace stackTrace) =>
                                                            Text(error.toString()),
                                                        loading: () => const Loader()),
                                                  ],
                                                ),
                                                const Gap(20),
                                                Row(children: [
                                                  Flexible(
                                                    child: AppButton(
                                                      outlined: true,
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        Navigator.push(context,
                                                            MaterialPageRoute(builder: (context) => const OrderPage()));
                                                      },
                                                      text: 'Order Now',
                                                    ),
                                                  ),
                                                  const Gap(15),
                                                  Flexible(
                                                    child: AppButton(
                                                      onPressed: () {
                                                        addToCart(
                                                          name: item.name,
                                                          price: itemPrice,
                                                          image: item.image,
                                                          quantity: cartItemQty,
                                                          addons: selectedAddons,
                                                        );
                                                        showToast('Item added to cart');
                                                        Timer(
                                                          const Duration(milliseconds: 200),
                                                          () => Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => const HomePage(),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      text: 'Add to cart',
                                                    ),
                                                  ),
                                                ])
                                              ]),
                                            )
                                          ]),
                                        );
                                      },
                                    );
                                  }).then((_) => Timer(const Duration(milliseconds: 500), () {
                                    ref.invalidate(addonStateProvider);
                                    ref.invalidate(addonProvider);
                                    ref.invalidate(cartItemQtyProvider);
                                  }));
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    return Column(
                      children: [
                        const Text('Unable to Load Data'),
                        const Gap(15),
                        AppButton(
                            text: 'Retry',
                            onPressed: () => Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) => const HomePage())))
                      ],
                    );
                  },
                  loading: () {
                    return const Loader();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
