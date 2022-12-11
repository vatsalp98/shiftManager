import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget NoShiftCard(double screenHeight) {
  return Container(
    height: 170,
    decoration: const BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 10,
          offset: Offset(2, 2),
        )
      ],
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                'You have no shifts today!',
                style: TextStyle(
                  fontSize: screenHeight / 45,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
            SvgPicture.asset(
              'assets/svg/no_data.svg',
              height: 100,
              width: 100,
            ),
          ],
        ),
      ],
    ),
  );
}
