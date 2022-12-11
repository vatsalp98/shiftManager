import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../repositories/data_repo.dart';
import '../shared/noShiftCard.dart';
import '../shared/shiftCard.dart';
import '../shared/styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  _fetchShifts() async {
    final response = await DataRepo().listShiftUsers();
    if (!response['errorsExists']) {
      return response;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60.0, left: 7, right: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Welcome,',
                          style: TextStyle(
                            fontSize: screenHeight / 45,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        FutureBuilder(
                          future: Amplify.Auth.getCurrentUser(),
                          builder: (context, snap) {
                            if (snap.hasData &&
                                snap.connectionState == ConnectionState.done) {
                              var data = snap.data;
                              return Text(
                                data!.username,
                                style: TextStyle(
                                  fontSize: screenHeight / 55,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                      'assets/svg/hello.svg',
                      height: 65,
                      width: 65,
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 9.0, top: 25),
                child: Text(
                  "Today's Status",
                  style: CustomStyles.screenTitleTextStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 9.0),
                child: Text(
                  DateFormat('dd MMMM yyyy').format(DateTime.now()),
                  style: TextStyle(
                    fontSize: screenHeight / 45,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 15),
                child: Container(
                  height: screenHeight,
                  child: FutureBuilder(
                    future: _fetchShifts(),
                    builder: (context, snap) {
                      if (snap.hasData &&
                          snap.connectionState == ConnectionState.done) {
                        var data = snap.data as Map;
                        if (data['empty']) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NoShiftCard(screenHeight),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 9.0, top: 30),
                                child: Text(
                                  'Upcoming Shifts',
                                  style: TextStyle(
                                    fontSize: screenHeight / 40,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 9.0, bottom: 50),
                                child: Text(
                                  '(Red Background = Unconfirmed, Green = Confirmed), Tap on a shift to Confirm or Cancel it',
                                  style: TextStyle(
                                    fontSize: screenHeight / 68,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Center(
                                child: SvgPicture.asset(
                                  'assets/svg/no_data.svg',
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Text(
                                    'No Upcoming shifts Found!',
                                    style: TextStyle(
                                      fontSize: screenHeight / 45,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          for (var item in data['data']) {
                            if (DateTime.parse(item['date']).day ==
                                DateTime.now().day) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      if (item['shiftStatus'] == "initial") {
                                        final response = await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Confirm Shift'),
                                              content: Text(
                                                  'Are you sure you want to confirm this shit on ${item['date']} in the ${item['shift']['shiftType']} Shift from ${item['shift']['startTime'].substring(0, 5)} to ${item['shift']['endTime'].substring(0, 5)} ?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, false);
                                                  },
                                                  child: Text('Cancel'),
                                                ),
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      final response =
                                                          await DataRepo()
                                                              .updateShiftUser(
                                                                  item['id'],
                                                                  'confirmed');
                                                      print(response);
                                                      if (!response[
                                                          'errorsExists']) {
                                                        Navigator.pop(
                                                            context, true);
                                                        setState(() {});
                                                      }
                                                    },
                                                    child: Text('Confirm')),
                                              ],
                                            );
                                          },
                                        );
                                        response
                                            ? ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Successfully Confirmed Shift!'),
                                                  backgroundColor: Colors.green,
                                                ),
                                              )
                                            : ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Cancelled, Shift Not Confirmed!'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Already Confirmed Shift!'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }
                                    },
                                    child: ShiftCard(
                                      item['shiftStatus'],
                                      item['shift']['shiftType'],
                                      item['date'],
                                      item['shift']['startTime'],
                                      item['shift']['endTime'],
                                      screenHeight,
                                      180,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 9.0, top: 30),
                                    child: Text(
                                      'Upcoming Shifts',
                                      style: TextStyle(
                                        fontSize: screenHeight / 40,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 9.0, bottom: 5),
                                    child: Text(
                                      '(Red Background = Unconfirmed, Green = Confirmed), Tap on a shift to Confirm or Cancel it',
                                      style: TextStyle(
                                        fontSize: screenHeight / 68,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 300,
                                    child: ListView(
                                      physics: const BouncingScrollPhysics(),
                                      children: [
                                        for (var item in data['data'])
                                          ShiftCard(
                                            item['shiftStatus'],
                                            item['shift']['shiftType'],
                                            item['date'],
                                            item['shift']['startTime'],
                                            item['shift']['endTime'],
                                            screenHeight,
                                            150,
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10.0),
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 9.0, top: 30),
                                    child: Text(
                                      'Upcoming Shifts',
                                      style: TextStyle(
                                        fontSize: screenHeight / 40,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 9.0, bottom: 5),
                                    child: Text(
                                      '(Red Background = Unconfirmed, Green = Confirmed), Tap on a shift to Confirm or Cancel it',
                                      style: TextStyle(
                                        fontSize: screenHeight / 68,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 300,
                                    child: ListView(
                                      physics: const BouncingScrollPhysics(),
                                      children: [
                                        for (var item in data['data'])
                                          ShiftCard(
                                            item['shiftStatus'],
                                            item['shift']['shiftType'],
                                            item['date'],
                                            item['shift']['startTime'],
                                            item['shift']['endTime'],
                                            screenHeight,
                                            150,
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                          }
                          return Container();
                        }
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
