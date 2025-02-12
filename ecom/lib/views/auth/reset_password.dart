import 'dart:convert';

import 'package:ecom/services/auth_api.dart';
import 'package:ecom/utils/app_size.dart';
import 'package:ecom/views/auth/validation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ResetToken extends StatefulWidget {
  const ResetToken({super.key});

  @override
  State<ResetToken> createState() => _ResetTokenState();
}

class _ResetTokenState extends State<ResetToken> {
  ServicesAuth api = ServicesAuth();

final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
final _numero = TextEditingController();
final _email = TextEditingController();

@override 
void dispose(){
  _numero.dispose();
  _email.dispose();
  super.dispose();
}


// ENVOIE DES DONNEE VERS API SERVER
  Future<void> _sendToserver(BuildContext context) async {
  if (_globalKey.currentState!.validate()) {
    final data = {
      "numero": _numero.text,
      "email": _email.text,
    };
  
    try {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      final response = await api.postResetPassword(data);
      final body = json.decode(response.body);
      // ignore: use_build_context_synchronously
      Navigator.pop(context); // Fermer le dialog

      if (response.statusCode == 200) {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const ValidationReset()));

      } else {
        // ignore: use_build_context_synchronously
        api.showSnackBarErrorPersonalized(context, body["message"]);
        print(body["message"]);
      }
    } catch (e) {
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.grey[200],
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new_rounded, size:MediaQuery.of(context).size.width* AppSizes.iconLarge)),
      ),
      body: LayoutBuilder(
        builder: (context,constraints){
          return Container(
          padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context,10)),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context,10)),
              child: Form(
                key: _globalKey,
                child: Column(
                  children: [
                    _text(context,constraints),
                    _formNumberField(context,constraints),
                    _formEmailField(context,constraints),
                    SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context,100)),
                    _sendButton(context,constraints)
                  ],
                ),
              ),
            ),
          ),
        );
        }
       
      ),
    );
  }

  Widget _text(BuildContext context,constraints) {
    return Padding(
      padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context,10)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context,8)),
            child: Text("Réinitialiser le mot de passe",
                style: GoogleFonts.roboto(
                    fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context,14), fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding:  EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context,8)),
            child: Text(
                "Veuillez entrer les bonnes informations pour pouvoir nous aider à réinitialiser votre mot de passe",
                style: GoogleFonts.roboto(
                    fontSize:constraints.maxWidth * AppSizes.converValueToadapter(context,14), fontWeight: FontWeight.w300)),
          ),
        ],
      ),
    );
  }

  Widget _formNumberField(BuildContext context,constraints) {
    return Padding(
      padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context,8)),
      child: TextFormField(
        controller: _numero,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Veuillez entrer votre numero ';
          }
          return null;
        },
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
           isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * AppSizes.converValueToadapter(context,10) , vertical: constraints.maxWidth * AppSizes.converValueToadapter(context,15)),
          prefixIcon: Icon(Icons.phone_android_rounded, size:constraints.maxWidth * AppSizes.converValueToadapter(context,20)),
          filled: true,
          fillColor: Colors.grey[100],
          hintText: "Numéro",
          hintStyle:
              GoogleFonts.aBeeZee(fontSize:constraints.maxWidth * AppSizes.converValueToadapter(context,14), fontWeight: FontWeight.w500),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context,20))),
        ),
      ),
    );
  }

  Widget _formEmailField(BuildContext context,constraints) {
    return Padding(
      padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context,8)),
      child: TextFormField(
        controller: _email,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Veuillez entrer votre email';
          }
          return null;
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * AppSizes.converValueToadapter(context,10) , vertical: constraints.maxWidth * AppSizes.converValueToadapter(context,15)),
          prefixIcon: Icon(Icons.mail_outline, size:constraints.maxWidth * AppSizes.converValueToadapter(context,14)),
          filled: true,
          fillColor: Colors.grey[100],
          hintText: "Email",
          hintStyle:
              GoogleFonts.aBeeZee(fontSize:constraints.maxWidth * AppSizes.converValueToadapter(context,14), fontWeight: FontWeight.w500),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context,20))),
        ),
      ),
    );
  }

  Widget _sendButton(BuildContext context,constraints) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor:const Color.fromARGB(255, 255, 115, 0),
            minimumSize: Size(constraints.maxWidth * AppSizes.converValueToadapter(context,350), constraints.maxWidth * AppSizes.converValueToadapter(context,40))),
        onPressed: () {
          _sendToserver(context);
        },
        child: Text("Envoyer",
            style: GoogleFonts.aBeeZee(
                fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context,14),
                fontWeight: FontWeight.w500,
                color: Colors.white)));
  }
}
