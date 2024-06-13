import 'package:try_agora/call_video/call_video_imports.dart';

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
  late RtcEngine engine;

  void initCallVideoData() {
    initAgora();
    appId = "5a2459bf2a9b446fa56383975b36fe63";
    token =
        "007eJxTYFhjZXFy9u68gGXX7ppJHOwRZ+95ZVOg+PekzceVLYobfJQVGEwTjUxMLZPSjBItk0xMzNISTc2MLYwtzU2TjM3SUs2M183MSmsIZGT4OLuZkZEBAkF8Zoa81HIGBgA8yR9/";
    channel = "new";
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    engine.registerEventHandler(
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

    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.enableVideo();
    await engine.startPreview();

    await engine.joinChannel(
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
    engine.muteLocalAudioStream(muted);
  }

  void openCloseCamera() {
    emit(InitialToggleCameraState());
    cameraOff = !cameraOff;
    emit(SuccessToggleCameraState());
    engine.muteLocalVideoStream(cameraOff);
  }

  void onToggleCamera() {
    engine.switchCamera();
    emit(InitialSwitchCameraState());
    isFrontCamera = !isFrontCamera;
    emit(SuccessSwitchCameraState());
  }

  void onCallEnd(BuildContext context) async {
    emit(InitialCallEndState());
    await engine.leaveChannel();
    await engine.release();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CallEnded()),
    );
    emit(SuccessCallEndState());
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
            rtcEngine: engine,
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
