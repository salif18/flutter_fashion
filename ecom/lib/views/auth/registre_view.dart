import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecom/providers/auth_provider.dart';
import 'package:ecom/routes.dart';
import 'package:ecom/services/auth_api.dart';
import 'package:ecom/utils/app_color.dart';
import 'package:ecom/utils/app_size.dart';
import 'package:ecom/views/auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegistreView extends StatefulWidget {
  const RegistreView({super.key});

  @override
  State<RegistreView> createState() => _RegistreViewState();
}

class _RegistreViewState extends State<RegistreView> {
  // CLE KEY FORMULAIRE
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  // API SERVICE AUTHENTIFICATION
  ServicesAuth api = ServicesAuth();

  // CHAMPS FORMULAIRES
  final _nom = TextEditingController();
  final _numero = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool isVisibility = true;

  @override
  void dispose() {
    _nom.dispose();
    _numero.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  // ENVOIE DES DONNÉES VERS API SERVER
  Future<void> _sendToserver(BuildContext context) async {
    if (_globalKey.currentState!.validate()) {
      final data = {
        "name": _nom.text,
        "numero": _numero.text,
        "email": _email.text,
        "password": _password.text
      };
      final provider = Provider.of<AuthProvider>(context, listen: false);
      try {
        showDialog(
            context: context,
            builder: (context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            });

        final response = await api.postRegistreUser(data);
        final body = json.decode(response.body);

        if (!mounted) return; // Vérification avant l'utilisation de Navigator

        // ignore: use_build_context_synchronously
        Navigator.pop(context); // Fermer le dialog

        if (response.statusCode == 201) {
          provider.loginButton(body['token'], body["userId"].toString(),
              body["userName"], body["entreprise"], body["userNumber"]);

          Navigator.pushReplacement(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(builder: (context) => const Routes()));
        } else {
          // ignore: use_build_context_synchronously
          api.showSnackBarErrorPersonalized(context, body["message"]);
        }
      }on DioException {
      api.showSnackBarErrorPersonalized(
          context, "Problème de connexion : Vérifiez votre Internet.");
      print("Erreur de connexion : Impossible d'accéder au serveur.");
    } on TimeoutException {
      api.showSnackBarErrorPersonalized(
          context, "Le serveur ne répond pas. Veuillez réessayer plus tard.");
      print("Erreur : Temps d'attente dépassé.");
    } catch (e) {
        if (!mounted) return; // Vérification avant l'utilisation de Navigator
        // ignore: use_build_context_synchronously
        Navigator.pop(context); // Fermer le dialogue
        // ignore: use_build_context_synchronously
        api.showSnackBarErrorPersonalized(context, "Erreur: ${e.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrincal,
      body: LayoutBuilder(
        builder: (context, constraints){
          return CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  height: constraints.maxWidth * AppSizes.converValueToadapter(context,250),
                  width: constraints.maxWidth ,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/logos/logo1.jpg"),
                        fit: BoxFit.contain),
                  ),
                ),
              ]),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                height: constraints.maxWidth * AppSizes.converValueToadapter(context,600),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                  top: constraints.maxWidth * AppSizes.converValueToadapter(context,20), 
                  left: constraints.maxWidth * AppSizes.converValueToadapter(context,10), 
                  right: constraints.maxWidth * AppSizes.converValueToadapter(context,10)),
                decoration: BoxDecoration(
                  color: AppColors.banerBtnNavigatorBackground,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context,20)),
                    topRight: Radius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context,20)),
                  ),
                ),
                child: Form(
                  key: _globalKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context,8)),
                        child: Column(
                          children: [
                            Text(
                              "Création de compte",
                              style: GoogleFonts.roboto(
                                  fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context,20),
                                  color: Colors.white),
                            ),
                            Text(
                              "Information personnelle",
                              style: GoogleFonts.roboto(
                                  fontSize:constraints.maxWidth * AppSizes.converValueToadapter(context,14),
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context,8)),
                        child: TextFormField(
                          controller: _nom,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un nom';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: constraints.maxWidth * AppSizes.converValueToadapter(context,10)),
                              hintText: "Nom",
                              hintStyle: GoogleFonts.roboto(
                                  fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context,14)),
                              filled: true,
                              fillColor: const Color(0xfff0fcf3),
                              prefixIcon: Icon(Icons.person_3_outlined,
                                  size: constraints.maxWidth * AppSizes.converValueToadapter(context,20)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context,20)),
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                      SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context,8)),
                      Padding(
                        padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context,8)),
                        child: TextFormField(
                          controller: _numero,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un numero';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: constraints.maxWidth * AppSizes.converValueToadapter(context,10)),
                              hintText: "Numero",
                              hintStyle: GoogleFonts.roboto(
                                  fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context,14)),
                              filled: true,
                              fillColor: const Color(0xfff0fcf3),
                              prefixIcon: Icon(Icons.phone_android_outlined,
                                  size: constraints.maxWidth * AppSizes.converValueToadapter(context,20)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context,20)),
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                      SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context,8)),
                      Padding(
                        padding:EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context,8)),
                        child: TextFormField(
                          controller: _email,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un e-mail';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              isDense: true,
                              contentPadding:  EdgeInsets.symmetric(
                                  horizontal: constraints.maxWidth * AppSizes.converValueToadapter(context,8)),
                              hintText: "Email",
                              hintStyle: GoogleFonts.roboto(
                                  fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context,14)),
                              filled: true,
                              fillColor: const Color(0xfff0fcf3),
                              prefixIcon: Icon(Icons.mail_outline,
                                  size: constraints.maxWidth * AppSizes.converValueToadapter(context,20)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                      SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context,8)),
                      Padding(
                        padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context,8)),
                        child: TextFormField(
                          controller: _password,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un mot de passe';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: isVisibility,
                          decoration: InputDecoration(
                              isDense: true,
                              contentPadding:  EdgeInsets.symmetric(
                                  horizontal: constraints.maxWidth * AppSizes.converValueToadapter(context,10)),
                              hintText: "Mot de passe",
                              hintStyle: GoogleFonts.roboto(
                                  fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context,14)),
                              filled: true,
                              fillColor: const Color(0xfff0fcf3),
                              prefixIcon: Icon(Icons.lock_outline,
                                  size: constraints.maxWidth * AppSizes.converValueToadapter(context,20)),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isVisibility = !isVisibility;
                                    });
                                  },
                                  icon: Icon(isVisibility
                                      ? Icons.visibility_off
                                      : Icons.visibility)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context,20)),
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                       SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context,25)),
                      Padding(
                        padding:  EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context,8)),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(constraints.maxWidth * AppSizes.converValueToadapter(context,400), constraints.maxWidth * AppSizes.converValueToadapter(context,40)),
                              backgroundColor: Colors.deepOrange,
                            ),
                            onPressed: () {
                              _sendToserver(context);
                            },
                            child: Text("Créer compte",
                                style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context,14)))),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Avez vous un compte?",
                            style: GoogleFonts.roboto(
                                fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context,14),
                                color: Colors.white),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const LoginView()));
                              },
                              child: Text(
                                "Se connecter",
                                style: GoogleFonts.roboto(
                                    color: const Color.fromARGB(255, 255, 139, 7),
                                    fontWeight: FontWeight.w600,
                                    fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context,14)),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
        },
       
      ),
    );
  }
}
