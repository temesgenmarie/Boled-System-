import 'package:flutter/material.dart';

void showSuccessModal(
  BuildContext context,
  String message, [
  VoidCallback? onOk,
]) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
      title: const Text('Success'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onOk?.call();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
