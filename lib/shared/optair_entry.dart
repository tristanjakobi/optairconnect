import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class OptAirEntry extends StatelessWidget {
  final Widget child;

  const OptAirEntry({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.0),
            side: const BorderSide(color: Colors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                child,
                IconButton(
                  icon: const Icon(Icons.more_vert), // replace with your icon
                  onPressed: () {},
                )
              ],
            ),
          ),
        ));
  }
}
