import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';
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
        title: const Text('Availability'),
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
              'Set your Availability',
              style: CustomStyles.sectionTitleTextStyle,
            ),
          ),
          ListTile(
            title: Text(dateFormat.format(_selectedDate)),
            subtitle: Text('Date'),
          ),
          ListTile(
            title: Text(availability),
            subtitle: Text('Start Time'),
            trailing: IconButton(
              onPressed: () async {
                TimeRange result = await showTimeRangePicker(context: context);
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
          Center(
            child: ElevatedButton(onPressed: () {}, child: const Text('Save')),
          ),
        ],
      ),
    );
  }
}
