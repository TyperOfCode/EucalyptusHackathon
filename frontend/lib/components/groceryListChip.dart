import 'package:euchack/constants/app_styles.dart';
import 'package:euchack/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class GroceryListChip extends StatelessWidget {
  final String item;
  const GroceryListChip({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(color: textColor, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const Gap(10),
          Text(
            item,
            style: groceryListText,
          ),
        ],
      ),
    );
  }
}

class ChangedGroceryListChip extends StatelessWidget {
  final String? item;
  final String? previousItem;
  const ChangedGroceryListChip({
    super.key,
    this.item,
    this.previousItem,
  });

  @override
  Widget build(BuildContext context) {
    if (item == null || previousItem == null) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: primaryColor,
              border: Border.all(color: textColor, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const Gap(10),
          Text(
            item!,
            style: groceryListText.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const Gap(10),
          Expanded(
            child: Text(
              previousItem!,
              style: groceryListText.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.lineThrough,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Gap(5),
          const Icon(Icons.auto_awesome, color: textColor),
        ],
      ),
    );
  }
}
