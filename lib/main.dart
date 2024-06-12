import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

const appId = "91fce402e4c8455cb9fc5a0fe2b84480";
const token =
    "007eJxTYHi16tC571P+b9rwdfHhV2vWrLu9w32xy5UPektt3y9UXlx2SYHBJMUoycjA2DjRxNDQxMTILMnM0szI1NgwMdHANCXRKEVoRWZaQyAjw4ncgyyMDBAI4rMzpOWUlpSkFjEwAACewiYW";
const channel = "flutter";

void main() => runApp(const MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int? _remoteUid;
  bool _localUserJoined = false;
  bool _muted = false;
  bool _cameraOff = false;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // Retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    // Create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
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

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  void _onToggleMute() {
    setState(() {
      _muted = !_muted;
    });
    _engine.muteLocalAudioStream(_muted);
  }

  void _onToggleCamera() {
    setState(() {
      _cameraOff = !_cameraOff;
    });
    if (_cameraOff) {
      _engine.disableVideo();
    } else {
      _engine.enableVideo();
    }
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  void _onCallEnd(BuildContext context) {
    _dispose();
    Navigator.pop(context);
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: _localUserJoined
                    ? _localVideo()
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
          _toolbar(),
        ],
      ),
    );
  }

  // Display local user's video
  Widget _localVideo() {
    if (_cameraOff) {
      return _buildPlaceholder();
    } else {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: _engine,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    }
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: channel),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }

  // Placeholder widget for when the camera is off
  Widget _buildPlaceholder() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Icon(
          Icons.videocam_off,
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }

  // Toolbar with buttons
  Widget _toolbar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildToolbarButton(
              icon: _cameraOff ? Icons.videocam_off : Icons.videocam,
              onPressed: _onToggleCamera,
              color: _cameraOff ? Colors.black : Colors.blue,
              iconColor: _cameraOff ? Colors.white : Colors.white,
            ),
            const SizedBox(width: 10),
            _buildToolbarButton(
              icon: _muted ? Icons.mic_off : Icons.mic,
              onPressed: _onToggleMute,
              color: _muted ? Colors.black : Colors.blue,
              iconColor: _muted ? Colors.white : Colors.white,
            ),
            const SizedBox(width: 10),
            _buildToolbarButton(
              icon: Icons.switch_camera,
              onPressed: _cameraOff ? () {} : _onSwitchCamera,
              color: _cameraOff ? Colors.grey : Colors.black,
              iconColor: Colors.white,
            ),
            const SizedBox(width: 10),
            _buildToolbarButton(
              icon: Icons.call_end,
              onPressed: () => _onCallEnd(context),
              color: Colors.redAccent,
              iconColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color color = Colors.black,
    Color iconColor = Colors.white,
  }) {
    return RawMaterialButton(
      onPressed: onPressed,
      shape: const CircleBorder(),
      elevation: 2.0,
      fillColor: color,
      padding: const EdgeInsets.all(15.0),
      child: Icon(
        icon,
        color: iconColor,
        size: 20.0,
      ),
    );
  }
}
