import 'package:artsbyzee/bloc/cubit.dart';
import 'package:artsbyzee/bloc/states.dart';
import 'package:artsbyzee/shared/components.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Product extends StatelessWidget {
  final String? name, description, productID;
  final double? price;
  final List? images;
  const Product(
      {this.productID, this.name, this.description, this.images, this.price})
      : super();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ZEECubit, ZEEStates>(builder: (context, state) {
      var cubit = ZEECubit.Get(context);
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 50,
          backgroundColor: pink,
        ),
        backgroundColor: babyBlue,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CarouselSlider(
                  items: images!
                      .map((e) => Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.network(
                            "$e",
                            loadingBuilder: (context, child, loading) {
                              if (loading == null) {
                                return child;
                              } else {
                                return const Loading(
                                  width: 100,
                                );
                              }
                            },
                          )))
                      .toList(),
                  options: CarouselOptions(
                      viewportFraction: 1, enableInfiniteScroll: false)),
              const SizedBox(height: 60),
              Divider(
                thickness: 3,
                color: Color.fromARGB(255, 246, 211, 224),
              ),
              Divider(
                thickness: 3,
                color: Color.fromARGB(255, 246, 211, 224),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "$name",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700]),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "$price EGP",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "$description",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                  child: ZeeAppButton("Make An Order", () {
                goTo(context, confirmingOrder(context));
              }))
            ]),
          ),
        ),
      );
    });
  }

  Widget productCard() {
    TextStyle style =
        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: LinearGradient(colors: [
            Colors.lightBlue.shade100,
            Colors.pink.shade50,
            Colors.white
          ], begin: Alignment.topRight, end: Alignment.bottomCenter),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 140,
                child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.network(
                      "${images![0]}",
                      loadingBuilder: (context, child, loading) {
                        if (loading == null) {
                          return child;
                        } else {
                          return const Loading(
                            width: 100,
                          );
                        }
                      },
                    )),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$name\n\n\n",
                  style: style,
                ),
                Text("$price EGP",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ))
              ],
            ),
            const Icon(
              Icons.navigate_next,
              size: 30,
            )
          ],
        ),
      ),
    );
  }

  Widget confirmingOrder(BuildContext context) {
    var address = TextEditingController();
    var custom = TextEditingController();

    return Scaffold(
      backgroundColor: babyBlue,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                TextField(
                  controller: address,
                  decoration: InputDecoration(
                      labelText: "Address",
                      prefixIcon: Icon(Icons.email, color: pink),
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
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: custom,
                  decoration: InputDecoration(
                      labelText: "Customization (Optional)",
                      prefixIcon: Icon(Icons.add_sharp, color: pink),
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
            ),
            ZeeAppButton("Confirm Order", () {
              if (address.text != null && address.text != " ") {
                ZEECubit.Get(context).makeAnOrder(
                    context,
                    productID as String,
                    address.text,
                    custom.text,
                    Product(
                      name: name,
                      description: description,
                      price: price,
                      images: images,
                    ));
              }
            })
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 50,
        backgroundColor: pink,
        title: const Center(child: Text("Confirm order")),
      ),
    );
  }
}
