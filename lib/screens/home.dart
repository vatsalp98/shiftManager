import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Hi, There!'),
                    ],
                  ),
                  SvgPicture.asset(
                    'assets/svg/hello.svg',
                    height: 55,
                    width: 55,
                  ),
                ],
              ),
              titlePadding: EdgeInsets.only(bottom: 10, left: 15, right: 10),
              collapseMode: CollapseMode.none,
            ),
            leadingWidth: 0,
            backgroundColor: HexColor('#004d40'),
            expandedHeight: 160,
            centerTitle: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [],
            ),
          ),
        ],
      ),
    );
  }
}
