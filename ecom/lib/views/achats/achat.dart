import 'dart:async';

import 'package:dio/dio.dart';
import 'package:ecom/models/order_model.dart';
import 'package:ecom/providers/auth_provider.dart';
import 'package:ecom/services/order_api.dart';
import 'package:ecom/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AchatView extends StatefulWidget {
  const AchatView({super.key});

  @override
  State<AchatView> createState() => _AchatViewState();
}

class _AchatViewState extends State<AchatView> {
  ServicesAPiOrder api = ServicesAPiOrder();
  List<OrderModel> _allOrders = [];
  List<OrderModel> _livreeOrders = [];
  List<OrderModel> _enCoursOrders = [];
  List<OrderModel> _annuleeOrders = [];

  Future<void> fetchOrdersData() async {
    try {
      final provider = Provider.of<AuthProvider>(context, listen: false);
      var userId = provider.userId;
      final res = await api.getAllOrders(userId);
      final body = res.data;

      if (res.statusCode == 200) {
        final allOrders = (body["orders"] as List)
            .map((json) => OrderModel.fromJson(json))
            .toList();

        setState(() {
          _allOrders = allOrders;
          _livreeOrders =
              _allOrders.where((order) => order.status == "Livrée").toList();
          _enCoursOrders = _allOrders
              .where((order) => order.status == "En attente")
              .toList();
          _annuleeOrders =
              _allOrders.where((order) => order.status == "Annulée").toList();
        });
      } else {
        throw Exception("Erreur serveur : ${res.statusCode}");
      }
    } on DioException {
      api.showSnackBarErrorPersonalized(
          context, "Problème de connexion : Vérifiez votre Internet.");
      print("Erreur de connexion : Impossible d'accéder au serveur.");
    } on TimeoutException {
      api.showSnackBarErrorPersonalized(
          context, "Le serveur ne répond pas. Veuillez réessayer plus tard.");
      print("Erreur : Temps d'attente dépassé.");
    }catch (e) {
      throw Exception("Erreur serveur  : $e");
    }
  }

  void handleChangeStatus(String orderId, String newStatus) async{
    // Implémenter la logique pour changer le statut
     final res = await api.changeStatus(orderId, newStatus);
     if(res.statusCode == 200){
      // ignore: use_build_context_synchronously
      api.showSnackBarSuccessPersonalized(context, "Commande annulée avec succes!!");
     }
  }

  @override
  void initState() {
    super.initState();
    fetchOrdersData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 100,
              pinned: true,
              floating: true,
              centerTitle: true,
              title: Text(
                "Mes Achats",
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize:
                      MediaQuery.of(context).size.width * AppSizes.fontMedium,
                ),
              ),
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: const Color.fromARGB(255, 253, 114, 0),
                indicatorWeight: 0.1,          
                tabs: [
                  Tab(
                    child: Row(
                      children: [
                        Text("En attente de livraison",
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: MediaQuery.of(context).size.width *
                                  AppSizes.fontSmall,
                            )),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.inventory_2_outlined,
                          size: 30,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      children: [
                        Text("Commandes Livrées",
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: MediaQuery.of(context).size.width *
                                  AppSizes.fontSmall,
                            )),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.local_shipping_outlined,
                          size: 30,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      children: [
                        Text("Commandes Retournées",
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: MediaQuery.of(context).size.width *
                                  AppSizes.fontSmall,
                            )),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.autorenew_sharp,
                          size: 30,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(children: [
          // Onglet En cours
          buildOrdersList(_enCoursOrders),
          // Onglet Livrée
          buildOrdersList(_livreeOrders),
          // Onglet Annulée
          buildOrdersList(_annuleeOrders),
        ]),
      ),
    );
  }

