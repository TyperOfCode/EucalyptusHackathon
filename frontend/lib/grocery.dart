import 'package:euchack/components/grocery_list_chip.dart';
import 'package:euchack/components/standard_scaffold.dart';
import 'package:euchack/constants/app_styles.dart';
import 'package:euchack/constants/colors.dart';
import 'package:euchack/providers/cam_provider.dart';
import 'package:euchack/receipt_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class GroceryPage extends StatefulWidget {
  const GroceryPage({super.key});

  @override
  State<GroceryPage> createState() => _GroceryPageState();
}

class _GroceryPageState extends State<GroceryPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: textColor,
      ),
    );

    const title = "Grocery";
    return StandardScaffold(
      title: title,
      floatingActionButton: buildScanReceiptButton(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              buildHeader(),
              const Gap(36),
              buildMoreStatsChip(),
              const Gap(36),
              buildGroceryList()
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildHeader() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Good afternoon Elise,", style: header2Text),
      Row(
        children: [
          const Text("You need some", style: header1Text),
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

Widget buildMoreStatsChip() {
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

Widget buildGroceryList() {
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
            buildGroceryStatChip(stat["stat"], stat["text"]),
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

Widget buildGroceryStatChip(String? stat, String? text) {
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

Widget buildScanReceiptButton(BuildContext context) {
  return SizedBox(
    width: 80,
    height: 120,
    child: FittedBox(
      child: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReceiptPage()),
          );
        },
        shape: const CircleBorder(),
        child: const Icon(
          Icons.receipt_long_outlined,
          color: textColor,
          size: 40,
        ),
      ),
    ),
  );
}

void onFloatingActionButtonPressed() {
  print("Floating action button pressed");
}
