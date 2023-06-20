import 'package:artsbyzee/bloc/cubit.dart';
import 'package:artsbyzee/bloc/states.dart';
import 'package:artsbyzee/shared/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TutorialsPage extends StatelessWidget {
  const TutorialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ZEECubit, ZEEStates>(builder: (context, state) {
      return Scaffold(
          backgroundColor: babyBlue,
          appBar: AppBar(
            title: Text("Tutorials"),
            elevation: 0,
            toolbarHeight: 50,
            backgroundColor: pink,
          ),
          body: FutureBuilder(
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                return ListView.separated(
                    itemBuilder: (context, index) {
                      return snapshot.data[index];
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 10,
                      );
                    },
                    itemCount: snapshot.data.length);
              } else {
                return Center(child: Loading(width: 150));
              }
            },
            future: ZEECubit.Get(context).getAllTutorials(),
          ));
    });
  }
}
