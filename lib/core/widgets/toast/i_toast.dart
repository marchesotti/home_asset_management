import 'package:flutter/material.dart';
import 'package:home_asset_management/main.dart';

/// A base class for toasts.
abstract class IToast {
  /// The message of the toast.
  final String message;

  /// The color of the toast.
  final Color color;

  IToast(this.message, {required this.color});

  Widget build(BuildContext context) => Align(
    alignment: Alignment.bottomCenter,
    child: Material(
      child: Container(
        constraints: const BoxConstraints(minHeight: 12),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: color),
        child: Text(
          message,
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ),
  );

  /// Shows the toast by adding it to the overlay for 2 seconds and then removing it.
  Future<void> show() async {
    final BuildContext? context = navigatorKey.currentContext;
    if (context == null) return;
    final OverlayState? overlay = Navigator.of(context, rootNavigator: true).overlay;
    if (overlay == null) return;
    final OverlayEntry entry = OverlayEntry(builder: (_) => build(context));
    overlay.insert(entry);
    await Future.delayed(const Duration(seconds: 2));
    entry.remove();
  }
}
