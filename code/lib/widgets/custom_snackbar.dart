import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({
    super.key,
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
  }) : super(
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    color: Colors.amber,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🎉 Congratulations!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (actionLabel != null)
                  TextButton(
                    onPressed: onActionPressed,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.amber,
                    ),
                    child: Text(actionLabel),
                  ),
              ],
            ),
          ),
          backgroundColor: const Color(0xFF6A1B9A),
          duration: duration,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          dismissDirection: DismissDirection.horizontal,
          animation: null,
        );

  static void show(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(
        message: message,
        actionLabel: actionLabel,
        onActionPressed: onActionPressed,
        duration: duration,
      ),
    );
  }
}
