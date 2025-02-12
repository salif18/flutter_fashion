import 'dart:convert';

import 'package:ecom/providers/auth_provider.dart';
import 'package:ecom/routes.dart';
import 'package:ecom/services/auth_api.dart';
import 'package:ecom/utils/app_color.dart';
import 'package:ecom/utils/app_size.dart';
import 'package:ecom/views/auth/registre_view.dart';
import 'package:ecom/views/auth/reset_password.dart';
import 'package:ecom/views/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // CLE KEY POUR LE FORMULAIRE
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final ServicesAuth api = ServicesAuth();

  final _contacts = TextEditingController();
  final _password = TextEditingController();
  bool isVisibility = true;

  @override
  void dispose() {
    _contacts.dispose();
    _password.dispose();
    super.dispose();
  }

  // ENVOIE DES DONNEES VERS API SERVER
  Future<void> _sendToserver(BuildContext context) async {
    if (_globalKey.currentState!.validate()) {
      final data = {"contacts": _contacts.text, "password": _password.text};
      final providerAuth = Provider.of<AuthProvider>(context, listen: false);

      try {
        showDialog(
            context: context,
            builder: (context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? previousPage = prefs.getString('currentPage');
        final response = await api.postLoginUser(data);
        final body = jsonDecode(response.body);
        // ignore: use_build_context_synchronously
        Navigator.pop(context); // Fermer le dialog

        if (response.statusCode == 200) {
          providerAuth.loginButton(body['token'], body["userId"].toString(),
              body["userName"], body["userNumber"], body["userEmail"]);
          if (previousPage != null) {
            // 🔹 Redirection vers la page précédente
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const CartView()));
            prefs.remove('currentPage');
          } else {
            // 🔹 Par défaut, rediriger vers la page d'accueil
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Routes()));
            prefs.remove('currentPage');
          }
        } else {
          // ignore: use_build_context_synchronously
          api.showSnackBarErrorPersonalized(context, body["message"]);
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context); // Fermer le dialog
        // ignore: use_build_context_synchronously
        api.showSnackBarErrorPersonalized(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrincal,
      body: LayoutBuilder(
        builder: (context,constraints){
          return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                width: constraints.maxWidth ,
                height: constraints.maxWidth * AppSizes.converValueToadapter(context,250),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/logos/logo1.jpg"),
                      fit: BoxFit.contain),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: constraints.maxWidth * AppSizes.converValueToadapter(context,550),
                width: constraints.maxWidth ,
                padding: EdgeInsets.only(
                  top: constraints.maxWidth * AppSizes.converValueToadapter(context,50),
                   left: constraints.maxWidth * AppSizes.converValueToadapter(context,10), 
                   right: constraints.maxWidth * AppSizes.converValueToadapter(context,10), ),
                decoration: BoxDecoration(
                  color: AppColors.banerBtnNavigatorBackground,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context,20), ),
                    topRight: Radius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context,20), ),
                  ),
                ),
                child: Form(
                  key: _globalKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context,8), ),
                        child: TextFormField(
                          controller: _contacts,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un numéro ou un e-mail';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding:
                              EdgeInsets.symmetric(horizontal: constraints.maxWidth * AppSizes.converValueToadapter(context,10), ),
                            hintText: "Numéro ou e-mail",
                            hintStyle: GoogleFonts.roboto(
                                fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context,14)),
                            filled: true,
                            fillColor: const Color(0xfff0fcf3),
                            prefixIcon: Icon(Icons.person_2_outlined,
                                size:constraints.maxWidth * AppSizes.converValueToadapter(context,20)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context,20)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context,10)),
                      Padding(
                        padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context,8)),
                        child: TextFormField(
                          controller: _password,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer votre mot de passe';
                            }
                            return null;
                          },
                          obscureText: isVisibility,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: constraints.maxWidth * AppSizes.converValueToadapter(context,10)),
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
                                  : Icons.visibility),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context,20)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context,8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ResetToken()));
                              },
                              child: Text(
                                "Mot de passe oublié ?",
                                style: GoogleFonts.roboto(
                                  fontSize:
                                    constraints.maxWidth * AppSizes.converValueToadapter(context,14),
                                  color: Colors.blue[400],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context,8)),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(constraints.maxWidth * AppSizes.converValueToadapter(context,400),
                             constraints.maxWidth * AppSizes.converValueToadapter(context,40)),
                            backgroundColor: Colors.deepOrange,
                          ),
                          onPressed: () {
                            _sendToserver(context);
                          },
                          child: Text(
                            "Se connecter",
                            style: GoogleFonts.roboto(
                              fontSize:constraints.maxWidth * AppSizes.converValueToadapter(context,14),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context,14)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Vous n'avez pas de compte ?",
                              style: GoogleFonts.roboto(
                                fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context,14),
                                color: Colors.white,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegistreView()),
                                );
                              },
                              child: Text(
                                "Créer",
                                style: GoogleFonts.roboto(
                                  fontSize:
                                      constraints.maxWidth * AppSizes.converValueToadapter(context,14),
                                  fontWeight: FontWeight.bold,
                                  color:
                                      const Color.fromARGB(255, 255, 123, 0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
