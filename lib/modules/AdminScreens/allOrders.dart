import 'package:artsbyzee/bloc/cubit.dart';
import 'package:artsbyzee/bloc/states.dart';
import 'package:artsbyzee/shared/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllOrders extends StatelessWidget {
  const AllOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ZEECubit, ZEEStates>(builder: ((context, state) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 50,
          backgroundColor: pink,
          title: const Center(child: Text("Add Products")),
        ),
        body: FutureBuilder(
          builder: ((context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const NoOrders(
                        width: 200,
                      ),
                      Text(
                        "No Orders yet ZoZZa\nDon't worry",
                        style: TextStyle(
                          color: pink,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                );
              }
              return ListView.separated(
                  itemBuilder: ((context, index) {
                    return snapshot.data[index].orderCard(context);
                  }),
                  separatorBuilder: ((context, index) => const SizedBox(
                        height: 20,
                      )),
                  itemCount: snapshot.data.length);
            } else {
              return const Center(
                child: Loading(
                  width: 150,
                ),
              );
            }
          }),
          future: ZEECubit.Get(context).getOrders(context),
        ),
      );
    }));
  }
}
