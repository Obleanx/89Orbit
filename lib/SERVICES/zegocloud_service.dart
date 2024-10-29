import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class ZegoService {
  static Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    try {
      ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
      await ZegoUIKit().initLog();
      ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
        [ZegoUIKitSignalingPlugin()],
      );
      if (kDebugMode) print("Zego initialized successfully");
    } catch (e) {
      if (kDebugMode) print("Error initializing Zego: $e");
      rethrow;
    }
  }
}
