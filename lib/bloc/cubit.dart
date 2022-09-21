import 'package:artsbyzee/bloc/states.dart';
import 'package:artsbyzee/main.dart';
import 'package:artsbyzee/models/productClass.dart';
import 'package:artsbyzee/modules/auth/login.dart';
import 'package:artsbyzee/modules/auth/signup.dart';
import 'package:artsbyzee/modules/auth/verifyPassword.dart';
import 'package:artsbyzee/shared/components.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modules/screens/homeScreen.dart';

class ZEECubit extends Cubit<ZEEStates> {
  ZEECubit() : super(InitialState());

  static ZEECubit Get(context) => BlocProvider.of(context);
////////////////////////// Authentications //////////////////////////////////////
  Future<void> signUp(String userName, String email, String password,
      String phoneNumber, BuildContext context) async {
    isRendered = false;
    emit(UpdateSmallData());
    var response = await Dio().post("$BASE_URL/signup", data: {
      "email": email,
      "password": password,
      "name": userName,
      "phoneNumber": phoneNumber
    }).then((value) async {
      final db = await SharedPreferences.getInstance();
      await db.setString("token", value.data["token"]);
      await db.setStringList("userData", [userName, phoneNumber]);
      userToken = value.data["token"];
      isRendered = true;
      emit(UpdateSmallData());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Row(
            children: [Icon(Icons.done), Text(value.data["success"])],
          )));
    }).catchError((onError) {
      isRendered = true;
      emit(UpdateSmallData());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              Icon(Icons.error),
              Text(onError.response.data["failure"])
            ],
          )));
    });
  }

  Future<void> logIn(
      BuildContext context, String email, String password) async {
    isRendered = false;
    emit(UpdateSmallData());
    var response = await Dio().post("$BASE_URL/login",
        data: {"email": email, "password": password}).then((value) async {
      final db = await SharedPreferences.getInstance();
      await db.setStringList(
          "userData", [value.data["name"], value.data["phoneNumber"]]);
      await db.setString("token", value.data["token"]);
      userToken = value.data["token"];
      isRendered = true;
      emit(UpdateSmallData());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false);
      ;
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              Icon(Icons.error),
              Text(onError.response.data["failure"])
            ],
          )));
      isRendered = true;
      emit(UpdateSmallData());
    });
  }

  Future<void> signOut() async {
    var db = await SharedPreferences.getInstance();
    await db.remove("userData");
    await db.remove("token");
  }

  Future<void> verifyUser(
    BuildContext context,
    String email,
    String password,
  ) async {
    isRendered = false;
    emit(UpdateSmallData());
    var response = await Dio().post("$BASE_URL/verifyuser", data: {
      "email": email,
      "password": password,
    }).then((value) {
      isRendered = true;
      emit(UpdateSmallData());
      tempOtp = value.data["otp"];
      goTo(context, const VerifyUser());
    }).catchError((onError) {
      isRendered = true;
      emit(UpdateSmallData());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              Text("${onError.response.data["failure"]}")
            ],
          )));
    });
  }

  Future<void> forgotPassword(BuildContext context, String email) async {
    isRendered = false;
    emit(UpdateSmallData());
    await Dio().post("$BASE_URL/password/forgotpassword",
        data: {"email": email}).then((value) {
      isRendered = true;
      emit(UpdateSmallData());
      tempOtp = value.data["otp"];
      goTo(
          context,
          VerifyUser(
            isVerify: false,
            Email: email,
          ));
    }).catchError((onError) {
      isRendered = true;
      emit(UpdateSmallData());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              const Icon(Icons.error),
              Text(onError.response.data["failure"])
            ],
          )));
    });
  }

  Future<void> changePassword(
      BuildContext context, String email, String password) async {
    isRendered = false;
    emit(UpdateSmallData());
    await Dio().put("$BASE_URL/password/changepassword", data: {
      "email": email,
      "password": password,
    }).then((value) {
      isRendered = true;
      emit(UpdateSmallData());
      goTo(context, const LogIn());

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Row(
            children: [const Icon(Icons.done), Text(value.data["success"])],
          )));
    }).catchError((onError) {
      isRendered = true;
      emit(UpdateSmallData());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              const Icon(Icons.error),
              Text(onError.response.data["failure"])
            ],
          )));
    });
  }

/////////////////////////////////////////////////////////////////////////////////////////
  ///                         Trading                                           ///////
