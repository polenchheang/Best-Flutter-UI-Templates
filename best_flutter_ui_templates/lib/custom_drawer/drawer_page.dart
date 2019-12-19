import 'package:flutter/material.dart';

import 'home_drawer.dart';

class DrawerPage extends StatelessWidget {
  final drawerWidth;

  final selectedScreenIndex;

  final scrollController;

  final iconAnimationController;

  final Function onDrawerClicked;

  final Function onMenuClicked;

  DrawerPage(
      this.drawerWidth,
      this.selectedScreenIndex,
      this.iconAnimationController,
      this.scrollController,
      this.onDrawerClicked,
      this.onMenuClicked);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: drawerWidth,
      height: MediaQuery.of(context).size.height,
      child: AnimatedBuilder(
        animation: iconAnimationController,
        builder: (BuildContext context, Widget child) {
          return Transform(
            transform:
                Matrix4.translationValues(scrollController.offset, 0.0, 0.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: drawerWidth,
              child: HomeDrawer(
                screenIndex: selectedScreenIndex == null
                    ? DrawerIndex.HOME
                    : selectedScreenIndex,
                iconAnimationController: iconAnimationController,
                callBackIndex: (DrawerIndex indexType) {
                  onDrawerClicked();
                  try {
                    onMenuClicked(indexType);
                  } catch (e) {}
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
