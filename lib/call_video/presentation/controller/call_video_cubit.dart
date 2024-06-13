import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:try_agora/call_video/presentation/components/call_ended.dart';
import 'package:try_agora/call_video/presentation/controller/call_video_state.dart'; // Import the state file

class CallVideoCubit extends Cubit<CallVideoState> {
  CallVideoCubit() : super(InitialCallVideoState());

  static CallVideoCubit get(context) => BlocProvider.of(context);
  late String appId;
  late String token;
  late String channel;

  int? _remoteUid;
  bool localUserJoined = false;
  bool muted = false;
  bool cameraOff = false;
  bool isFrontCamera = true;
  bool _remoteCameraOff = false;
  late RtcEngine _engine;

  void initCallVideoData() {
    initAgora();
    appId = "5a2459bf2a9b446fa56383975b36fe63";
    token =
        "007eJxTYFhjZXFy9u68gGXX7ppJHOwRZ+95ZVOg+PekzceVLYobfJQVGEwTjUxMLZPSjBItk0xMzNISTc2MLYwtzU2TjM3SUs2M183MSmsIZGT4OLuZkZEBAkF8Zoa81HIGBgA8yR9/";
    channel = "new";
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          emit(InitialLocalUserJoinedState());
          localUserJoined = true;
          // _startTimer();
          emit(SuccessLocalUserJoinedState());
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          emit(InitialUserJoinedState());
          _remoteUid = remoteUid;
          _remoteCameraOff = false; // Assume camera is on when user joins
          emit(SuccessUserJoinedState());
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          emit(InitialOnUserOfflineState());
          _remoteUid = null;
          emit(SuccessOnUserOfflineState());
        },
        onRemoteVideoStateChanged: (
          RtcConnection connection,
          int remoteUid,
          RemoteVideoState state,
          RemoteVideoStateReason reason,
          int elapsed,
        ) {
          if (state == RemoteVideoState.remoteVideoStateStopped ||
              state == RemoteVideoState.remoteVideoStateFrozen) {
            emit(InitialRemoteVideoStateCloseState());
            _remoteCameraOff = true;
            emit(SuccessRemoteVideoStateCloseState());
          } else if (state == RemoteVideoState.remoteVideoStateDecoding ||
              state == RemoteVideoState.remoteVideoStateStarting) {
            emit(InitialRemoteVideoStateOpenState());
            _remoteCameraOff = false;
            emit(SuccessRemoteVideoStateOpenState());
          }
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: token,
      channelId: channel,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }


  void onToggleMute() {
    emit(InitialToggleMuteState());
    muted = !muted;
    emit(SuccessToggleMuteState());
    _engine.muteLocalAudioStream(muted);
  }

  void openCloseCamera() {
    emit(InitialToggleCameraState());
    cameraOff = !cameraOff;
    emit(SuccessToggleCameraState());
    _engine.muteLocalVideoStream(cameraOff);
  }

  void onToggleCamera() {
    _engine.switchCamera();
    emit(InitialSwitchCameraState());
    isFrontCamera = !isFrontCamera;
    emit(SuccessSwitchCameraState());
  }

  void onCallEnd(BuildContext context) async {
    emit(InitialCallEndState());
    await _engine.leaveChannel();
    await _engine.release();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CallEnded()),
    );
    emit(SuccessCallEndState());
  }

  Widget localVideo() {
    if (cameraOff) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(15)),
          child: const Center(
            child: Icon(
              Icons.videocam_off,
              color: Colors.white,
              size: 40.0,
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: _engine,
            canvas: const VideoCanvas(uid: 0),
          ),
        ),
      );
    }
  }

  Widget remoteVideo() {
    if (_remoteUid != null) {
      if (_remoteCameraOff) {
        return const Text(
          'The user closed their camera',
          textAlign: TextAlign.center,
        );
      } else {
        return AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: _engine,
            canvas: VideoCanvas(uid: _remoteUid),
            connection: RtcConnection(channelId: channel),
          ),
        );
      }
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
