import 'package:flutter/material.dart';

Future<void> showAddOrEditDialog({
  required BuildContext context,
  required TextEditingController controller,
  required String title,
  required VoidCallback onConfirm,
}) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: TextField(controller: controller),
      actions: [
        TextButton(
          onPressed: () {
            if (controller.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Enter the task")),
              );
            } else {
              onConfirm();
              Navigator.pop(context);
            }
          },
          child: const Text("Save"),
        )
      ],
    ),
  );
}
