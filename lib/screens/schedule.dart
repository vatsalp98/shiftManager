import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return Scaffold(
      backgroundColor: Colors.black12,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        clipBehavior: Clip.antiAlias,
        slivers: [
          const SliverAppBar(
            floating: true,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Shift Manager'),
              expandedTitleScale: 1.5,
              centerTitle: true,
              stretchModes: [
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
            ),
            expandedHeight: 80,
            backgroundColor: Colors.red,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red.shade50,
                      ),
                      child: TableCalendar(
                        focusedDay: _focusedDate,
                        firstDay: now,
                        lastDay: now.add(const Duration(days: 50)),
                        selectedDayPredicate: ((day) =>
                            isSameDay(day, _focusedDate)),
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
                      style: CustomStyles.sectionTitleTextStyle,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, top: 15, right: 10),
                    child: SizedBox(
                      height: 350,
                      child: FutureBuilder(
                        future: DataRepo().listShiftUsers(),
                        builder: (context, snap) {
                          if (snap.hasData &&
                              snap.connectionState == ConnectionState.done) {
                            var data = snap.data as Map;
                            return ListView.builder(
                              itemCount: data['data'].length,
                              itemBuilder: (context, index) {
                                var item = data['data'][index];
                                return ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: const BorderSide(color: Colors.black),
                                  ),
                                  title: Text(
                                    '${item['shift']['shiftType']} Shift',
                                    style: CustomStyles.screenTitleTextStyle,
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Date: ${item['shift']['date']}",
                                        style: CustomStyles.bodyTextStyle,
                                      ),
                                      Text(
                                        'Status: ${item['shift']['status']}',
                                        style: CustomStyles.bodyTextStyle,
                                      ),
                                      Text(
                                        'Type: ${item['shift']['shiftType']}',
                                        style: CustomStyles.bodyTextStyle,
                                      ),
                                      Text(
                                        'Location: ${item['shift']['region']['city']}, ${item['shift']['region']['province']}',
                                        style: CustomStyles.bodyTextStyle,
                                      )
                                    ],
                                  ),
                                  isThreeLine: true,
                                  trailing: item['shiftStatus'] == 'initial'
                                      ? IconButton(
                                          icon: const Icon(
                                              Icons.calendar_month_rounded),
                                          onPressed: () async {
                                            final response = await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Confirm Shift"),
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          'Are you sure you want to confirm this shift on ${item['shift']['date']} from ${item['shift']['startTime'].substring(0, 5)} to ${item['shift']['endTime'].substring(0, 5)} ?',
                                                          style: CustomStyles
                                                              .bodyTextStyle,
                                                        ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                            content: Text(
                                                                'Cancelled'),
                                                            backgroundColor:
                                                                Colors.yellow,
                                                          ));
                                                          Navigator.pop(
                                                              context, false);
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          final result =
                                                              await DataRepo()
                                                                  .updateShiftUser(
                                                                      item[
                                                                          'id'],
                                                                      'confirmed');
                                                          if (!result[
                                                              'errorsExists']) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    const SnackBar(
                                                              content: Text(
                                                                  'Shift Confirmed'),
                                                              backgroundColor:
                                                                  Colors.green,
                                                            ));
                                                            Navigator.pop(
                                                                context, true);
                                                          }
                                                        },
                                                        child: const Text('Ok'),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                        )
                                      : const Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.green,
                                          size: 27,
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
            ]),
          ),
        ],
      ),
    );
  }
}
