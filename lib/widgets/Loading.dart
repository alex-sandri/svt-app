import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(),
        Expanded(
          child: Center(
              child: Text(
            "Questa operazione potrebbe richiedere alcuni secondi",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          )),
        )
      ],
    );
  }
}
