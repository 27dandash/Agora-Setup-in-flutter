import 'package:try_agora/call_video/call_video_imports.dart';

class CallVideoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialCallVideoState extends CallVideoState {}

//-------------------------toggleSwitch-----------------------------------
class InitialToggleSwitchState extends CallVideoState {}
class SuccessToggleSwitchState extends CallVideoState {}

//-------------------------_onToggleMute-----------------------------------
class InitialToggleMuteState extends CallVideoState {}
class SuccessToggleMuteState extends CallVideoState {}

//-------------------------_onToggleCamera-----------------------------------
class InitialToggleCameraState extends CallVideoState {}
class SuccessToggleCameraState extends CallVideoState {}
//-------------------------_onSwitchCamera-----------------------------------
class InitialSwitchCameraState extends CallVideoState {}
class SuccessSwitchCameraState extends CallVideoState {}
//-------------------------_onCallEnd-----------------------------------
class InitialCallEndState extends CallVideoState {}
class SuccessCallEndState extends CallVideoState {}
//-------------------------_localUserJoined-----------------------------------
class InitialLocalUserJoinedState extends CallVideoState {}
class SuccessLocalUserJoinedState extends CallVideoState {}
//-------------------------onUserJoined-----------------------------------
class InitialUserJoinedState extends CallVideoState {}
class SuccessUserJoinedState extends CallVideoState {}
//-------------------------onUserOffline-----------------------------------
class InitialOnUserOfflineState extends CallVideoState {}
class SuccessOnUserOfflineState extends CallVideoState {}
//------------------------- onRemoteVideoStateClose-----------------------------------
class InitialRemoteVideoStateCloseState extends CallVideoState {}
class SuccessRemoteVideoStateCloseState extends CallVideoState {}
//------------------------- onRemoteVideoStateOpen-----------------------------------
class InitialRemoteVideoStateOpenState extends CallVideoState {}
class SuccessRemoteVideoStateOpenState extends CallVideoState {}