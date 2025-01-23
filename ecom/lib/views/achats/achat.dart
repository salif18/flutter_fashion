import 'dart:convert';

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
      final body = jsonDecode(res.body);

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
    } catch (e) {
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
                        Text("En attente d'expédition",
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
                        Text("Commandes Expédiées",
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
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section principale de l'achat
            Card(
              margin: const EdgeInsets.all(10.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "COMMANDE N° : ${order.id.substring(0, 8).toUpperCase()}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Divider(height: 1,color: Colors.black),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 16.0),
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
                            const SizedBox(width: 25),
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
                             const SizedBox(width: 25),
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
                             const SizedBox(width: 25),
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
                             const SizedBox(width: 25),
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
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Détails de la commande",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    const SizedBox(height: 10.0),
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
            const SizedBox(height: 10),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Adresse",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    const SizedBox(height: 10.0),
                    Text(order.user.nom),
                    Row(
                      children: [
                        const Icon(Icons.phone),
                        const SizedBox(width: 10.0),
                        Text(order.user.numero),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.email),
                        const SizedBox(width: 10.0),
                        Text(order.user.email),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_city),
                        const SizedBox(width: 10.0),
                        Text(order.address.ville),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_pin),
                        const SizedBox(width: 10.0),
                        Text(order.address.rue),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.home),
                        const SizedBox(width: 10.0),
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
  }
}
