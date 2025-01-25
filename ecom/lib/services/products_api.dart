import 'package:ecom/server/server_api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';

const String domaineName = BackendApi.domaineURI;

class ServicesAPiProducts {
  Dio dio = Dio();
  //obtenir les produits
  getAllProducts() async {
    var uri = "$domaineName/products";
    return await dio.get(uri,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': "Bearer ",
          },
        ));
  }

  //obtenir les produits
  getProductPlusAchete() async {
    var uri = "$domaineName/commandes/plus-achetes";
    return await dio.get(uri,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': "Bearer ",
          },
        ));
  }

  //obtenir les produits
  getSingleProducts(id) async {
    var uri = "$domaineName/products/single/$id";
    return await dio.get(uri,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': "Bearer ",
          },
        ));
  }

//obtenir les produits
  getAllCategorys() async {
    var uri = "$domaineName/products/categorie-product";
    return await dio.get(uri,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': "Bearer ",
          },
        ));
  }

  //obtenir les promos
  getPromo() async {
    var uri = "$domaineName/products/promo";
    return await dio.get(uri,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': "Bearer ",
          },
        ));
  }

  //obtenir les promos
  getAllPromo() async {
    var uri = "$domaineName/products/promo/all-offres";
    return await dio.get(uri,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': "Bearer ",
          },
        ));
  }

  //obtenir les promos
  postCommit(id, comment) async {
    var uri = "$domaineName/commentaires/$id";
    return await dio.post(uri,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': "Bearer ",
          },
        ));
  }

  //message en cas de succès!
  void showSnackBarSuccessPersonalized(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message,
          style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w400)),
      backgroundColor: const Color.fromARGB(255, 255, 157, 11),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: "",
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ));
  }

  //message en cas de succès!
  void showSnackBarErrorPersonalized(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message,
          style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w400)),
      backgroundColor: const Color.fromARGB(255, 255, 157, 11),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: "",
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ));
  }
}
