import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class OptAirAppBar extends StatelessWidget {
  const OptAirAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [FloatingActionButton(onPressed: () => {})],
      title: const Text("OptAir Connect"),
    );
  }
}
