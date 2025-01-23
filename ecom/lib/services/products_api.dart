import 'dart:convert';

import 'package:ecom/server/server_api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

const String domaineName = BackendApi.domaineURI;

class ServicesAPiProducts {
  //obtenir les produits
  getAllProducts() async {
    var uri = "$domaineName/products";
    return await http.get(Uri.parse(uri), headers: {
      "Content-Type": "application/json; charset=UTF-8",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate, br",
    });
  }

  //obtenir les produits
  getSingleProducts(id) async {
    var uri = "$domaineName/products/single/$id";
    return await http.get(Uri.parse(uri), headers: {
      "Content-Type": "application/json; charset=UTF-8",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate, br",
    });
  }

//obtenir les produits
  getAllCategorys() async {
    var uri = "$domaineName/products/categorie-product";
    return await http.get(Uri.parse(uri), headers: {
      "Content-Type": "application/json; charset=UTF-8",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate, br",
    });
  }

  //obtenir les promos
  getPromo() async {
    var uri = "$domaineName/products/promo";
    return await http.get(Uri.parse(uri), headers: {
      "Content-Type": "application/json; charset=UTF-8",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate, br",
    });
  }

  //obtenir les promos
  getAllPromo() async {
    var uri = "$domaineName/products/promo/all-offres";
    return await http.get(Uri.parse(uri), headers: {
      "Content-Type": "application/json; charset=UTF-8",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate, br",
    });
  }

  //obtenir les promos
  postCommit(id, comment) async {
    var uri = "$domaineName/commentaires/$id";
    return await http.post(Uri.parse(uri), body: jsonEncode(comment), headers: {
      "Content-Type": "application/json; charset=UTF-8",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate, br",
    });
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
