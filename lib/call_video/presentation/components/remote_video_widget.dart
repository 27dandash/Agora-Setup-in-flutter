// import 'package:try_agora/call_video/call_video_imports.dart';
//
// class RemoteVideoWidget extends StatelessWidget {
//   const RemoteVideoWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CallVideoCubit, CallVideoState>(
//       builder: (context, state) {
//         var cubic=CallVideoCubit.get(context);
//         return Visibility(
//           visible: cubic.remoteUid!=null,
//           replacement:const Text(
//             'Please wait for remote user to join',
//             textAlign: TextAlign.center,
//           ),
//           child:  Visibility(
//             visible:cubic.remoteCameraOff ,
//             replacement: AgoraVideoView(
//               controller: VideoViewController.remote(
//                 rtcEngine:cubic. engine,
//                 canvas: VideoCanvas(uid: cubic.remoteUid),
//                 connection: RtcConnection(channelId:cubic. channel),
//               ),
//             ),
//             child: const Text(
//               'The user closed their camera',
//               textAlign: TextAlign.center,
//             ),
//           ),);
//       },
//     );
//   }
// }
