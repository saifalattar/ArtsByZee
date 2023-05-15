import 'package:artsbyzee/bloc/cubit.dart';
import 'package:artsbyzee/bloc/states.dart';
import 'package:artsbyzee/modules/screens/productsScreen.dart';
import 'package:artsbyzee/shared/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var search = TextEditingController();
    return BlocBuilder<ZEECubit, ZEEStates>(builder: ((context, state) {
      return Scaffold(
        backgroundColor: babyBlue,
        appBar: AppBar(
          backgroundColor: pink,
          title: const Center(
            child: Text("Search"),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextField(
                controller: search,
                decoration: InputDecoration(
                    labelText: "Search for any product",
                    prefixIcon: Icon(Icons.search, color: pink),
                    prefixIconColor: pink,
                    floatingLabelStyle: TextStyle(color: pink),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: pink,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 5,
                        ),
                        borderRadius: BorderRadius.circular(10))),
              ),
              ZeeAppButton("Search", () {
                goTo(
                    context,
                    ProductsScreen(
                      isSearch: true,
                      keyWord: search.text,
                    ));
              })
            ],
          ),
        ),
      );
    }));
  }
}
