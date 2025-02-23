import 'package:flutter/material.dart';
import 'package:home_asset_management/core/widgets/toast/i_toast.dart';

/// A toast for a successful action.
class SuccessToast extends IToast {
  SuccessToast(super.message) : super(color: Colors.green);
}
