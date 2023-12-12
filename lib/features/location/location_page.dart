import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_app/core/constants/assets_constants.dart';
import 'package:food_app/core/shared_widgets/textfield.dart';
import 'package:food_app/features/order/order_page.dart';
import 'package:gap/gap.dart';

import '../../core/constants/styles_constants.dart';
import '../../core/shared_widgets/loader.dart';
import '../../utils.dart';
import 'location_provider.dart';
import 'widgets/location_list_tile.dart';

class LocationPage extends ConsumerStatefulWidget {
  const LocationPage({super.key});

  @override
  ConsumerState<LocationPage> createState() => _LocationScreenState();
}

class _LocationScreenState extends ConsumerState<LocationPage> {
  final locationCtrl = TextEditingController();
  List placePredictions = [];
  String placeNotFound = '';
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    locationCtrl.dispose();
  }

  placeAutoComplete(String query) async {
    setState(() {
      isLoading = true;
    });
    Response response = await Dio(
      BaseOptions(
        queryParameters: {
          "key": "rSxB87q4amXPkn7FQ7xj",
          "limit": 5,
          "country": "cm",
        },
      ),
    ).get('https://api.maptiler.com/geocoding/$query.json');
    List addresses = response.data['features'];
    setState(() {
      isLoading = false;
    });
    logInfo('Addresses =============> $addresses');
    setState(() {
      placePredictions = addresses;
    });
    if (addresses.isEmpty) {
      setState(() {
        placeNotFound = 'No place found!';
      });
    } else {
      setState(() {
        placeNotFound = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            backgroundColor: Pallete.grey.withOpacity(0.3),
            child: SvgPicture.asset(
              Assets.locationIcon,
              colorFilter: ColorFilter.mode(Pallete.black, BlendMode.srcIn),
            ),
          ),
        ),
        title: Text(
          "Set Delivery Location",
          style: TextStyle(color: Pallete.grey),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Pallete.grey.withOpacity(0.3),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close, color: Colors.black),
            ),
          ),
          const SizedBox(width: 16)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Form(
              child: AppTextField(
                controller: locationCtrl,
                labelText: "Search your location",
                borderColor: Pallete.grey,
                onChanged: (value) {
                  placeAutoComplete(value);
                },
                textInputAction: TextInputAction.search,
              ),
            ),
            const Gap(10),
            ElevatedButton.icon(
              onPressed: () {},
              icon: SvgPicture.asset(
                Assets.locationIcon,
                colorFilter: ColorFilter.mode(Pallete.darkBlue, BlendMode.srcIn),
                height: 20,
              ),
              label: Text(
                "Use my current location",
                style: AppStyles.bodyText,
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(screen.width, 45),
                backgroundColor: Pallete.lightGrey300,
                foregroundColor: Pallete.darkBlue,
                elevation: 0,
                fixedSize: const Size(double.infinity, 40),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const Gap(10),
            Divider(
              height: 1,
              thickness: 1,
              color: Pallete.grey.withOpacity(0.4),
            ),
            Expanded(
              child: isLoading
                  ? const Loader()
                  : placePredictions.isEmpty
                      ? Center(
                          child: Text(
                          placeNotFound,
                          style: AppStyles.headLineText,
                        ))
                      : ListView.builder(
                          itemCount: placePredictions.length,
                          itemBuilder: (context, index) {
                            return LocationListTile(
                              press: () {
                                ref.read(locationProvider.notifier).setLocation(placePredictions[index]['place_name']);
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(builder: (context) => const OrderPage()));
                              },
                              location: placePredictions[index]['place_name'],
                            );
                          },
                        ),
            )
          ],
        ),
      ),
    );
  }
}
