import 'package:euchack/components/grocery_line_chart.dart';
import 'package:euchack/components/standard_scaffold.dart';
import 'package:euchack/constants/app_styles.dart';
import 'package:euchack/constants/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class StatPage extends StatefulWidget {
  const StatPage({super.key});

  @override
  State<StatPage> createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: textColor,
      ),
    );

    const title = "Grocery Insights";
    return StandardScaffold(
      title: title,
      showNavBar: false,
      automaticallyImplyLeading: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              buildOverview(),
              Gap(50),
              SizedBox(height: 200, width: 300, child: GroceryHealthChart()),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildOverview() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Well Done!", style: header1Text),
      Row(
        children: [
          Text("Your grocery health is: ", style: header2Text),
          Text("84%", style: header2Text.copyWith(fontWeight: FontWeight.w900)),
        ],
      ),
      Gap(50),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildRadarChart(),
        ],
      ),
      Gap(50),
      Row(
        children: [
          Text("You should buy more: ", style: header2Text),
          Text("Fibre",
              style: header2Text.copyWith(fontWeight: FontWeight.w900)),
        ],
      ),
    ],
  );
}

Widget buildRadarChart() {
  return SizedBox(
    width: 180,
    height: 180,
    child: RadarChart(
      RadarChartData(
        dataSets: [
          RadarDataSet(
            dataEntries: [
              RadarEntry(value: 80), // Calories
              RadarEntry(value: 10), // Fat
              RadarEntry(value: 30), // Fibre
              RadarEntry(value: 50), // Protein
              RadarEntry(value: 10), // Sugar
            ],
            borderColor: textColor,
            fillColor: primaryColor.withOpacity(0.5),
          ),
        ],
        radarBackgroundColor: Colors.transparent,
        borderData: FlBorderData(show: false),
        radarBorderData: const BorderSide(color: Colors.transparent),
        titlePositionPercentageOffset: 0.2,
        tickCount: 3,
        ticksTextStyle:
            const TextStyle(color: Colors.transparent, fontSize: 10),
        tickBorderData: const BorderSide(color: Colors.transparent),
        gridBorderData: BorderSide(color: textColor, width: 2),
        titleTextStyle: header2Text.copyWith(fontSize: 16),
        getTitle: (index, angle) {
          switch (index) {
            case 0:
              return RadarChartTitle(
                text: "Calories",
                angle: angle,
              );
            case 1:
              return RadarChartTitle(
                text: "Fat",
                angle: angle,
              );
            case 2:
              return RadarChartTitle(
                text: "Fibre",
                angle: angle,
              );
            case 3:
              return RadarChartTitle(
                text: "Protein",
                angle: angle,
              );
            case 4:
              return RadarChartTitle(
                text: "Sugar",
                angle: angle,
              );
            default:
              return RadarChartTitle(
                text: "",
                angle: angle,
              );
          }
        },
      ),
    ),
  );
}
