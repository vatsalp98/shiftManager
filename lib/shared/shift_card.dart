import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

Widget ShiftCard(String shiftStatus, String shiftType, String date,
    double screenHeight, double cardHeight) {
  return Container(
    height: cardHeight,
    decoration: const BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 10,
          offset: Offset(2, 2),
        )
      ],
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    child: Column(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(),
                  decoration: BoxDecoration(
                    color: shiftStatus == "initial"
                        ? HexColor('#D2042D')
                        : Colors.green,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "$shiftType Shift",
                          style: TextStyle(
                            fontSize: screenHeight / 50,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          DateFormat('dd MMM yyyy')
                              .format(DateTime.parse(date)),
                          style: TextStyle(
                            fontSize: screenHeight / 50,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Start',
                      style: TextStyle(
                        fontSize: screenHeight / 50,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "07.00",
                      style: TextStyle(
                        fontSize: screenHeight / 45,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'End',
                      style: TextStyle(
                        fontSize: screenHeight / 50,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "13:00",
                      style: TextStyle(
                        fontSize: screenHeight / 45,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
