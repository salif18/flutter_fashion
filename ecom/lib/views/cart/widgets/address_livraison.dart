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
  final constraints;
  const AddressLivraison({super.key, required this.constraints});

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
      height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 720),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15),),
        color: AppColors.backgroundPrincal,
      ),
      child: Padding(
        padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 8),),
        child: Container(
          padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 5),),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15),),
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
            padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 8),),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Faites-vous livrer chez vous !",
                  style: GoogleFonts.abel(
                      fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 24),
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Remplissez bien les renseignements",
                  style: GoogleFonts.abel(
                      fontSize:widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 16),),
                ),
              ],
            ),
          ),
          Container(
            height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 180),
            width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 180),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context,5),),
              image: const DecorationImage(
                image: AssetImage("assets/logos/delivery1.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 10),),
          Padding(
            padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
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
                        widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                    fontWeight: FontWeight.w400),
                prefixIcon: Icon(Icons.person_2_outlined,
                    size:
                       widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 24)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 10)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding:EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
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
                       widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                    fontWeight: FontWeight.w400),
                prefixIcon: Icon(Icons.phone_android_outlined,
                    size:
                        widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 24)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 10)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
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
                      widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                    fontWeight: FontWeight.w400),
                prefixIcon: Icon(Icons.mail_outline,
                    size:
                       widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 24)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 10)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
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
                       widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                    fontWeight: FontWeight.w400),
                prefixIcon: Icon(Icons.villa_outlined,
                    size:
                        widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 24)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 10)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
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
                       widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                    fontWeight: FontWeight.w400),
                prefixIcon: Icon(Icons.streetview,
                    size:
                       widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 24)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 10)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
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
                       widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                    fontWeight: FontWeight.w400),
                prefixIcon: Icon(Icons.home_filled,
                    size:
                      widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 24)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 10)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mode de paiement",
                  style: GoogleFonts.aBeeZee(
                    fontSize:
                       widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 10)),
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
                          fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
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
                          fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                        ),
                      ),
                      activeColor: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
          //   child: GestureDetector(
          //     onTap: () {
          //       showDialog(
          //         context: context,
          //         builder: (BuildContext context) {
          //           return AlertDialog(
          //             contentPadding: EdgeInsets.symmetric(
          //                 vertical: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 5), horizontal: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 5)),
          //             content: Column(
          //               mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 // MapsPage(getLatLng: getLatLng),
          //                 ElevatedButton(
          //                   onPressed: () {
          //                     Navigator.pop(context);
          //                   },
          //                   style: ElevatedButton.styleFrom(
          //                     backgroundColor: Colors.blue,
          //                   ),
          //                   child: Text("Valider",
          //                       style: GoogleFonts.roboto(
          //                           fontSize:
          //                               widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
          //                           color: Colors.white)),
          //                 ),
          //               ],
          //             ),
          //           );
          //         },
          //       );
          //     },
          //     child: Container(
          //       height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 40),
          //       width: double.infinity,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
          //         color: Colors.blue,
          //       ),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Text("Coordonnées géographiques",
          //               style: GoogleFonts.roboto(
          //                   fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
          //                   color: Colors.white)),
          //           SizedBox(width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 10)),
          //           Icon(Icons.location_searching,
          //               size: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 24),
          //               color: Colors.white),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 400), widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 40)),
              ),
              onPressed: () {
                sendOrders();
                // Navigator.pop(context);
              },
              child: Text("Passer commande",
                  style: GoogleFonts.roboto(
                      fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                      color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
