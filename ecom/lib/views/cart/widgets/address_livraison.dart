import 'dart:convert';

import 'package:ecom/providers/auth_provider.dart';
import 'package:ecom/providers/cart_provider.dart';
import 'package:ecom/services/order_api.dart';
import 'package:ecom/utils/app_color.dart';
import 'package:ecom/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddressLivraison extends StatefulWidget {
  const AddressLivraison({super.key});

  @override
  State<AddressLivraison> createState() => _AddressLivraisonState();
}

class _AddressLivraisonState extends State<AddressLivraison> {
  ServicesAPiOrder api = ServicesAPiOrder();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nom = TextEditingController();
  final TextEditingController numero = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController ville = TextEditingController();
  final TextEditingController rue = TextEditingController();
  final TextEditingController logt = TextEditingController();
  String selectedPaymentMode = "Non defini";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nom.dispose();
    numero.dispose();
    email.dispose();
    ville.dispose();
    rue.dispose();
    logt.dispose();
    super.dispose();
  }

  Future<void> sendOrders() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final userId = provider.userId;
    final totalProvider = Provider.of<CartProvider>(context, listen: false);
    final total = totalProvider.total;
    final cartprovider = Provider.of<CartProvider>(context, listen: false);
    final cart = cartprovider.cart;

    if (_formKey.currentState!.validate()) {

    try {
      Map<String, dynamic> order = {
        "userId": userId,
        "user": {
          "nom": nom.text,
          "numero": numero.text.toString(),
          "email": email.text,
        },
        "address": {
          "ville": ville.text,
          "rue": rue.text.toString(),
          "logt": logt.text.toString(),
        },
        "payementMode": selectedPaymentMode,
        "status": "En attente",
        "cart": cart.map((item) {
          return {
            "producId": item.id,
            "image": item.img,
            "name": item.name,
            "promotion": item.promotion,
            "price": item.price,
            "qty": item.qty,
            "size": item.selectedSize,
            "color": item.selectedColor,
          };
        }).toList(), // Convertir en liste
        "location": {"lat": null, "lng": null}, // Vérification
        "total": total,
      };

      final response = await api.postOrder(order);
      final body = jsonDecode(response.body);
      if (response.statusCode == 201) {
        cartprovider.clearCart();
        if (!mounted) return;
        Navigator.pop(context);
        api.showSnackBarSuccessPersonalized(context, body["message"]);
      } else {
        if (!mounted) return;
        api.showSnackBarErrorPersonalized(context, body["message"]);
      }
    } catch (e) {
      Exception(e);
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.backgroundPrincal,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // color: const Color.fromARGB(255, 255, 240, 218)
          ),
          child: SingleChildScrollView(child: _formulaires(context)),
        ),
      ),
    );
  }

  Widget _formulaires(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Faites-vous livrer chez vous !",
                  style: GoogleFonts.abel(
                      fontSize: MediaQuery.of(context).size.width *
                          AppSizes.fontLarge,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Remplissez bien les renseignements",
                  style: GoogleFonts.abel(
                      fontSize: MediaQuery.of(context).size.width *
                          AppSizes.fontMedium),
                ),
              ],
            ),
          ),
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: const DecorationImage(
                image: AssetImage("assets/logos/delivery1.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: nom,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez votre nom';
                }
                return null;
              },
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                hintText: "Nom",
                hintStyle: GoogleFonts.aBeeZee(
                    fontSize:
                        MediaQuery.of(context).size.width * AppSizes.fontSmall,
                    fontWeight: FontWeight.w400),
                prefixIcon: Icon(Icons.person_2_outlined,
                    size:
                        MediaQuery.of(context).size.width * AppSizes.iconLarge),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: numero,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez votre numéro';
                }
                return null;
              },
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                hintText: "Numero",
                hintStyle: GoogleFonts.aBeeZee(
                    fontSize:
                        MediaQuery.of(context).size.width * AppSizes.fontSmall,
                    fontWeight: FontWeight.w400),
                prefixIcon: Icon(Icons.phone_android_outlined,
                    size:
                        MediaQuery.of(context).size.width * AppSizes.iconLarge),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: email,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez votre e-mail';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                hintText: "Email",
                hintStyle: GoogleFonts.aBeeZee(
                    fontSize:
                        MediaQuery.of(context).size.width * AppSizes.fontSmall,
                    fontWeight: FontWeight.w400),
                prefixIcon: Icon(Icons.mail_outline,
                    size:
                        MediaQuery.of(context).size.width * AppSizes.iconLarge),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: ville,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez votre quartier';
                }
                return null;
              },
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                hintText: "Quartier",
                hintStyle: GoogleFonts.aBeeZee(
                    fontSize:
                        MediaQuery.of(context).size.width * AppSizes.fontSmall,
                    fontWeight: FontWeight.w400),
                prefixIcon: Icon(Icons.villa_outlined,
                    size:
                        MediaQuery.of(context).size.width * AppSizes.iconLarge),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: rue,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez votre rue';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                hintText: "Rue",
                hintStyle: GoogleFonts.aBeeZee(
                    fontSize:
                        MediaQuery.of(context).size.width * AppSizes.fontSmall,
                    fontWeight: FontWeight.w400),
                prefixIcon: Icon(Icons.streetview,
                    size:
                        MediaQuery.of(context).size.width * AppSizes.iconLarge),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: logt,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez votre logt';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                hintText: "Logement",
                hintStyle: GoogleFonts.aBeeZee(
                    fontSize:
                        MediaQuery.of(context).size.width * AppSizes.fontSmall,
                    fontWeight: FontWeight.w400),
                prefixIcon: Icon(Icons.home_filled,
                    size:
                        MediaQuery.of(context).size.width * AppSizes.iconLarge),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mode de paiement",
                  style: GoogleFonts.aBeeZee(
                    fontSize:
                        MediaQuery.of(context).size.width * AppSizes.fontSmall,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    RadioListTile<String>(
                      value: "Passer à la boutique",
                      groupValue: selectedPaymentMode,
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMode = value!;
                        });
                      },
                      title: Text(
                        "Passer à la boutique",
                        style: GoogleFonts.aBeeZee(
                          fontSize: MediaQuery.of(context).size.width *
                              AppSizes.fontSmall,
                        ),
                      ),
                      activeColor: Colors.blue,
                    ),
                    RadioListTile<String>(
                      value: "À la livraison",
                      groupValue: selectedPaymentMode,
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMode = value!;
                        });
                      },
                      title: Text(
                        "À la livraison",
                        style: GoogleFonts.aBeeZee(
                          fontSize: MediaQuery.of(context).size.width *
                              AppSizes.fontSmall,
                        ),
                      ),
                      activeColor: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // MapsPage(getLatLng: getLatLng),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: Text("Valider",
                                style: GoogleFonts.roboto(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            AppSizes.fontSmall,
                                    color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Coordonnées géographiques",
                        style: GoogleFonts.roboto(
                            fontSize: MediaQuery.of(context).size.width *
                                AppSizes.fontSmall,
                            color: Colors.white)),
                    const SizedBox(width: 10),
                    Icon(Icons.location_searching,
                        size: MediaQuery.of(context).size.width *
                            AppSizes.iconLarge,
                        color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(400, 50),
              ),
              onPressed: () {
                sendOrders();
                // Navigator.pop(context);
              },
              child: Text("Passer commande",
                  style: GoogleFonts.roboto(
                      fontSize: MediaQuery.of(context).size.width *
                          AppSizes.fontSmall,
                      color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
