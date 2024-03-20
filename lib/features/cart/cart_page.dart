import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/core/shared_widgets/button.dart';
import 'package:food_app/features/cart/cart_provider.dart';
import 'package:food_app/features/cart/widgets/cart_item_widget.dart';
import 'package:food_app/features/order/order_model.dart';
import 'package:food_app/features/order/order_page.dart';
import 'package:food_app/features/order/order_provider.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_constants.dart';
import '../../core/models/cart_model.dart';
import '../../core/shared_widgets/icon_button.dart';
import '../../core/shared_widgets/loader.dart';
import '../../core/theme/colors.dart';
import '../../utils.dart';
import '../product_addon/addon_model.dart';
import '../product_addon/addon_provider.dart';
import '../product_addon/addon_repository.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  int id = 0;
  @override
  Widget build(BuildContext context) {
    String orderId = 'CLT${id++}${DateTime.now()}';
    final cartList = ref.watch(cartItemsProvider);

    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Cart Page',
      )),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: cartList.isEmpty
              ? Center(
                  child: Text(
                  'Cart is empty',
                  style: AppStyles.headLineText,
                ))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: cartList.length,
                        itemBuilder: (context, index) {
                          CartModel cartItem = cartList[index];
                          int cartItemQty = cartItem.quantity;
                          int unitPrice = cartItem.price ~/ cartItemQty;

                          return InkWell(
                            onTap: () => showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return Consumer(
                                    builder: (context, ref, child) {
                                      int addons = 0;
                                      final addonList = ref.watch(addonRepositoryProvider);
                                      final selectedAddons = ref.watch(addonProvider);

                                      if (selectedAddons.isNotEmpty) {
                                        final addonPriceList = selectedAddons.map((addon) => addon.price).toList();
                                        addons = addonPriceList.reduce((value, element) => value + element);
                                      }

                                      return StatefulBuilder(builder: (context, kSetState) {
                                        int itemPrice = unitPrice * cartItemQty + addons;
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                                            CachedNetworkImage(
                                              imageUrl: '${AppConstants.baseUrl}/assets/${cartItem.image}',
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                            Text(cartItem.name, style: AppStyles.headLineText),
                                            const Gap(20),
                                            Row(
                                              children: [
                                                StatefulBuilder(builder: (context, k) {
                                                  return Text.rich(
                                                    TextSpan(
                                                        style: GoogleFonts.robotoMono(
                                                            fontSize: 26, color: Pallete.darkBlue),
                                                        text: '$itemPrice',
                                                        children: [
                                                          TextSpan(
                                                            text: ' FCFA',
                                                            style: AppStyles.bodyText.copyWith(fontSize: 15),
                                                          )
                                                        ]),
                                                  );
                                                }),
                                                const Spacer(),
                                                AppIconBtn(
                                                  onPressed: cartItemQty == 1
                                                      ? null
                                                      : () {
                                                          cartItemQty--;
                                                          kSetState(() {});
                                                        },
                                                  icon: const Icon(Icons.remove),
                                                ),
                                                SizedBox(
                                                  width: 30,
                                                  height: 30,
                                                  child: Center(
                                                    child: Text('$cartItemQty',
                                                        style: AppStyles.headLineText
                                                            .copyWith(fontWeight: FontWeight.normal)),
                                                  ),
                                                ),
                                                AppIconBtn(
                                                  onPressed: () {
                                                    cartItemQty++;
                                                    kSetState(() {});
                                                  },
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
                                                  cartItem.description
                                                      .toString()
                                                      .substring(1, cartItem.description.toString().length - 1),
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
                                                          List<AddonModel> addons =
                                                              data.map((e) => AddonModel.fromMap(e)).toList();
                                                          return Consumer(builder: (context, ref, child) {
                                                            List<bool> isAddonSelected =
                                                                ref.watch(addonStateProvider(addons.length));
                                                            final cartAddons = cartItem.addons[index];

                                                            List<bool> d = addons.map((addon) {
                                                              cartAddons.name == addon.name
                                                                  ? isAddonSelected[index] = true
                                                                  : isAddonSelected[index] = false;
                                                              return isAddonSelected[index];
                                                            }).toList();
                                                            logError('d:==> $d');

                                                            return Wrap(
                                                              children: List.generate(addons.length, (index) {
                                                                AddonModel addon = addons[index];

                                                                return Padding(
                                                                  padding: const EdgeInsets.only(right: 8.0),
                                                                  child: FilterChip(
                                                                    shape: RoundedRectangleBorder(
                                                                        side: BorderSide(
                                                                            color: isAddonSelected[index]
                                                                                ? Pallete.orange
                                                                                : Pallete.lightGrey300),
                                                                        borderRadius: BorderRadius.circular(50)),
                                                                    checkmarkColor: Pallete.orange,
                                                                    label: Text(addon.name),
                                                                    selected: isAddonSelected[index],
                                                                    onSelected: (bool value) {
                                                                      isAddonSelected[index] = value;
                                                                      logError(
                                                                          'FilterChip onSelected value ===> $value');

                                                                      if (value) {
                                                                        ref
                                                                            .read(addonProvider.notifier)
                                                                            .addAddon(addon);
                                                                        logInfo('Added Addon ===> ${addon.name}');
                                                                      } else {
                                                                        ref
                                                                            .read(addonProvider.notifier)
                                                                            .removeAddon(addon);
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
                                                      },
                                                      text: 'Cancel',
                                                    ),
                                                  ),
                                                  const Gap(15),
                                                  Flexible(
                                                    child: AppButton(
                                                      onPressed: () {
                                                        ref.read(cartItemsProvider.notifier).updateItem(
                                                              index,
                                                              CartModel(
                                                                name: cartItem.name,
                                                                quantity: cartItemQty,
                                                                price: itemPrice,
                                                                description: cartItem.description,
                                                                addons: cartItem.addons,
                                                                image: cartItem.image,
                                                              ),
                                                            );
                                                        Timer(
                                                          const Duration(milliseconds: 10),
                                                          () => Navigator.pop(context),
                                                        );
                                                        showToast('Item updated !');
                                                      },
                                                      text: 'Update cart',
                                                    ),
                                                  ),
                                                ])
                                              ]),
                                            )
                                          ]),
                                        );
                                      });
                                    },
                                  );
                                }),
                            child: CartItemWidget(
                              name: cartItem.name,
                              price: cartItem.price,
                              imageUrl: '${AppConstants.baseUrl}/assets/${cartItem.image}',
                              addonList: cartItem.addons.toString(),
                              quantity: cartItem.quantity,
                              description: cartItem.description,
                              onDelete: () {
                                ref.read(cartItemsProvider.notifier).removeItem(index);
                              },
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) => const Divider(),
                      ),
                    ),
                    AppButton(
                        text: 'Proceed',
                        onPressed: () {
                          final totalPriceList = cartList.map((product) => product.price).toList();
                          int totalPrice = totalPriceList.reduce((value, element) => value + element);
                          final order = OrderModel(
                              orderId: orderId, products: cartList, totalPrice: totalPrice, date: DateTime.now());
                          ref.read(orderProvider.notifier).orderNow(order);
                          logError('New order ==> ${ref.read(orderProvider)}');
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OrderPage()));

                          ref.invalidate(cartItemsProvider);
                        })
                  ],
                ),
        ),
      ),
    );
  }
}
