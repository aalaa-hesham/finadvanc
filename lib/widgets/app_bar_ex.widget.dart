import 'package:advanc_task_10/utils/color_utils.dart';
import 'package:advanc_task_10/widgets/icon_badge.widget.dart';
import 'package:flutter/material.dart';

class AppBarEx {
  static PreferredSizeWidget get getAppBar => AppBar(
        surfaceTintColor: Colors.white,
        actions: [
          const CartBadgeWidget(),
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_outlined,
                  color: ColorsUtil.iconColor,
                ),
              ),
              Positioned(
                  bottom: 6,
                  child: Badge(
                    backgroundColor: ColorsUtil.badgeColor,
                    label: Text('5'),
                  ))
            ],
          ),
        ],
      );
}
