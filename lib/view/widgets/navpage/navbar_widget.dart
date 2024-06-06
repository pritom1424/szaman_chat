import 'package:flutter/material.dart';
import 'package:szaman_chat/utils/constants/app_colors.dart';
import 'package:szaman_chat/utils/constants/data.dart';

class NavBarWidget extends StatelessWidget {
  final int currentIndex;
  final void Function(int)? onTap;
  const NavBarWidget({super.key, required this.currentIndex, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(

        // margin: const EdgeInsets.all(20),
        /* decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 0, 0, 0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 30,
                  offset: const Offset(0, 10))
            ],
            borderRadius: BorderRadius.circular(30)), */
        child: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.grey[200],
      unselectedItemColor: Colors.grey[600],
      selectedItemColor: Appcolors.appThemeColor,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      currentIndex: currentIndex,
      iconSize: 22,
      onTap: onTap, //_onItemTapped
      items: List.generate(
          Data.navBarData.length,
          (index) => BottomNavigationBarItem(
              icon: Icon(
                Data.navBarData[index].entries.toList()[0].value,
              ),
              label: Data.navBarData[index].entries.toList()[0].key)),
    ));
  }
}
