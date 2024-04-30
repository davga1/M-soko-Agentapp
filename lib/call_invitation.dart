import 'package:agentapp/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class CallInvitationPage {
  Future onUserLogin(String userID, String userName) async {
    try {
      await ZegoUIKitPrebuiltCallInvitationService().init(
        appID: Utils.appId,
        appSign: Utils.appSignIn,
        userID: userID,
        userName: userName,
        plugins: [ZegoUIKitSignalingPlugin()],
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error in init Zego");
      }
    }
  }
}
