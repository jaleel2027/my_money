import 'package:flutter/material.dart';
import 'package:my_money/screens/home/homescreen.dart';

class HomeBottomNavigation extends StatelessWidget {
  const HomeBottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HomeScreen.selectedIndexNotifier,
      builder: (ctx, int updatedIndex, Widget? _) {
       return BottomNavigationBar(
         selectedItemColor: Color(0xFF750FB5),
            unselectedItemColor: Colors.grey,
            currentIndex: updatedIndex,
            onTap: (newIndex){
              HomeScreen.selectedIndexNotifier.value = newIndex;
            },
            items: [BottomNavigationBarItem(icon: Icon(Icons.home),
              label: 'Transactions',),
              BottomNavigationBarItem(icon: Icon(Icons.category),
                label: 'Categories',
              )]);
      },

    );
  }
}
