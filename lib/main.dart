import 'package:chicken_fan/bottom_nav.dart';
import 'package:chicken_fan/homeScreen.dart';
import 'package:chicken_fan/homeScreen2.dart';
import 'package:flutter/material.dart';
import 'package:wifi/wifi.dart';
import 'package:ping_discover_network/ping_discover_network.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  final List<BottomNav> itemsNav = <BottomNav>[
    BottomNav('Lantai 2', Icons.looks_two, Colors.teal),
    BottomNav('Lantai 1', Icons.looks_one, Colors.teal)
  ];

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin<MyApp> {
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     theme: ThemeData(
  //       primaryColor: Colors.white
  //     ),
  //     home: HomeScreen(),
  //   );
  // }
  int currentIndex = 0;
  BuildContext ctx;

  void onBackPress(){
    if(Navigator.of(ctx).canPop()){
      Navigator.of(ctx).pop();
    }
  }

  final List<Widget> _children = [
    HomeScreen(),
    HomeScreen2()
  ];

  @override
  Widget build(BuildContext context) {
    ctx = context;
    BottomNav curItem = widget.itemsNav[currentIndex];
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white
        ),
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        body: _children[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.teal,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[400],
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: widget.itemsNav.map((BottomNav d){
            return BottomNavigationBarItem(
              backgroundColor: d.color,
              icon: Icon(d.icon),
              label: d.title,
            );
          }).toList(),
        ),
      ),
    );
  }

}
