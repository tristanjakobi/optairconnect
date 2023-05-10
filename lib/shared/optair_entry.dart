import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class OptAirEntry extends StatelessWidget {
  const OptAirEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: const BorderSide(color: Colors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(2),
                  },
                  children: const [
                    TableRow(children: [
                      Text('Gerät'),
                      Text('Device 1'),
                    ]),
                    TableRow(children: [
                      Text('°C'),
                      Text('22°C'),
                    ]),
                    TableRow(children: [
                      Text('Brand'),
                      Icon(Icons.branding_watermark), // replace with your icon
                    ]),
                    TableRow(children: [
                      Text('Verbindung'),
                      Icon(Icons.link), // replace with your icon
                    ]),
                  ],
                ),
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
