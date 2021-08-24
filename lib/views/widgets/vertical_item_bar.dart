import 'package:flutter/material.dart';
import 'package:vertical_item_bar/utils/size_config.dart';

//region Widget
class VerticalItemBar extends StatelessWidget {
  late Offset tapPosition;

  VerticalItemBar({Key? key, required this.itemList}) : super(key: key);
  final List itemList;
  late double pointerWidth;

  @override
  Widget build(BuildContext context) {
    pointerWidth = SizeConfig.getVerticalSize(24);
    return CustomPaint(
      painter: ItemPointerPainter(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          itemList.length,
          (index) => _getItemWidget(context, itemList[index]),
        ),
      ),
    );
  }

  Widget _getItemWidget(BuildContext context, VerticalItem item) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (tapPosition != null) {
          final RenderBox box = context.findRenderObject() as RenderBox;
          final Offset localOffset = box.globalToLocal(tapPosition);
          debugPrint("POSITION Center :::::: ${localOffset}");
        }
        if (item.onTap != null) {
          item.onTap!();
        }
      },
      onTapUp: (tapUpDetail) {
        debugPrint("POSITION ::::: tapUp ${tapUpDetail.globalPosition}");
        tapPosition = tapUpDetail.globalPosition;
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: pointerWidth,
          top: SizeConfig.getVerticalSize(8),
          right: SizeConfig.getVerticalSize(8),
          bottom: SizeConfig.getVerticalSize(8),
        ),
        child: RotatedBox(
          quarterTurns: 3,
          child: Text(item.itemTitle),
        ),
      ),
    );
  }
}

//endregion

//region Painter
class ItemPointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
//endregion

//region Data class
class VerticalItem {
  String itemTitle;
  Function? onTap;

  VerticalItem({required this.itemTitle, this.onTap});
}
//endregion
