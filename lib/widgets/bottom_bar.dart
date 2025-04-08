import 'package:flutter/material.dart';
import 'package:iconify_design/iconify_design.dart';
import 'package:task_manager/theme/colors.dart';

class BottomBar extends StatelessWidget {
  final List<BarItem> barItems;
  final int selectedBarIndex;
  final Function onBarTap;

  const BottomBar({
    required this.barItems,
    required this.selectedBarIndex,
    required this.onBarTap,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    Duration duration = const Duration(milliseconds: 250);
    final bg = Theme.of(context).bottomAppBarTheme.color;
    return Material(
      elevation: 10.0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:
              barItems.map((item) {
                final isSelected = item.index == selectedBarIndex;
                return InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    onBarTap(item.index);
                  },
                  child: AnimatedContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                    duration: duration,
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? bg?.withValues(alpha: 0.075)
                              : Colors.transparent,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Row(
                      children: <Widget>[
                        IconifyIcon(
                          icon: item.icon,
                          color: isSelected ? bg : grey,
                        ),
                        const SizedBox(width: 10.0),
                        AnimatedSize(
                          duration: duration,
                          curve: Curves.easeInOut,
                          child: Text(
                            isSelected ? item.text : '',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium!.copyWith(
                              color: isSelected ? bg : grey,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}

class BarItem {
  String text;
  String icon;
  int index;

  BarItem(this.text, this.icon, this.index);
}
