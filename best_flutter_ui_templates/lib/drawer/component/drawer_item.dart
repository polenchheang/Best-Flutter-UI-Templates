import 'package:best_flutter_ui_templates/app_theme.dart';
import 'package:flutter/material.dart';

const contentMargin = 8.0;
const widgetMargin = 4.0;

class DrawerItem extends StatelessWidget {
  final screenIndex;
  final listData;
  final onDrawerClicked;
  final iconAnimationController;

  final highlightRoundCorner = 28.0;
  final indicatorRoundCorner = 16.0;
  final fontSize = 16.0;
  final iconSize = 24.0;
  final itemHeight = 46.0;
  final padding = const Padding(padding: EdgeInsets.all(widgetMargin));

  get isSelected => screenIndex == listData.index;
  get iconColor => getIconColor();

  const DrawerItem(this.screenIndex, this.listData, this.onDrawerClicked,
      this.iconAnimationController);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          onDrawerClicked(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                  top: contentMargin, bottom: contentMargin),
              child: _buildContent(),
            ),
            isSelected ? _buildHighLight() : const SizedBox()
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Row(
      children: <Widget>[
        Container(
          width: 6.0,
          height: itemHeight,
          decoration: BoxDecoration(
            color: getBgColor(),
            borderRadius: new BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(indicatorRoundCorner),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(indicatorRoundCorner),
            ),
          ),
        ),
        padding,
        listData.isAssetsImage
            ? Container(
                width: iconSize,
                height: iconSize,
                child: Image.asset(listData.imageName, color: iconColor),
              )
            : Icon(listData.icon.icon, color: iconColor),
        padding,
        Text(
          listData.labelName,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: fontSize,
            color: iconColor,
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  Widget _buildHighLight() {
    return AnimatedBuilder(
      animation: iconAnimationController,
      builder: (BuildContext context, Widget child) {
        final highLightWidth = getHighLightWidth(context);
        return Transform(
          transform: Matrix4.translationValues(
              -(highLightWidth * iconAnimationController.value), 0.0, 0.0),
          child: Padding(
            padding: EdgeInsets.only(top: contentMargin, bottom: contentMargin),
            child: Container(
              width: highLightWidth,
              height: itemHeight,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: new BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(highlightRoundCorner),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(highlightRoundCorner),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double getHighLightWidth(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.75 - 64;

  Color getIconColor() => isSelected ? Colors.blue : AppTheme.nearlyBlack;

  Color getBgColor() => isSelected ? Colors.blue : Colors.transparent;
}
