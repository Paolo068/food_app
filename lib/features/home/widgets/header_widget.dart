import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/assets_constants.dart';
import '../../../core/constants/styles_constants.dart';
import '../../../core/shared_widgets/textfield.dart';
import '../../cart/cart_page.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CartPage())),
              child: Column(
                children: [
                  SvgPicture.asset(
                    Assets.shoppingBasketIcon,
                    colorFilter: ColorFilter.mode(Pallete.orange, BlendMode.srcIn),
                  ),
                  Text(
                    'My basket',
                    style: AppStyles.bodyText.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  )
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
                onChanged: (value) {},
                borderColor: Pallete.grey,
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Pallete.grey,
                ),
                hintText: 'Search your favorite pizza',
              ),
            ),
            const Gap(16),
            SvgPicture.asset(
              Assets.filterIcon,
              colorFilter: ColorFilter.mode(Pallete.darkBlue, BlendMode.srcIn),
            ),
          ],
        ),
      ],
    );
  }
}
