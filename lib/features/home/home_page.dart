import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/core/models/cart_model.dart';
import 'package:food_app/core/models/product_model.dart';
import 'package:food_app/core/shared_widgets/icon_button.dart';
import 'package:food_app/features/cart/cart_provider.dart';
import 'package:food_app/features/product/product_provider.dart';
import 'package:food_app/features/product/widgets/food_item_widget.dart';
import 'package:food_app/features/product_addon/addon_repository.dart';
import 'package:food_app/utils.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/assets_constants.dart';
import '../../core/shared_widgets/button.dart';
import '../../core/shared_widgets/loader.dart';
import '../../core/shared_widgets/textfield.dart';
import '../../core/theme/colors.dart';
import '../cart/cart_page.dart';
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
  final searchFieldCtrl = TextEditingController();
  List<int> pizzaPrices = [5000, 6500, 7500, 8000];
  List selectedPizzaPrices = [];

  @override
  void dispose() {
    super.dispose();
    searchFieldCtrl.dispose();
  }

  @override
  void initState() {
    super.initState();
    logInfo('Homepage initState Triggered');
  }

  void addToCart({
    required String name,
    required int price,
    required String image,
    required int quantity,
    required List<AddonModel> addons,
    required List<String> description,
  }) async {
    final myCartItems = CartModel(
      name: name,
      price: price,
      image: image,
      description: description,
      quantity: quantity,
      addons: addons,
    );
    ref.read(cartItemsProvider.notifier).addToCart(myCartItems);
    logInfo('Item added to cart ===> ${ref.read(cartItemsProvider)}');
  }

  void onQtyRemove() {
    ref.read(productQtyProvider.notifier).update((state) => state - 1);
  }

  void onQtyAdd() {
    ref.read(productQtyProvider.notifier).update((state) => state + 1);
  }

  List<ProductModel> productFilter = [];

  searchProduct(String value) {
    productFilter = ref
        .watch(productProvider)
        .where((product) => product.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {});
    logInfo(productFilter.toString());
  }

  @override
  Widget build(BuildContext context) {
    final productList = ref.watch(productRepositoryProvider);
    final cartList = ref.watch(cartItemsProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(const Duration(milliseconds: 100), () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      Assets.profileIcon,
                      height: 40,
                      colorFilter: ColorFilter.mode(Pallete.darkBlue.withOpacity(0.5), BlendMode.srcIn),
                    ),
                    InkWell(
                      onTap: () =>
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CartPage())),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              SvgPicture.asset(
                                Assets.shoppingBasketIcon,
                                colorFilter: ColorFilter.mode(Pallete.orange, BlendMode.srcIn),
                              ),
                              Text(
                                'My basket',
                                style: AppStyles.bodyText.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                          Positioned(
                            right: 9,
                            child: Visibility(
                              visible: cartList.isEmpty ? false : true,
                              child: CircleAvatar(
                                radius: 8,
                                backgroundColor: Colors.red,
                                child: Text(
                                  '${cartList.length}',
                                  style: const TextStyle(fontSize: 11, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const Visibility(
                  visible: false,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text('${1}', style: TextStyle(fontSize: 12, color: Colors.white)),
                  ),
                ),
                const Gap(30),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: searchFieldCtrl,
                        onChanged: (value) {
                          searchProduct(value);
                        },
                        borderColor: Pallete.grey,
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Pallete.grey,
                        ),
                        hintText: 'Search your favorite pizza',
                      ),
                    ),
                    const Gap(16),
                    PopupMenuButton(
                        offset: const Offset(20, 50),
                        icon: SvgPicture.asset(
                          Assets.filterIcon,
                          colorFilter: ColorFilter.mode(Pallete.darkBlue, BlendMode.srcIn),
                        ),
                        itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 4500,
                                child: Text('4500'),
                              ),
                              const PopupMenuItem(
                                value: 5000,
                                child: Text('5000'),
                              ),
                              const PopupMenuItem(
                                value: 7500,
                                child: Text('7500'),
                              ),
                            ])
                  ],
                ),

                // =============== AFTER HEADER WIDGET ==================//
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
                        itemCount: productFilter.isEmpty ? data.length : productFilter.length,
                        itemBuilder: (context, index) {
                          final product =
                              productFilter.isEmpty ? data.map((e) => ProductModel.fromMap(e)).toList() : productFilter;
                          final item = product[index];
                          return FoodItemWidget(
                            name: item.name,
                            price: item.price,
                            imageUrl: '${AppConstants.baseUrl}/assets/${item.image}',
                            description: item.description.toString(),
                            onTap: () {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.white,
                                  useSafeArea: true,
                                  context: context,
                                  builder: (context) {
                                    return Consumer(
                                      builder: (context, ref, child) {
                                        int addons = 0;
                                        final selectedAddons = ref.watch(addonProvider);
                                        logInfo('List of selected addons ===> $selectedAddons');

                                        if (selectedAddons.isNotEmpty) {
                                          List<int> addonPriceList =
                                              selectedAddons.map((addon) => addon.price).toList();
                                          addons = addonPriceList.reduce((value, element) => value + element);
                                        }

                                        final cartItemQty = ref.watch(productQtyProvider);
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
                                                          return Consumer(builder: (context, ref, child) {
                                                            List addons =
                                                                data.map((e) => AddonModel.fromMap(e)).toList();
                                                            final isAddonSelected =
                                                                ref.watch(addonStateProvider(addons.length));

                                                            return Wrap(
                                                              children: List.generate(addons.length, (index) {
                                                                final addon = addons[index];
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
                                                                    label: Text('${addon.name}'),
                                                                    selected: isAddonSelected[index],
                                                                    onSelected: (bool value) {
                                                                      isAddonSelected[index] = value;
                                                                      logError('isAddonSelected ===> $isAddonSelected');

                                                                      if (value) {
                                                                        ref.read(addonProvider.notifier).addAddon(
                                                                              AddonModel(
                                                                                name: addon.name,
                                                                                price: addon.price,
                                                                              ),
                                                                            );

                                                                        logInfo('selected addon ===> ${addon.name}');
                                                                      } else {
                                                                        ref.read(addonProvider.notifier).removeAddon(
                                                                              AddonModel(
                                                                                name: addon.name,
                                                                                price: addon.price,
                                                                              ),
                                                                            );

                                                                        logInfo('removed addon ===> ${addon.name}');
                                                                      }
                                                                    },
                                                                  ),
                                                                );
                                                              }),
                                                            );
                                                          });
                                                        },
                                                        error: (Object error, StackTrace stackTrace) {
                                                          logError(error);
                                                          return Text(error.toString());
                                                        },
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
                                                          description: item.description,
                                                          quantity: cartItemQty,
                                                          addons: selectedAddons,
                                                        );

                                                        Timer(
                                                          const Duration(milliseconds: 10),
                                                          () => Navigator.pop(context),
                                                        );
                                                        showToast('Item added to cart');
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
                                    ref.invalidate(productQtyProvider);
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
                    logError(stackTrace);
                    return Text(error.toString());
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
