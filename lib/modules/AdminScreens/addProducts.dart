import 'package:artsbyzee/bloc/cubit.dart';
import 'package:artsbyzee/bloc/states.dart';
import 'package:artsbyzee/models/productClass.dart';
import 'package:artsbyzee/shared/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var name = TextEditingController();
    var price = TextEditingController();
    var description = TextEditingController();
    var imageLink = TextEditingController();
    List imagesLinks = [];
    var formKey = GlobalKey<FormState>();

    return BlocBuilder<ZEECubit, ZEEStates>(builder: ((context, state) {
      return Scaffold(
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 50,
            backgroundColor: pink,
            title: const Center(child: Text("Add Products")),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 350,
                    child: Form(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextField(
                          controller: name,
                          decoration: InputDecoration(
                              labelText: "Product Name",
                              prefixIcon: Icon(Icons.shopping_bag, color: pink),
                              prefixIconColor: pink,
                              floatingLabelStyle: TextStyle(color: pink),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: pink,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: babyBlue,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        TextField(
                          controller: description,
                          decoration: InputDecoration(
                              labelText: "Product Description",
                              prefixIcon: Icon(Icons.description, color: pink),
                              prefixIconColor: pink,
                              floatingLabelStyle: TextStyle(color: pink),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: pink,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: babyBlue,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: price,
                          decoration: InputDecoration(
                              labelText: "Product Price",
                              prefixIcon: Icon(Icons.monetization_on_rounded,
                                  color: pink),
                              prefixIconColor: pink,
                              floatingLabelStyle: TextStyle(color: pink),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: pink,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: babyBlue,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        TextFormField(
                          controller: imageLink,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    imagesLinks.add(imageLink.text);
                                    imageLink.text = "";
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: pink,
                                  )),
                              labelText: "Product Image Link",
                              prefixIcon: Icon(Icons.image, color: pink),
                              prefixIconColor: pink,
                              floatingLabelStyle: TextStyle(color: pink),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: pink,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: babyBlue,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ],
                    )),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  isRendered
                      ? ZeeAppButton("Add Product", () {
                          ZEECubit.Get(context).addProduct(
                              context,
                              Product(
                                name: name.text,
                                description: description.text,
                                price: double.parse(price.text),
                                images: imagesLinks,
                              ));
                        })
                      : const Loading()
                ],
              ),
            ),
          ));
    }));
  }
}
