import 'package:flutter/cupertino.dart';

class DrawerIconAnimator {
  AnimationController iconAnimationController;
  DrawerIconAnimator(TickerProviderStateMixin provider) {
    iconAnimationController = AnimationController(vsync: provider);
  }

  void onUIReady() =>
      iconAnimationController.animateTo(1.0, duration: Duration());

  void onDrawerOpen() => iconAnimationController.animateTo(0.0,
      duration: const Duration(milliseconds: 0), curve: Curves.linear);

  void onDrawerSlide(double offset, double drawerWidth) =>
      iconAnimationController.animateTo((offset * 100 / (drawerWidth)) / 100,
          duration: const Duration(milliseconds: 0), curve: Curves.linear);

  void onDrawerClose() => iconAnimationController.animateTo(1.0,
      duration: const Duration(milliseconds: 0), curve: Curves.linear);

  dispose() {
    iconAnimationController.dispose();
  }
}
