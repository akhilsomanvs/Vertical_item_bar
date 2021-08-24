import 'package:flutter/material.dart';
import 'package:vertical_item_bar/utils/size_config.dart';

//region Widget
class VerticalItemBar extends StatefulWidget {
  VerticalItemBar({Key? key, required this.itemList}) : super(key: key);
  final List itemList;

  @override
  _VerticalItemBarState createState() => _VerticalItemBarState();
}

class _VerticalItemBarState extends State<VerticalItemBar> {
  late double pointerWidth;
  Offset? positionToPaint;

  @override
  Widget build(BuildContext context) {
    pointerWidth = SizeConfig.getVerticalSize(24);
    // if (itemCenterOffset != null) {
    //   final RenderBox box = context.findRenderObject() as RenderBox;
    //   positionToPaint = box.localToGlobal(itemCenterOffset!);
    // positionToPaint = itemCenterOffset;
    // }
    return CustomPaint(
      painter: ItemPointerPainter(positionToPaint),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          widget.itemList.length,
          (index) => _ItemWidget(
            item: widget.itemList[index],
            pointerWidth: pointerWidth,
            onTap: (globalTapPosition) {
              final RenderBox box = context.findRenderObject() as RenderBox;
              setState(() {
                positionToPaint = Offset(0,box.globalToLocal(globalTapPosition).dy);
              });
            },
          ),
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  Function(Offset) onTap;
  VerticalItem item;
  double pointerWidth;

  _ItemWidget({Key? key, required this.onTap, required this.item, required this.pointerWidth}) : super(key: key);
  late Offset tapPositionGlobal;

  Offset? itemCenterOffset;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (tapPositionGlobal != null) {
          final RenderBox box = context.findRenderObject() as RenderBox;
          onTap(box.localToGlobal(box.paintBounds.center));
        }
        if (item.onTap != null) {
          item.onTap!();
        }
      },
      onTapUp: (tapUpDetail) {
        tapPositionGlobal = tapUpDetail.globalPosition;
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
  late Offset? paintPosition;

  ItemPointerPainter(this.paintPosition);

  Paint pointerPaint = Paint()..color = Colors.black;

  @override
  void paint(Canvas canvas, Size size) {
    if (paintPosition != null) {
      canvas.drawCircle(paintPosition!, 8, pointerPaint);
    }
  }

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
