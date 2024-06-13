import 'package:try_agora/call_video/call_video_imports.dart';


class CallVideoScreen extends StatelessWidget {
  const CallVideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CallVideoCubit()..initCallVideoData(),
      child: BlocBuilder<CallVideoCubit, CallVideoState>(
        builder: (context, state) {
          var cubit = CallVideoCubit.get(context);
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height - 140,
                    child: Stack(
                      children: [
                        Center(
                          child: cubit.remoteVideo(),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: SizedBox(
                            width: 160,
                            height: 180,
                            child: Center(
                              child: cubit.localUserJoined
                                  ? const LocalVideoWidget()
                                  : const CircularProgressIndicator(),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white70,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios_sharp,
                              color: Colors.black,
                              size: 15,
                            ),
                          ),
                        ),
                        // Align(
                        //   alignment: Alignment.topLeft,
                        //   child: Container(
                        //     padding: const EdgeInsets.all(25),
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(50),
                        //       color: Colors.white70,
                        //     ),
                        //     child: Text(
                        //       cubit.getFormattedTime(cubit.state is CallTimeUpdatedState
                        //           ? (cubit.state as CallTimeUpdatedState).secondsElapsed
                        //           : 0),
                        //       style: const TextStyle(color: Colors.black, fontSize: 20),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  CallVideoActions(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
