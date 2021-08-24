import 'package:flutter/material.dart';
import 'package:vertical_item_bar/utils/size_config.dart';
import 'package:vertical_item_bar/utils/widgets/responsive_safe_area.dart';
import 'package:vertical_item_bar/views/widgets/vertical_item_bar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  List<VerticalItem> itemList = [
    VerticalItem(itemTitle: "Item 1", onTap: () {}),
    VerticalItem(itemTitle: "Item 2", onTap: () {}),
    VerticalItem(itemTitle: "Item 3", onTap: () {}),
    VerticalItem(itemTitle: "Item 4", onTap: () {}),
  ];

  double containerHeight = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: ResponsiveSafeArea(
        builder: (context, size) {
          if (containerHeight < size.height) {
            containerHeight = size.height;
          }
          return Container(
            height: containerHeight,
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VerticalItemBar(
                    itemList: itemList,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
