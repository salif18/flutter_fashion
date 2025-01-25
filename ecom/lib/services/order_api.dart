import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecom/server/server_api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

const String domaineName = BackendApi.domaineURI;

class ServicesAPiOrder {
  Dio dio = Dio();
  //obtenir les produits
  getAllOrders(userId) async {
    var uri = "$domaineName/commandes/order/$userId";
    return await dio.get(uri,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': "Bearer ",
          },
        ));
  }

  //obtenir les produits
  postOrder(Map<String, dynamic> data) async {
    var uri = "$domaineName/commandes";
    return await http.post(Uri.parse(uri), body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ",
    });
  }

  changeStatus(id, newStatus) async {
    var uri = "$domaineName/commandes/order/$id/updateStatus";
    return await http.put(Uri.parse(uri),
        body: jsonEncode(
            {"newStatus": newStatus}), // Format correct pour un JSON),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ",
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
