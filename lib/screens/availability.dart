import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_range_picker/time_range_picker.dart';

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
  var dateFormat = DateFormat('EEEE dd-MM-yyyy');
  var availability = 'Time Interval';
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

  @override
  void initState() {
    tableFormat = CalendarFormat.twoWeeks;
    super.initState();
  }

  fetchEvents() async {
    final user = await Amplify.Auth.getCurrentUser();
    final response = await DataRepo().listAvailabilityUser(
        user.userId, DataRepo().awsDateFormat.format(_selectedDate));
    if (!response['errorsExists']) {
      return response;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Availability'),
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
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey, blurRadius: 2, spreadRadius: 2),
                  ],
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red.shade100,
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
                style: CustomStyles.sectionTitleTextStyle,
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
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            var item = data['data'][index];
                            return ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: const BorderSide(color: Colors.white),
                              ),
                              title: Text("Date: ${item['date']}"),
                              isThreeLine: true,
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_forever_rounded),
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
                                children: [
                                  Text("Start Time: ${item['startTime']}"),
                                  Text("End Time: ${item['endTime']}"),
                                ],
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
                  future: fetchEvents(),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Text(
                'Set your Availability',
                style: CustomStyles.sectionTitleTextStyle,
              ),
            ),
            ListTile(
              title: Text(
                dateFormat.format(_selectedDate),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              subtitle: const Text(
                'Date',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ListTile(
              title: Text(
                availability,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: const Text(
                'Start Time',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: IconButton(
                onPressed: () async {
                  TimeRange result =
                      await showTimeRangePicker(context: context);
                  setState(() {
                    availability =
                        "From: ${result.startTime.hour}:${result.startTime.minute} TO ${result.endTime.hour}:${result.endTime.minute}";
                    startTime = DateTime(now.year, now.month, now.day,
                        result.startTime.hour, result.startTime.minute);
                    endTime = DateTime(now.year, now.month, now.day,
                        result.endTime.hour, result.endTime.minute);
                  });
                },
                icon: const Icon(
                  Icons.punch_clock_rounded,
                  color: Colors.redAccent,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5),
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    var user = await Amplify.Auth.getCurrentUser();
                    var response = await DataRepo().createAvailabilityUser(
                        user.userId, startTime, endTime, _selectedDate);
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
