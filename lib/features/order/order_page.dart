import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/features/location/location_page.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/assets_constants.dart';
import '../../core/constants/styles_constants.dart';
import '../../core/shared_widgets/button.dart';
import '../../core/shared_widgets/textfield.dart';
import '../location/location_provider.dart';

class OrderPage extends ConsumerStatefulWidget {
  const OrderPage({super.key});

  @override
  ConsumerState<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends ConsumerState<OrderPage> {
  final box = Hive.box('appBox');
  bool cashOnDelivery = false;
  bool mobileMoney = false;
  final fullNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  List itemList = [];

  final locationCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    itemList = box.get('cartItems', defaultValue: []);
  }

  @override
  void dispose() {
    super.dispose();
    fullNameCtrl.dispose();
    phoneCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Address & Payment')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          reverse: true,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    Assets.orderIcon,
                    height: 250,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FilterChip(
                          selected: cashOnDelivery,
                          showCheckmark: false,
                          checkmarkColor: Pallete.orange,
                          avatar: const Icon(Icons.money),
                          label: const Text('Cash on delivery'),
                          onSelected: (isSelected) {
                            setState(() {
                              cashOnDelivery = isSelected;
                              mobileMoney = !isSelected;
                            });
                          }),
                      // const Gap(40),
                      FilterChip(
                          selected: mobileMoney,
                          showCheckmark: false,
                          checkmarkColor: Pallete.orange,
                          avatar: const Icon(Icons.mobile_friendly),
                          label: const Text('Mobile Money'),
                          onSelected: (isSelected) {
                            setState(() {
                              mobileMoney = isSelected;
                              cashOnDelivery = !isSelected;
                            });
                          }),
                    ],
                  ),
                  const Gap(30),
                  AppTextField(
                    prefixIcon: Icon(Icons.person_2_outlined, color: Colors.grey.shade400),
                    borderColor: Colors.grey.shade400,
                    labelText: 'Enter full name',
                  ),
                  const Gap(30),
                  AppTextField(
                    prefixIcon: Icon(Icons.phone_android_rounded, color: Colors.grey.shade400),
                    keyboardType: TextInputType.number,
                    borderColor: Colors.grey.shade400,
                    labelText: 'Enter phone number',
                  ),
                  const Gap(30),
                  Consumer(
                    builder: (context, ref, child) {
                      final address = ref.watch(locationProvider);
                      return AppTextField(
                        prefixIcon: Icon(Icons.location_on_outlined, color: Colors.grey.shade400),
                        suffixIcon: const Icon(
                          Icons.chevron_right_outlined,
                        ),
                        readOnly: true,
                        initialValue: address,
                        // controller: locationCtrl,
                        onTap: () => Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => const LocationPage())),
                        borderColor: Colors.grey.shade400,
                        labelText: 'Place of delivery',
                      );
                    },
                  ),
                  const Gap(30),
                  AppButton(
                    text: 'Proceed',
                    onPressed: () {
                      ref.invalidate(locationProvider);
                    },
                  ),
                  // Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
