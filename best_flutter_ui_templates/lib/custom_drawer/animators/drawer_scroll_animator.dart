import 'package:best_flutter_ui_templates/custom_drawer/animators/drawer_icon_animator.dart';
import 'package:flutter/material.dart';

class DrawerScrollAnimator {
  ScrollController scrollController;
  double drawerWidth;

  DrawerIconAnimator drawerIconAnimator;

  void Function(bool shouldOpen) onDrawerStateChanged;

  get offset => scrollController.offset;

  get isOpen => offset.compareTo(0.0) == 0;

  get isClose {
    try {
      return offset.compareTo(this.drawerWidth) == 0;
    } catch (e) {
      return false;
    }
  }

  get isSliding => offset != null && offset > 0 && offset < this.drawerWidth;

  DrawerScrollAnimator(
      this.drawerWidth, this.drawerIconAnimator, this.onDrawerStateChanged) {
    scrollController = ScrollController(initialScrollOffset: drawerWidth)
      ..addListener(_onHorizontalScroll);
  }

  _onHorizontalScroll() {
    if (isOpen) {
      drawerIconAnimator.onDrawerOpen();
      onDrawerStateChanged(true);
    } else if (isSliding) {
      drawerIconAnimator.onDrawerSlide(offset, this.drawerWidth);
    } else if (isClose) {
      drawerIconAnimator.onDrawerClose();
      onDrawerStateChanged(false);
    }
  }

  _openDrawer() => scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );

  _closeDrawer() => scrollController.animateTo(
        this.drawerWidth,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );

  onDrawerClick() {
    if (isClose) {
      _openDrawer();
    } else {
      _closeDrawer();
    }
  }
}
