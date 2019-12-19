import 'package:best_flutter_ui_templates/app_theme.dart';
import 'package:best_flutter_ui_templates/custom_drawer/animators/drawer_icon_animator.dart';
import 'package:best_flutter_ui_templates/custom_drawer/animators/drawer_scroll_animator.dart';
import 'package:best_flutter_ui_templates/custom_drawer/drawer_page.dart';
import 'package:best_flutter_ui_templates/custom_drawer/home_drawer.dart';
import 'package:flutter/material.dart';

class PagesContainerWithDrawer extends StatefulWidget {
  const PagesContainerWithDrawer({
    Key key,
    this.drawerWidth = 250,
    this.onDrawerCall,
    @required this.screenView,
    this.animatedIconData = AnimatedIcons.arrow_menu,
    this.menuView,
    this.drawerIsOpen,
    this.screenIndex,
  })  : assert(screenView != null),
        super(key: key);

  final double drawerWidth;
  final Function(DrawerIndex) onDrawerCall;
  final Widget screenView;
  final Function(bool) drawerIsOpen;
  final AnimatedIconData animatedIconData;
  final Widget menuView;
  final DrawerIndex screenIndex;

  @override
  _PagesContainerWithDrawerState createState() =>
      _PagesContainerWithDrawerState();
}

class _PagesContainerWithDrawerState extends State<PagesContainerWithDrawer>
    with TickerProviderStateMixin {
  final appBar = AppBar();

  DrawerScrollAnimator drawerScrollAnimator;
  DrawerIconAnimator drawerIconAnimator;

  // states
  var isDrawerOpen = false;

  @override
  void initState() {
    drawerIconAnimator = DrawerIconAnimator(this);
    drawerIconAnimator.onUIReady();
    drawerScrollAnimator = DrawerScrollAnimator(
        widget.drawerWidth, drawerIconAnimator, onDrawerStateChanged);
    super.initState();
  }

  @override
  void dispose() {
    drawerIconAnimator.dispose();
    super.dispose();
  }

  void onDrawerStateChanged(bool isOpen) {
    try {
      widget.drawerIsOpen(isOpen);
    } catch (_) {}
    setState(() {
      isDrawerOpen = isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SingleChildScrollView(
        controller: drawerScrollAnimator.scrollController,
        scrollDirection: Axis.horizontal,
        physics: const PageScrollPhysics(parent: ClampingScrollPhysics()),
        child: Opacity(
          opacity: 1,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width + widget.drawerWidth,
            child: Row(
              children: <Widget>[
                buildDrawerView(context),
                buildMainView(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDrawerView(BuildContext context) {
    return DrawerPage(
        widget.drawerWidth,
        widget.screenIndex,
        drawerIconAnimator.iconAnimationController,
        drawerScrollAnimator,
        drawerScrollAnimator.onDrawerClick,
        widget.onDrawerCall);
  }

  SizedBox buildMainView(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Container(
        decoration: buildMainViewBoxDecoration(),
        child: Stack(
          children: <Widget>[
            AbsorbPointer(
              absorbing: isDrawerOpen,
              child: widget.screenView,
            ),
            buildHamburgerMenu(context),
          ],
        ),
      ),
    );
  }

  Decoration buildMainViewBoxDecoration() {
    return BoxDecoration(
      color: AppTheme.white,
      boxShadow: <BoxShadow>[
        BoxShadow(color: AppTheme.grey.withOpacity(0.6), blurRadius: 24),
      ],
    );
  }

  Widget buildHamburgerMenu(BuildContext context) {
    final hamburgerButtonSize = appBar.preferredSize.height - 8;
    return Padding(
      padding:
          EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, left: 8),
      child: SizedBox(
        width: hamburgerButtonSize,
        height: hamburgerButtonSize,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(appBar.preferredSize.height),
            child: Center(
              child: widget.menuView != null
                  ? widget.menuView
                  : AnimatedIcon(
                      icon: widget.animatedIconData != null
                          ? widget.animatedIconData
                          : AnimatedIcons.arrow_menu,
                      progress: drawerIconAnimator.iconAnimationController),
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              drawerScrollAnimator.onDrawerClick();
            },
          ),
        ),
      ),
    );
  }
}
