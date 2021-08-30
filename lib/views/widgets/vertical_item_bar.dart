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
    return ClipRect(
      child: CustomPaint(
        painter: ItemPointerPainter(positionToPaint),
        isComplex: true,
        child: Container(
          // color: Colors.red,
          width: SizeConfig.getHorizontalSize(64),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              widget.itemList.length,
              (index) => _ItemWidget(
                item: widget.itemList[index],
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

  _ItemWidget({
    Key? key,
    required this.onTap,
    required this.item,
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
      child: Row(
        children: [
          Expanded(child: Container()),
          Container(
            // color: Colors.white,
            padding: EdgeInsets.only(
              left: 0,
              top: SizeConfig.getVerticalSize(12),
              right: SizeConfig.getVerticalSize(12),
              bottom: SizeConfig.getVerticalSize(12),
            ),
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(item.itemTitle),
            ),
          ),
        ],
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
      canvas.drawColor(Colors.green, BlendMode.src);
      final double height = size.width * 0.25; // 25%
      final double width = size.width * 0.7; // 70%
      //
      //Draw pointer
      //
      print("Size ::::: ${size}Height :::: $height __ Width :::: $width");
      final Offset topPoint = Offset(paintPosition!.dx, paintPosition!.dy - height);
      final Offset bottomPoint = Offset(paintPosition!.dx, paintPosition!.dy + height);
      final Offset rightPoint = Offset(paintPosition!.dx + width, paintPosition!.dy);

      Path path = Path()
        ..moveTo(paintPosition!.dx, paintPosition!.dy)
        ..lineTo(topPoint.dx, topPoint.dy)
        ..lineTo(rightPoint.dx, rightPoint.dy)
        /*..cubicTo(
          topPoint.dx + (width * 0.4),
          topPoint.dy - (height * 0.1),
          rightPoint.dx - (width * 0.4),
          rightPoint.dy + (height * 0.5),
          rightPoint.dx,
          rightPoint.dy,
        )*/
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
