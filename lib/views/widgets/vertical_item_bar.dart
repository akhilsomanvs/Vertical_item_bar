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
  Offset? positionToPaint;

  @override
  Widget build(BuildContext context) {
    double pointerWidth = SizeConfig.getHorizontalSize(48);
    return ClipRect(
      child: CustomPaint(
        painter: ItemPointerPainter(positionToPaint, pointerWidth),
        child: Container(
          // width: SizeConfig.getHorizontalSize(64),
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
                    positionToPaint = Offset(0, box.globalToLocal(globalTapPosition).dy);
                  });
                },
              ),
            ),
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

  _ItemWidget({
    Key? key,
    required this.onTap,
    required this.item,
    required this.pointerWidth,
  }) : super(key: key);
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
      child: Container(
        padding: EdgeInsets.only(
          left: pointerWidth,
          top: SizeConfig.getVerticalSize(12),
          right: SizeConfig.getVerticalSize(12),
          bottom: SizeConfig.getVerticalSize(12),
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
  late double pointerWidth;

  ItemPointerPainter(this.paintPosition, this.pointerWidth);

  Paint pointerPaint = Paint()..color = Colors.black;

  @override
  void paint(Canvas canvas, Size size) {
    if (paintPosition != null) {
      final double height = size.width * 0.25; // 25%
      final double width = pointerWidth * 0.7; // 70%
      //
      //Draw pointer
      //
      final Offset topPoint = Offset(paintPosition!.dx, paintPosition!.dy - height);
      final Offset bottomPoint = Offset(paintPosition!.dx, paintPosition!.dy + height);
      final Offset rightPoint = Offset(paintPosition!.dx + width, paintPosition!.dy);

      Path path = Path()
        ..moveTo(paintPosition!.dx, paintPosition!.dy)
        ..lineTo(topPoint.dx, topPoint.dy)
        ..cubicTo(
          topPoint.dx + (width * 0.4),
          topPoint.dy + (height * 0.8),
          rightPoint.dx - (width * 0.1),
          rightPoint.dy - (height * 0.6),
          rightPoint.dx,
          rightPoint.dy,
        )
        ..cubicTo(
          rightPoint.dx - (width * 0.1),
          rightPoint.dy + (height * 0.6),
          bottomPoint.dx + (width * 0.4),
          bottomPoint.dy - (height * 0.8),
          bottomPoint.dx,
          bottomPoint.dy,
        )
        ..close();
      canvas.drawPath(path, pointerPaint);
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
