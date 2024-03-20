import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/colors.dart';

class CartItemWidget extends StatelessWidget {
  final String? name;
  final int? price;
  final int? quantity;
  final String? imageUrl;
  final String? addonList;
  final List? description;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  const CartItemWidget(
      {super.key,
      this.name,
      this.price,
      this.quantity,
      this.imageUrl,
      this.onTap,
      this.addonList,
      this.description,
      this.onDelete});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Flex(direction: Axis.vertical, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network('$imageUrl', width: 80, height: 80),
            const Gap(10),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$name',
                    style: AppStyles.bodyText.copyWith(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: Text(
                      maxLines: 2,
                      addonList!.substring(1, addonList!.length - 1),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Pallete.grey, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: InkWell(
                onTap: onDelete,
                child: CircleAvatar(
                  backgroundColor: Pallete.orange.withOpacity(0.1),
                  radius: 20,
                  child: Icon(
                    Icons.delete_forever_outlined,
                    color: Pallete.orange,
                  ),
                ),
              ),
            ),
          ],
        ),
        // Stars and price
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Flex(
              direction: Axis.horizontal,
              children: [
                Text.rich(
                  style: GoogleFonts.robotoMono(fontSize: 20, color: Pallete.darkBlue),
                  TextSpan(
                    text: price.toString(),
                    children: [
                      TextSpan(
                        text: ' FCFA',
                        style: AppStyles.bodyText.copyWith(fontSize: 13, color: Pallete.darkBlue),
                      ),
                    ],
                  ),
                ),
                const Gap(20),
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Pallete.orange,
                  child: Text(
                    '$quantity ',
                    textAlign: TextAlign.center,
                    // style: AppStyles.bodyText.copyWith(color: Pallete.white),
                    style: TextStyle(color: Pallete.white, fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        )
      ]),
    );
  }
}
