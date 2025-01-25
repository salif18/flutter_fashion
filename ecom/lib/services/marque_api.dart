import 'package:ecom/server/server_api.dart';
import 'package:dio/dio.dart';

const String domaineName = BackendApi.domaineURI;

class ServicesAPiMarques {
Dio dio = Dio();
  
  //obtenir les produits
  getAllMarques() async {
    var uri = "$domaineName/marques";
    return await dio.get(
      uri,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer ",
      },)
    );
  }
}