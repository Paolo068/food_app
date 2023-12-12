import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/core/shared_widgets/button.dart';
import 'package:food_app/features/cart/cart_provider.dart';
import 'package:food_app/features/cart/widgets/cart_item_widget.dart';
import 'package:food_app/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/styles_constants.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  Box box = Hive.box('appBox');
  // List cartList = [];

  // void onDeleteItem(int index) async {
  //   itemList.removeAt(index);
  //   await box.delete('cartItems');
  //   await box.put('cartItems', itemList);
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    // itemList = box.get('cartItems', defaultValue: []);
  }

  @override
  Widget build(BuildContext context) {
    final cartList = ref.watch(cartListProvider);
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
                          logError('message');
                          // List castedList = itemList.map((e) => e.cast<String, dynamic>()).toList();
                          final cartItems = cartList.map((e) => e.CartModel.fromMap(e)).toList();
                          final cartItem = cartItems[index];
                          return CartItemWidget(
                            name: cartItem.name,
                            price: cartItem.price,
                            imageUrl: '${AppConstants.baseUrl}/assets/${cartItem.image}',
                            addonList: cartItem.addons.toString(),
                            quantity: cartItem.itemQty,
                            onDelete: () {} /*=> onDeleteItem(index)*/,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) => const Divider(),
                      ),
                    ),
                    const Spacer(),
                    AppButton(
                        text: 'Proceed',
                        onPressed: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              useRootNavigator: true,
                              backgroundColor: Colors.white,
                              useSafeArea: true,
                              context: context,
                              builder: (context) {
                                return DraggableScrollableSheet(builder: (context, scrollCtrl) {
                                  return const Center(
                                    child: Text('Hello'),
                                  );
                                });
                              });
                        })
                  ],
                ),
        ),
      ),
    );
  }
}
