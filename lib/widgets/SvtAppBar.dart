import 'package:flutter/material.dart';

class SvtAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> actions;

  @override
  final Size preferredSize;

  SvtAppBar({ this.actions }): preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset(
        "assets/svt.png",
        height: preferredSize.height - 15,
      ),
      actions: this.actions,
    );
  }
}