import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/core/constants/assets_constants.dart';

import '../../../core/constants/styles_constants.dart';

class LocationListTile extends StatelessWidget {
  const LocationListTile({
    super.key,
    required this.location,
    required this.press,
  });

  final String location;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: press,
          horizontalTitleGap: 0,
          leading: SvgPicture.asset(
            Assets.locationPinIcon,
            height: 18,
            colorFilter: ColorFilter.mode(Pallete.grey, BlendMode.srcIn),
          ),
          title: Text(
            location,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: Pallete.grey.withOpacity(0.4),
        ),
      ],
    );
  }
}
