import 'package:euchack/constants/app_styles.dart';
import 'package:euchack/constants/colors.dart';
import 'package:flutter/material.dart';

class StandardScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final bool automaticallyImplyLeading;
  final Widget? floatingActionButton;
  final bool showNavBar;

  const StandardScaffold({
    super.key,
    required this.body,
    required this.title,
    this.automaticallyImplyLeading = false,
    this.floatingActionButton,
    this.showNavBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: textColor,
        automaticallyImplyLeading: automaticallyImplyLeading,
        leading: automaticallyImplyLeading
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: primaryColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: Text(title, style: titleText),
      ),
      body: body,
      bottomNavigationBar: showNavBar ? buildBottomNavigationBar() : null,
      floatingActionButton: floatingActionButton,
    );
  }
}

Widget buildBottomNavigationBar() {
  return BottomNavigationBar(
    showSelectedLabels: false,
    showUnselectedLabels: false,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.food_bank_outlined),
        label: 'Grocery',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.chat_bubble_outline_rounded),
        label: 'Chat',
      ),
    ],
    currentIndex: 1,
    backgroundColor: textColor,
    selectedItemColor: primaryColor,
    unselectedItemColor: backgroundColor,
    onTap: (var i) => 0,
    enableFeedback: false,
  );
}
