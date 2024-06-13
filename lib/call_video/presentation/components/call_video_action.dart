import 'package:try_agora/call_video/call_video_imports.dart';

class CallVideoActions extends StatelessWidget {
  const CallVideoActions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CallVideoCubit, CallVideoState>(
        builder: (context, state) {
      var cubic = CallVideoCubit.get(context);
      return Container(
        color: Colors.white70,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: cubic.openCloseCamera,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: Icon(
                    cubic.cameraOff ? Icons.videocam_off : Icons.videocam,
                    color: cubic.cameraOff ? Colors.black : Colors.blue,
                    size: 20.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: cubic.onToggleMute,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: Icon(
                      cubic.muted ? Icons.mic_off : Icons.mic,
                      color: cubic.muted ? Colors.black : Colors.blue,
                      size: 20.0,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: cubic.cameraOff ? null : cubic.onToggleCamera,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: Icon(
                    cubic.isFrontCamera
                        ? Icons.camera_front
                        : Icons.camera_rear,
                    color: cubic.cameraOff ? Colors.grey : Colors.blue,
                    size: 20.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      return cubic.onCallEnd(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: const Icon(
                      Icons.call_end,
                      color: Colors.redAccent,
                      size: 20.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
