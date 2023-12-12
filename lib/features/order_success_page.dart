import 'package:flutter/material.dart';
import 'package:food_app/core/constants/styles_constants.dart';
import 'package:food_app/core/shared_widgets/button.dart';
import 'package:gap/gap.dart';

class OrderSuccessPage extends StatefulWidget {
  const OrderSuccessPage({super.key});

  @override
  State<OrderSuccessPage> createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200, borderRadius: const BorderRadius.all(Radius.circular(100))),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Pallete.lightGreen,
                  child: Icon(
                    Icons.check,
                    color: Pallete.white,
                    size: 40,
                  ),
                ),
              ),
              const Gap(30),
              Text('Congratulations!!!', style: AppStyles.headLineText),
              const Gap(10),
              Text(
                textAlign: TextAlign.center,
                'Your order has been taken and\n is attended to',
                style: AppStyles.bodyText,
              ),
              const Gap(40),
              AppButton(
                fullWidth: false,
                onPressed: () {},
                text: 'Track order',
                width: 100,
              ),
              const Gap(40),
              AppButton(
                fullWidth: false,
                outlined: true,
                onPressed: () {},
                text: 'Continue shopping',
                width: 180,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
