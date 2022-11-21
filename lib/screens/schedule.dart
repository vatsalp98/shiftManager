import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';
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
  List _events = [];
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.red.shade100.withOpacity(0.5),
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
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: const Text(
              'Select your Shifts',
              style: CustomStyles.sectionTitleTextStyle,
            ),
          ),

        ],
      ),
    );
  }
}
