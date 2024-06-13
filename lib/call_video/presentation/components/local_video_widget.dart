import 'package:try_agora/call_video/call_video_imports.dart';

class LocalVideoWidget extends StatelessWidget {
  const LocalVideoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CallVideoCubit, CallVideoState>(
      builder: (context, state) {
        var cubic=CallVideoCubit.get(context);
        return Visibility(
            visible: cubic.cameraOff,
        replacement:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: cubic.engine,
              canvas: const VideoCanvas(uid: 0),
            ),
          ),
        ),
            child:  Padding(
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
            ),);
      },
    );
  }
}
