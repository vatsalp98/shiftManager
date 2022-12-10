import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shift_manager/screens/schedule.dart';
import 'package:shift_manager/screens/settings.dart';
import 'package:hexcolor/hexcolor.dart';
import '../screens/home.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late PersistentTabController tabController;
  int currentIndex = 0;

  @override
  void initState() {
    tabController = PersistentTabController(initialIndex: 0);
    super.initState();
  }

  final List<IconData> _navIcons = [
    Icons.home_rounded,
    Icons.calendar_month_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: 8,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < _navIcons.length; i++) ...<Expanded>{
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = i;
                      });
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _navIcons[i],
                            color: i == currentIndex
                                ? HexColor('#D2042D')
                                : Colors.black54,
                            size: i == currentIndex ? 34 : 26,
                          ),
                          i == currentIndex
                              ? Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  height: 3,
                                  width: 22,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: Colors.red,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              }
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          HomeScreen(),
          const ScheduleScreen(),
          const SettingsScreen(),
        ],
      ),
    );
  }
}
