import 'package:artsbyzee/bloc/cubit.dart';
import 'package:artsbyzee/bloc/states.dart';
import 'package:artsbyzee/shared/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class Tutorial extends StatelessWidget {
  final String? title, description, link;
  final DateTime? time;
  const Tutorial(
      {super.key, this.title, this.description, this.link, this.time});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        goTo(context, tutorialFullPage());
      },
      child: Card(
        child:
            Row(children: [Text("${this.title}"), Text("${this.description}")]),
      ),
    );
  }

  Widget tutorialFullPage() {
    var controller = VideoPlayerController.network("${this.link}");
    controller.initialize();
    return BlocBuilder<ZEECubit, ZEEStates>(builder: (context, state) {
      return Scaffold(
        backgroundColor: babyBlue,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                controller.pause();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          title: Text(this.title.toString()),
          elevation: 0,
          toolbarHeight: 50,
          backgroundColor: pink,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: pink,
          child: controller.value.isPlaying
              ? Icon(
                  Icons.pause,
                  color: Colors.white,
                )
              : Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
          onPressed: () {
            if (controller.value.isPlaying) {
              controller.pause();
              ZEECubit.Get(context).emit(UpdateSmallData());
            } else {
              controller.play();
              ZEECubit.Get(context).emit(UpdateSmallData());
            }
            print(controller.value.isPlaying);
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              AspectRatio(
                child: VideoPlayer(controller),
                aspectRatio: controller.value.aspectRatio,
              ),
              Container(
                  child: VideoProgressIndicator(controller,
                      allowScrubbing: true,
                      colors: VideoProgressColors(
                        playedColor: Colors.red,
                        bufferedColor: Colors.grey,
                      ))),
            ],
          ),
        ),
      );
    });
  }
}
