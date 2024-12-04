import 'package:euchack/components/groceryListChip.dart';
import 'package:euchack/constants/app_styles.dart';
import 'package:euchack/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class GroceryPage extends StatelessWidget {
  const GroceryPage({super.key});

  @override
  Widget build(BuildContext context) {
    const title = "Grocery";

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: textColor,
        title: const Text(title, style: titleText),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              generateHeader(),
              const Gap(33),
              generateMoreStatsChip(),
              const Gap(33),
              generateGroceryList()
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 120,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: primaryColor,
            onPressed: () => {},
            shape: const CircleBorder(),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: textColor,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}

Widget generateHeader() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Good afternoon Elise,", style: header2Text),
      Row(
        children: [
          const Text("We need some", style: header1Text),
          const Gap(10),
          Stack(
            children: [
              Positioned.fill(
                top: 10,
                bottom: 10,
                child: Transform.rotate(
                  angle: 0.05,
                  child: Container(
                    width: 70,
                    height: 25,
                    decoration: const BoxDecoration(
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: const Text("fibre", style: header1ItalicText),
              ),
            ],
          )
        ],
      )
    ],
  );
}

Widget generateMoreStatsChip() {
  return OutlinedButton(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(textColor),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    ),
    onPressed: () {
      print("More stats");
    },
    child: Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        children: [
          Text("24x", style: header2Text.copyWith(color: primaryColor)),
          const Gap(10),
          Text("healthier since start",
              style: header2Text.copyWith(color: backgroundColor)),
          const Spacer(),
          const Icon(Icons.arrow_forward, color: backgroundColor),
        ],
      ),
    ),
  );
}

Widget generateGroceryList() {
  // TODO: should pull from db or something
  const statList = [
    {"stat": "+280%", "text": "Fibre"},
    {"stat": "-30%", "text": "Saturated Fat"},
    {"stat": "-230%", "text": "Added Sugars"},
    {"stat": "-120%", "text": "Calories"},
  ];

  const changedItems = [
    {"item": "Lean Ground Turkey", "previousItem": "bacon"},
    {"item": "Berries", "previousItem": "potato chips"},
    {"item": "Feta Cheese", "previousItem": "cheddar cheese"},
    {"item": "Whole-grain Bread", "previousItem": "white bread"},
    {"item": "70% Dark Chocolate", "previousItem": "white chocolate"},
  ];

  const normalItems = [
    "Carrots",
    "Eggs",
    "Olive Oil",
    "Basil",
    "Whole-wheat Pasta",
    "Tomato Paste",
  ];

  return Column(
    children: [
      Text(
        "Your next grocery list",
        style: header2Text.copyWith(
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.w700,
        ),
      ),
      const Gap(20),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (var stat in statList)
            generateGroceryStatChip(stat["stat"], stat["text"]),
        ],
      ),
      const Gap(20),
      Column(
        children: [
          for (var item in changedItems) ...[
            ChangedGroceryListChip(
              item: item["item"],
              previousItem: item["previousItem"],
            ),
            const Gap(10)
          ],
          for (var item in normalItems) GroceryListChip(item: item),
        ],
      )
    ],
  );
}

Widget generateGroceryStatChip(String? stat, String? text) {
  if (stat == null || text == null) {
    return Container();
  }

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(stat, style: groceryListText.copyWith(fontWeight: FontWeight.w700)),
      const Gap(10),
      Text(text, style: groceryListText),
    ],
  );
}
