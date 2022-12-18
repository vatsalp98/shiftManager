import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../repositories/data_repo.dart';
import '../shared/styles.dart';

class AvailabilityScreen extends StatefulWidget {
  const AvailabilityScreen({Key? key}) : super(key: key);

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  late CalendarFormat tableFormat;
  final now = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  var dateFormat = DateFormat('EEEE dd MMMM yyyy');
  var availability = 'Time Interval';
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  bool _am = false;
  bool _pm = false;
  late Future listAvailabilityFuture;

  @override
  void initState() {
    tableFormat = CalendarFormat.twoWeeks;
    super.initState();
    listAvailabilityFuture = DataRepo()
        .listAvailabilityUser(DataRepo().awsDateFormat.format(_selectedDate));
  }

  // fetchEvents() async {
  //   final user = await Amplify.Auth.getCurrentUser();
  //   final response = await DataRepo().listAvailabilityUser(
  //       user.userId, DataRepo().awsDateFormat.format(_selectedDate));
  //   if (!response['errorsExists']) {
  //     return response;
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Availability',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_left_rounded,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
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
                child: TableCalendar(
                  focusedDay: _focusedDate,
                  firstDay: now,
                  lastDay: now.add(const Duration(days: 21)),
                  selectedDayPredicate: ((day) => isSameDay(day, _focusedDate)),
                  onDaySelected: ((selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDate, selectedDay)) {
                      setState(() {
                        _selectedDate = selectedDay;
                        _focusedDate = focusedDay;
                        //_events = _getEventsForDay(selectedDay);
                        listAvailabilityFuture = DataRepo()
                            .listAvailabilityUser(
                                DataRepo().awsDateFormat.format(_selectedDate));
                      });
                    }
                  }),
                  calendarFormat: tableFormat,
                  onFormatChanged: ((format) {
                    tableFormat = format;
                  }),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    weekendStyle: TextStyle(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleTextStyle: CustomStyles.screenTitleTextStyle,
                    leftChevronVisible: true,
                    titleCentered: true,
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      shape: BoxShape.circle,
                    ),
                    outsideDaysVisible: false,
                    selectedTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.red.shade400,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Text(
                'List of Availabilities',
                style: CustomStyles.screenTitleTextStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                height: 150,
                child: FutureBuilder(
                  builder: (context, snap) {
                    if (snap.hasData &&
                        snap.connectionState == ConnectionState.done) {
                      var data = snap.data as Map;
                      if (!data['empty']) {
                        return ListView.builder(
                          itemCount: data['data'].length,
                          itemBuilder: (context, index) {
                            var item = data['data'][index];
                            return ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: const BorderSide(color: Colors.black),
                              ),
                              title: Text("Date: ${item['date']}"),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_forever_rounded,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  final response = await DataRepo()
                                      .deleteAvailabilityUser(item['id']);
                                  if (!response['errorsExists']) {
                                    setState(() {});
                                  }
                                },
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Text("Type: ${item['type']}")],
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: SvgPicture.asset(
                                    'assets/svg/no_data.svg',
                                    height: 75,
                                    width: 75,
                                  ),
                                ),
                                const Text(
                                  'No Data',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      );
                    }
                  },
                  future: listAvailabilityFuture,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: Text(
                'Set your Availability',
                style: CustomStyles.screenTitleTextStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10, bottom: 10, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Date',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    dateFormat.format(_selectedDate),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Availability',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  ToggleButtons(
                      isSelected: [_am, _pm],
                      onPressed: (int index) {
                        if (index == 0) {
                          setState(() {
                            _am = true;
                            _pm = false;
                          });
                        } else if (index == 1) {
                          setState(() {
                            _am = false;
                            _pm = true;
                          });
                        }
                      },
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      selectedColor: Colors.white,
                      fillColor: HexColor('#893F45'),
                      borderColor: HexColor('#893F45'),
                      selectedBorderColor: HexColor('#893F45'),
                      borderWidth: 2,
                      splashColor: HexColor('#893F45'),
                      constraints:
                          const BoxConstraints.expand(width: 80, height: 40),
                      children: const [Text('AM'), Text('PM')]),
                ],
              ),
            ),
            // ListTile(
            //   title: Text(
            //     availability,
            //     style: const TextStyle(
            //       fontWeight: FontWeight.w500,
            //     ),
            //   ),
            //   subtitle: const Text(
            //     'Start Time',
            //     style: TextStyle(
            //       fontWeight: FontWeight.w500,
            //     ),
            //   ),
            //   trailing: IconButton(
            //     onPressed: () async {
            //       TimeRange result =
            //           await showTimeRangePicker(context: context);
            //       setState(() {
            //         availability =
            //             "From: ${result.startTime.hour}:${result.startTime.minute} TO ${result.endTime.hour}:${result.endTime.minute}";
            //         startTime = DateTime(now.year, now.month, now.day,
            //             result.startTime.hour, result.startTime.minute);
            //         endTime = DateTime(now.year, now.month, now.day,
            //             result.endTime.hour, result.endTime.minute);
            //       });
            //     },
            //     icon: const Icon(
            //       Icons.punch_clock_rounded,
            //       color: Colors.redAccent,
            //     ),
            //   ),
            // ),
            const Padding(
              padding: EdgeInsets.only(top: 45),
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    var user = await Amplify.Auth.getCurrentUser();
                    var response = await DataRepo().createAvailabilityUser(
                        user.userId, _am ? "AM" : "PM", _selectedDate);
                    if (!response['errorsExists'] && !response['empty']) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save')),
            ),
          ],
        ),
      ),
    );
  }
}
