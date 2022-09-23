import 'package:artsbyzee/bloc/cubit.dart';
import 'package:artsbyzee/bloc/states.dart';
import 'package:artsbyzee/models/productClass.dart';
import 'package:artsbyzee/shared/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ZEECubit, ZEEStates>(builder: ((context, state) {
      var cubit = ZEECubit.Get(context);
      return Scaffold(
        backgroundColor: babyBlue,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 50,
          backgroundColor: pink,
          title: const Center(child: Text("Products")),
        ),
        body: FutureBuilder(
          builder: (context, AsyncSnapshot ss) {
            if (!ss.hasData) {
              return const Center(
                child: Loading(
                  width: 150,
                ),
              );
            } else {
              if (ss.data.length == 0) {
                return const Center(
                  child: Text(
                    "Sorry no Products for now\nStay tuned !!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                );
              }
              return ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: ss.data[index].productCard(),
                      onTap: () {
                        goTo(context, ss.data[index]);
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                  itemCount: ss.data.length);
            }
          },
          future: ZEECubit.Get(context).getProducts(context),
        ),
      );
    }));
  }
}
