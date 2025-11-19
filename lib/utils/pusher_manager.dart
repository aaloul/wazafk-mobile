import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../networking/Endpoints.dart';
import 'Prefs.dart';

// DeepLinkManager deepLinkManager = DeepLinkManager();

const title = "PusherManager";

class PusherManager {
  static final PusherChannelsFlutter pusher =
      PusherChannelsFlutter.getInstance();

  PusherManager._i();

  static final PusherManager _pusherManager = PusherManager._i();

  factory PusherManager() {
    return _pusherManager;
  }

  initPusher() async {
    try {
      await pusher.init(
        apiKey: '7ed313b45aee7ab0a54b',
        cluster: 'ap2',
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        // onEvent: onEvent,
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
        authEndpoint: Endpoints.base_url + Endpoints.authenticateChannel,
        onAuthorizer: onAuthorizer,
        authParams: {
          'headers': {
            'Authorization': 'Bearer ${Prefs.getToken}',
            'X-CSRF-Token': 'Bearer ${Prefs.getToken}',
          },
        },
      );
      // await pusher.subscribe(channelName: channel, onEvent: (dynamic event) {});
      // await pusher.connect();
    } catch (e) {
      print("ERROR: $e");
    }
  }

  dynamic onAuthorizer(
    String channelName,
    String socketId,
    dynamic options,
  ) async {
    String token = Prefs.getToken;
    var authUrl = Endpoints.base_url + Endpoints.authenticateChannel;
    var result = await http.post(
      Uri.parse(authUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token',
      },
      body: 'socket_id=$socketId&channel_name=$channelName',
    );
    var json = jsonDecode(result.body);
    return json;
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    log("Connection1: $currentState");
  }

  void onError(String message, int? code, dynamic e) {
    log("onError: $message code: $code exception: $e");
  }

  // void onEvent(PusherEvent event) {
  //   log("onEvent: $event");
  //
  //
  // }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    log("onSubscriptionSucceeded: $channelName data: $data");
    final me = pusher.getChannel(channelName)?.me;
    log("Me: $me");
  }

  void onSubscriptionError(String message, dynamic e) {
    log("onSubscriptionError: $message Exception: $e");
  }

  void onDecryptionFailure(String event, String reason) {
    log("onDecryptionFailure: $event reason: $reason");
  }

  void onMemberAdded(String channelName, PusherMember member) {
    log("onMemberAdded: $channelName user: $member");
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    log("onMemberRemoved: $channelName user: $member");
  }

  void onSubscriptionCount(String channelName, int subscriptionCount) {
    log(
      "onSubscriptionCount: $channelName subscriptionCount: $subscriptionCount",
    );
  }
}
