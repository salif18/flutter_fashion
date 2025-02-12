import 'package:ecom/utils/app_size.dart';
import 'package:ecom/views/store/stores.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoriteEmpty extends StatelessWidget {
  final constraints;
  const FavoriteEmpty({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
      height: constraints.maxWidth * AppSizes.converValueToadapter(context, 360),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
            child: Text(
              "Aucuns favoris",
              style: GoogleFonts.roboto(fontSize:constraints.maxWidth * AppSizes.converValueToadapter(context, 14), color: Colors.grey),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
            child: Icon(Icons.favorite_border_sharp, size: constraints.maxWidth * AppSizes.converValueToadapter(context, 60)),
          ),
          Padding(
            padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
            child: Text("Ajouter des articles dans vos favoris",
                style: GoogleFonts.roboto(
                    fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 14), color: const Color(0xFF1D1A30))),
          ),
          Padding(
            padding: EdgeInsets.only(left: constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
            child: Text(
                "Regrouper ici les articles qui vous interressent et envoyer-les a l'entreprise",
                style: GoogleFonts.roboto(fontSize:constraints.maxWidth * AppSizes.converValueToadapter(context, 14), color: Colors.grey)),
          ),
          Padding(
            padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 25)),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StoresView(categoSelected: "",)));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    minimumSize: Size(constraints.maxWidth * AppSizes.converValueToadapter(context, 400), constraints.maxWidth * AppSizes.converValueToadapter(context, 40))),
                child: Text("Voir les articles",
                    style:
                        GoogleFonts.roboto(fontSize:constraints.maxWidth * AppSizes.converValueToadapter(context, 14), color: Colors.white))),
          )
        ],
      ),
    );
  }
}