  Widget buildOrdersList(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          "Aucune commande disponible",
          style: GoogleFonts.roboto(
            fontSize: MediaQuery.of(context).size.width * AppSizes.fontSmall,
          ),
        ),
      );
    }
    return LayoutBuilder(
      builder: (context,constraints){
        return  ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section principale de l'achat
              Card(
                margin: EdgeInsets.all(constraints.maxWidth *AppSizes.converValueToadapter(context, 10)),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(constraints.maxWidth *AppSizes.converValueToadapter(context, 16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "COMMANDE N° : ${order.id.substring(0, 8).toUpperCase()}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: constraints.maxWidth *AppSizes.converValueToadapter(context, 10)),
                      const Divider(height: 1,color: Colors.black),
                      SizedBox(height: constraints.maxWidth *AppSizes.converValueToadapter(context, 10)),
                      if (order.status == "En attente")
                        ElevatedButton(
                          onPressed: () =>
                              handleChangeStatus(order.id, "Annulée"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: Text("Annuler",
                              style: GoogleFonts.roboto(
                                  fontSize: MediaQuery.of(context).size.width *
                                      AppSizes.fontSmall,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      SizedBox(height: constraints.maxWidth *AppSizes.converValueToadapter(context, 16)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Date",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: constraints.maxWidth *AppSizes.converValueToadapter(context, 25)),
                              Text(
                                DateFormat("dd MMM yyyy").format(order.date),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Total",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                               SizedBox(width: constraints.maxWidth *AppSizes.converValueToadapter(context, 25)),
                              Text("${order.total} FCFA"),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Mode de paiement",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                               SizedBox(width: constraints.maxWidth *AppSizes.converValueToadapter(context, 25)),
                              Text(order.payementMode),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Statut de la commande",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                               SizedBox(width: constraints.maxWidth *AppSizes.converValueToadapter(context, 25)),
                              Text(order.status),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Détails de la commande
              Card(
                margin: EdgeInsets.symmetric(horizontal: constraints.maxWidth *AppSizes.converValueToadapter(context, 10)),
                child: Padding(
                  padding: EdgeInsets.all(constraints.maxWidth *AppSizes.converValueToadapter(context, 16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Détails de la commande",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: constraints.maxWidth *AppSizes.converValueToadapter(context, 16)),
                      ),
                      SizedBox(height: constraints.maxWidth *AppSizes.converValueToadapter(context, 10)),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Produits"),
                          Text("Total"),
                        ],
                      ),
                      ...order.cart.map(
                        (item) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${item.name} x${item.qty}"),
                            Text("${item.price * item.qty}"),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Mode de paiement"),
                          Text(order.payementMode),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total"),
                          Text("${order.total} Fcfa"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Adresse
              SizedBox(height: constraints.maxWidth *AppSizes.converValueToadapter(context, 10)),
              Card(
                margin: EdgeInsets.symmetric(horizontal: constraints.maxWidth *AppSizes.converValueToadapter(context, 10)),
                child: Padding(
                  padding: EdgeInsets.all(constraints.maxWidth *AppSizes.converValueToadapter(context, 16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Adresse",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: constraints.maxWidth *AppSizes.converValueToadapter(context, 16)),
                      ),
                      SizedBox(height: constraints.maxWidth *AppSizes.converValueToadapter(context, 10)),
                      Text(order.user.nom),
                      Row(
                        children: [
                          const Icon(Icons.phone),
                          SizedBox(width: constraints.maxWidth *AppSizes.converValueToadapter(context, 10)),
                          Text(order.user.numero),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.email),
                          SizedBox(width: constraints.maxWidth *AppSizes.converValueToadapter(context, 10)),
                          Text(order.user.email),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_city),
                          SizedBox(width: constraints.maxWidth *AppSizes.converValueToadapter(context, 10)),
                          Text(order.address.ville),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_pin),
                          SizedBox(width: constraints.maxWidth *AppSizes.converValueToadapter(context, 10)),
                          Text(order.address.rue),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.home),
                          SizedBox(width: constraints.maxWidth *AppSizes.converValueToadapter(context, 10)),
                          Text(order.address.logt),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      );
      },
      
    );
  }
}
