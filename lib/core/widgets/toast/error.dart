import 'package:flutter/material.dart';
import 'package:home_asset_management/core/widgets/toast/i_toast.dart';

/// A toast for an error.
class ErrorToast extends IToast {
  ErrorToast(super.message) : super(color: Colors.red);
}
