import 'package:try_agora/call_video/call_video_imports.dart';

class CallEnded extends StatelessWidget {
  const CallEnded({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Your Experience With Agora'),
      ),
      body:  Material(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(0.8, 1),
              colors: <Color>[
                Color(0xff1f005c),
                Color(0xff5b0060),
                Color(0xff870160),
                Color(0xffac255e),
                Color(0xffca485c),
                Color(0xffe16b5c),
                Color(0xfff39060),
                Color(0xffffb56b),
              ], // Gradient from https://learnui.design/tools/gradient-generator.html
              tileMode: TileMode.mirror,
            ),
          ),
          child:const Center(
            child: Text(
              'Video Call Ended',
              style: TextStyle(
                  fontSize: 25
              ),
            ),
          ),
        ),
      ),
    );
  }
}
