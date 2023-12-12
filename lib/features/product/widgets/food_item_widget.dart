import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/styles_constants.dart';

class FoodItemWidget extends StatelessWidget {
  final String? name;
  final int? price;
  final int? quantity;
  final String? imageUrl;
  final String? description;
  final VoidCallback? onTap;
  const FoodItemWidget({super.key, this.name, this.price, this.imageUrl, this.description, this.onTap, this.quantity});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Flex(direction: Axis.vertical, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CachedNetworkImage(imageUrl: '$imageUrl', width: 80, height: 80),
            const Gap(10),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$name',
                      style: AppStyles.bodyText.copyWith(
                        fontSize: 20,
                        // fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Text(
                      maxLines: 2,
                      description!.substring(1, description!.length - 1),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Pallete.grey, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            // const Spacer(),
            Text('${quantity ?? ''}'),
            const SizedBox(width: 10),
            Icon(Icons.favorite_outline_rounded, color: Pallete.orange.withOpacity(0.6)),
          ],
        ),
        // Stars and price
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              children: [
                Icon(
                  Icons.star_border_rounded,
                  color: Colors.orange.shade200,
                  size: 15,
                ),
                Icon(
                  Icons.star_border_rounded,
                  color: Colors.orange.shade200,
                  size: 15,
                ),
                Icon(
                  Icons.star_border_rounded,
                  color: Colors.orange.shade200,
                  size: 15,
                ),
                Icon(
                  Icons.star_border_rounded,
                  color: Colors.orange.shade200,
                  size: 15,
                ),
                Icon(
                  Icons.star_border_rounded,
                  color: Colors.orange.shade200,
                  size: 15,
                ),
              ],
            ),
            Wrap(
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
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Pallete.lightOrange,
                  child: Icon(
                    Icons.add,
                    size: 16,
                    color: Pallete.orange,
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
