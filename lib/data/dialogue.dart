import 'package:flutter/material.dart';

Future<bool> showConfirmationDialog(BuildContext context) async {
  return (await showDialog<bool>(
        context: context,
        barrierDismissible: false, // User must tap a button to dismiss
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Confirm Action'),
            content: const Text('Are you sure you want to proceed?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(dialogContext)
                      .pop(false); // Return false if Cancel is pressed
                },
              ),
              TextButton(
                child: const Text('Confirm'),
                onPressed: () {
                  Navigator.of(dialogContext)
                      .pop(true); // Return true if Confirm is pressed
                },
              ),
            ],
          );
        },
      )) ??
      false; // Return false if dialog is dismissed without a selection
}