///////////////////////////////////////////////////////////////////////////////////////
  List allProducts = [];
  List searchedProducts = [];
  Future<List> getProducts(BuildContext context) async {
    allProducts.clear();
    await Dio()
        .get("$BASE_URL/usersPage/products",
            options: Options(headers: {"token": userToken}))
        .then((value) {
      value.data.forEach((val) {
        allProducts.add(Product(
          productID: val["_id"],
          name: val["name"],
          price: val["price"],
          description: val["description"],
          images: val["images"],
        ));
      });
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              const Icon(Icons.error),
              Text(onError.response.data["failure"])
            ],
          )));
    });

    return allProducts;
  }

  Future<void> searchProduct(BuildContext context, String keyWord) async {
    isRendered = false;
    emit(UpdateSmallData());
    var response = await Dio()
        .post("$BASE_URL/usersPage/products/search",
            data: keyWord, options: Options(headers: {"token": userToken}))
        .then((value) {
      value.data.forEach((val) {
        searchedProducts.add(Product(
          name: val["name"],
          price: val["price"],
          description: val["description"],
          images: val["images"] as List<String>,
        ));
      });
      isRendered = true;
      emit(UpdateSmallData());
    }).catchError((onError) {
      isRendered = true;
      emit(UpdateSmallData());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              const Icon(Icons.error),
              Text(onError.response.data["failure"])
            ],
          )));
    });
  }

  Future<void> makeAnOrder(BuildContext context, String productID,
      String address, String describe, Product product) async {
    isRendered = false;
    emit(UpdateSmallData());
    final db = await SharedPreferences.getInstance();
    List<String>? userData = db.getStringList("userData");
    var response = await Dio().post(
        "$BASE_URL/usersPage/products/$productID/order_this_product",
        options: Options(headers: {"token": userToken!.trim()}),
        data: {
          "address": address,
          "userName": userData![0],
          "phoneNumber": userData[1],
          "describe": describe,
          "product": {
            "name": product.name,
            "description": product.description,
            "price": product.price,
            "images": product.images
          }
        }).then((value) {
      isRendered = true;
      emit(UpdateSmallData());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Row(
            children: [Icon(Icons.done), Text(value.data["success"])],
          )));
    }).catchError((onError) {
      isRendered = true;
      emit(UpdateSmallData());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              Icon(Icons.error),
              Text(onError.response.data["failure"])
            ],
          )));
    });
  }

  /////////////////////////////////////////////////////////////////////////////////////////
  ///                                Admin                                          ///////
///////////////////////////////////////////////////////////////////////////////////////////
  ///
  Future<void> addProduct(BuildContext context, Product product) async {
    isRendered = false;
    emit(UpdateSmallData());
    await Dio().post("$BASE_URL/admin/addProduct", data: {
      "name": product.name,
      "description": product.description,
      "price": product.price,
      "images": product.images
    }).then((value) {
      isRendered = true;
      emit(UpdateSmallData());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Row(
            children: [Icon(Icons.done), Text(value.data["success"])],
          )));
    }).catchError((onError) {
      isRendered = true;
      emit(UpdateSmallData());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              Icon(Icons.error),
              Text(onError.response.data["failure"])
            ],
          )));
    });
  }

  Future<void> deleteProduct(BuildContext context, String productID) async {
    isRendered = false;
    emit(UpdateSmallData());
    await Dio()
        .delete("$BASE_URL/admin/deleteProduct", data: productID)
        .then((value) {
      isRendered = true;
      emit(UpdateSmallData());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Row(
            children: [Icon(Icons.done), Text(value.data["success"])],
          )));
    }).catchError((onError) {
      isRendered = true;
      emit(UpdateSmallData());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              Icon(Icons.error),
              Text(onError.response.data["failure"])
            ],
          )));
    });
  }

  Future<void> completeOrder(BuildContext context, String productID) async {
    isRendered = false;
    emit(UpdateSmallData());
    await Dio()
        .delete("$BASE_URL/admin/complete_order", data: productID)
        .then((value) {
      isRendered = true;
      emit(UpdateSmallData());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Row(
            children: [Icon(Icons.done), Text(value.data["success"])],
          )));
    }).catchError((onError) {
      isRendered = true;
      emit(UpdateSmallData());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              Icon(Icons.error),
              Text(onError.response.data["failure"])
            ],
          )));
    });
  }

  Future<int> getStatistics() async {
    await Dio().get("$BASE_URL/admin/get_all_number_of_orders").then((value) {
      return value.data;
    });

    return -1;
  }
}
