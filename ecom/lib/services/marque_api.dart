import 'package:ecom/server/server_api.dart';

import 'package:http/http.dart' as http;

const String domaineName = BackendApi.domaineURI;

class ServicesAPiMarques {

  
  //obtenir les produits
  getAllMarques() async {
    var uri = "$domaineName/marques";
    return await http.get(
      Uri.parse(uri),
     headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
      });
  }
}