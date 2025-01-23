import 'package:ecom/utils/app_size.dart';
import 'package:ecom/views/store/stores.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoriteEmpty extends StatelessWidget {
  const FavoriteEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Aucuns favoris",
              style: GoogleFonts.roboto(fontSize:MediaQuery.of(context).size.width * AppSizes.fontMedium, color: Colors.grey),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(15),
            child: Icon(Icons.favorite_border_sharp, size: 60),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Ajouter des articles dans vos favoris",
                style: GoogleFonts.roboto(
                    fontSize: MediaQuery.of(context).size.width *AppSizes.fontSmall, color: const Color(0xFF1D1A30))),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
                "Regrouper ici les articles qui vous interressent et envoyer-les a l'entreprise",
                style: GoogleFonts.roboto(fontSize:MediaQuery.of(context).size.width * AppSizes.fontSmall, color: Colors.grey)),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StoresView(categoSelected: "",)));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D1A30),
                    minimumSize: const Size(400, 50)),
                child: Text("Voir les articles",
                    style:
                        GoogleFonts.roboto(fontSize:MediaQuery.of(context).size.width * AppSizes.fontSmall, color: Colors.white))),
          )
        ],
      ),
    );
  }
}