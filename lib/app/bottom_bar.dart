import 'package:app/add_capsule/screens/add_capsule_screen.dart';
import 'package:app/feed/screens/feed_screen.dart';
import 'package:app/friends/screens/friend_screen.dart';
import 'package:app/notifications/screens/notification_screen.dart';
import 'package:app/capsules/screens/capsule_screen.dart';
import 'package:app/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class BottomBar extends StatelessWidget {
  BottomBar({
    Key? key,
  }) : super(key: key);

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

 

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      
      context,

      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: MemoraColors.bottomBarBackgroundColor,
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar:Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style5, // Choose the nav bar style with this property.

    
    );
  }

  List<Widget> _buildScreens() {
    return [ FeedScreen() ,AddCapsuleScreen(),  CapsuleScreen() ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
        PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: "Home",
        activeColorPrimary: MemoraColors.bottomBarActiveItemColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.add_circled_solid),
        title: "Add",
        activeColorPrimary: MemoraColors.bottomBarActiveItemColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.capsule),
        title: "Capsules",
       activeColorPrimary: MemoraColors.bottomBarActiveItemColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      //  PersistentBottomNavBarItem(
      //   icon: Icon(CupertinoIcons.settings),
      //   title: "Settings",
      //   activeColorPrimary: MemoraColors.bottomBarActiveItemColor,
      //   inactiveColorPrimary: CupertinoColors.systemGrey,
      // ),
      //  PersistentBottomNavBarItem(
      //   icon: Icon(CupertinoIcons.bell),
      //   title: "Notifications",
      //   activeColorPrimary: MemoraColors.bottomBarActiveItemColor,
      //   inactiveColorPrimary: CupertinoColors.systemGrey,
      // ),
    ];
  }
}
