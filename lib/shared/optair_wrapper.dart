import 'package:flutter/material.dart';

class OptAirWrapper extends StatelessWidget {
  final String title;
  final String buttonText;
  final Function? onPressed;

  final Widget body;

  const OptAirWrapper(
      {required this.title,
      this.buttonText = '',
      this.onPressed,
      required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15.0),
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (buttonText.isNotEmpty)
                      const SizedBox(
                          width:
                              8.0), // Some spacing between the title and button
                    if (buttonText.isNotEmpty)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              Theme.of(context).primaryColor, // Text color
                        ),
                        onPressed: onPressed!(),
                        child: Text(buttonText),
                      ),
                  ],
                ),
                const SizedBox(
                    height:
                        16.0), // Some spacing between the title/button and the card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0),
                    side:
                        BorderSide(color: Theme.of(context).colorScheme.shadow),
                  ),
                  margin: const EdgeInsets.only(top: 15.0),
                  child:
                      Padding(padding: const EdgeInsets.all(15.0), child: body),
                ),
              ],
            ),
          ),
        ));
  }
}
