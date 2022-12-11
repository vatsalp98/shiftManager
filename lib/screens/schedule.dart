import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../repositories/data_repo.dart';
import '../shared/styles.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late CalendarFormat tableFormat;
  final now = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  var dateFormat = DateFormat('EEEE dd-MM-yyyy');
  var availability = 'Time Interval';
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

  @override
  void initState() {
    tableFormat = CalendarFormat.twoWeeks;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 55, left: 10, bottom: 5),
            child: Text(
              'Schedule',
              style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.red.shade50,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(2, 2),
                  )
                ],
              ),
              child: TableCalendar(
                focusedDay: _focusedDate,
                firstDay: now,
                lastDay: now.add(const Duration(days: 50)),
                selectedDayPredicate: ((day) => isSameDay(day, _focusedDate)),
                onDaySelected: ((selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDate, selectedDay)) {
                    setState(() {
                      _selectedDate = selectedDay;
                      _focusedDate = focusedDay;
                      //_events = _getEventsForDay(selectedDay);
                    });
                  }
                }),
                calendarFormat: tableFormat,
                onFormatChanged: ((format) {
                  setState(() {
                    tableFormat = format;
                  });
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
                  formatButtonVisible: true,
                  titleTextStyle: CustomStyles.screenTitleTextStyle,
                  leftChevronVisible: true,
                  titleCentered: true,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: Text(
              'Select your Shifts',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 15, right: 10),
            child: SizedBox(
              height: 350,
              child: FutureBuilder(
                future: DataRepo().listShiftUsers(),
                builder: (context, snap) {
                  if (snap.hasData &&
                      snap.connectionState == ConnectionState.done) {
                    var data = snap.data as Map;
                    // print(data);
                    return ListView.builder(
                      itemCount: data['data'].length,
                      itemBuilder: (context, index) {
                        var item = data['data'][index];
                        return Container(
                          height: 120,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(),
                                  decoration: BoxDecoration(
                                    color: item['shiftStatus'] == "initial"
                                        ? HexColor('#D2042D')
                                        : Colors.green,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${item['shift']['shiftType']} Shift",
                                          style: TextStyle(
                                            fontSize: screenHeight / 50,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('dd MMM yyyy').format(
                                              DateTime.parse(item['date'])),
                                          style: TextStyle(
                                            fontSize: screenHeight / 50,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                        // Text(
                                        //   item['shiftStatus'],
                                        //   style: TextStyle(
                                        //     fontSize:
                                        //         screenHeight /
                                        //             50,
                                        //     fontWeight:
                                        //         FontWeight.w500,
                                        //     color: Colors.white,
                                        //   ),
                                        // ),
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
                                      'Check In',
                                      style: TextStyle(
                                        fontSize: screenHeight / 50,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      item['shift']['startTime']
                                          .substring(0, 5),
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
                                      'Check Out',
                                      style: TextStyle(
                                        fontSize: screenHeight / 50,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      item['shift']['endTime'].substring(0, 5),
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
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
