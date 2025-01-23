// import 'package:ecom/components/generatedStart.dart';
import 'package:ecom/models/produits_model.dart';
import 'package:ecom/utils/app_color.dart';
import 'package:ecom/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'dart:mirrors';

class ProductCard extends StatefulWidget {
  final ProductModel product;
  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late String mainImage;

  @override
  void initState() {
    super.initState();
    // Initialiser l'image principale avec une image par défaut
    mainImage = widget.product.image!;
  }

  // Fonction pour changer l'image principale
  void changeImage(String imgSrc) {
    setState(() {
      mainImage = imgSrc;
    });
  }

  // Color? parsedColor(String color) {
  //   try {
  //     return color.startsWith("#")
  //         ? Color(int.parse("0xFF${color.substring(1)}"))
  //         : Colors.primaries.firstWhere(
  //             (c) => c.toString().toLowerCase().contains(color.toLowerCase()),
  //             orElse: () => Colors.grey, // Couleur par défaut si non trouvée
  //           );
  //   } catch (e) {
  //     return Colors.grey; // Couleur par défaut en cas d'erreur
  //   }
  // }

//   Color? parsedColor(String color) {
//   try {
//     // Vérification si la couleur est au format hexadécimal
//     if (color.startsWith("#")) {
//       return Color(int.parse("0xFF${color.substring(1)}"));
//     }

//     // Utilisation de la réflexion pour mapper dynamiquement les couleurs nommées
//     final classMirror = reflectClass(Colors);
//     final namedColor = classMirror.staticMembers.entries.firstWhere(
//       (entry) => entry.key.toString().toLowerCase().contains(color.toLowerCase()),
//       orElse: () => null, // Si aucune correspondance n'est trouvée
//     );

//     if (namedColor != null) {
//       return classMirror.getField(namedColor.key).reflectee as Color?;
//     }

//     return Colors.grey; // Couleur par défaut si non trouvée
//   } catch (e) {
//     return Colors.grey; // Couleur par défaut en cas d'erreur
//   }
// }

Color? parsedColor(String color) {
  // Liste des couleurs nommées avec une Map
  Map<String, Color> colorMap = {
    "red": Colors.red,
    "green": Colors.green,
    "blue": Colors.blue,
    "yellow": Colors.yellow,
    "orange": Colors.orange,
    "purple": Colors.purple,
    "pink": Colors.pink,
    "white": Colors.white,
    "black": Colors.black,
    "grey": Colors.grey,
    "cyan": Colors.cyan,
    "teal": Colors.teal,
    "lime": Colors.lime,
    "amber": Colors.amber,
    "indigo": Colors.indigo,
    "brown": Colors.brown,
  };

  try {
    // Vérification si la couleur est au format hexadécimal
    if (color.startsWith("#")) {
      return Color(int.parse("0xFF${color.substring(1)}"));
    }

    // Recherche dans la Map
    return colorMap[color.toLowerCase()] ?? Colors.grey; // Gris par défaut si non trouvé
  } catch (e) {
    return Colors.grey; // Gris par défaut en cas d'erreur
  }
}

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.backgroundPrincal,
      ),
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width / 2.14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image principale du produit
          Container(
            width: MediaQuery.of(context).size.width,
            height: 150,
            // padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.productBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image(
              image: NetworkImage(mainImage),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 5),

          // Liste des couleurs disponibles
          SizedBox(
            height: 40,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              scrollDirection: Axis.horizontal,
              itemCount: widget.product.othersColors.length,
              itemBuilder: (context, index) {
                final colorChoice = widget.product.othersColors[index];
                // Vérifiez si le stock est insuffisant
                if (colorChoice.stock > 0) {
                  return GestureDetector(
                    onTap: () {
                      changeImage(colorChoice.images ?? "");
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: parsedColor(colorChoice.color ?? ""),
                         border: Border.all(
                                        color: Colors
                                            .grey),
                        shape:
                            BoxShape.rectangle, // Rectangle pour le conteneur
                      ),
                      width: 25,
                      height: 20,
                    ),
                  );
                } else {
                  return const SizedBox.shrink(); // Retourne un widget vide
                }
              },
            ),
          ),

          const SizedBox(height: 5),

          // Nom du produit
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    widget.product.name!,
                    style: GoogleFonts.roboto(
                      fontSize: MediaQuery.of(context).size.width *
                          AppSizes.fontSmall,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
            ],
          ),

          // Catégorie et sous-catégorie
          // Text(
          //   widget.product.category!,
          //   style: GoogleFonts.roboto(
          //     fontSize: MediaQuery.of(context).size.width * AppSizes.fontSmall,
          //     fontWeight: FontWeight.w300,
          //     color: AppColors.textColor,
          //   ),
          //   maxLines: 2,
          //   overflow: TextOverflow.ellipsis,
          // ),
          // const SizedBox(height: 2),
          // Text(
          //   widget.product.subCategory!,
          //   style: GoogleFonts.roboto(
          //     fontSize: MediaQuery.of(context).size.width * AppSizes.fontSmall,
          //     fontWeight: FontWeight.w300,
          //     color: AppColors.textColor,
          //   ),
          //   maxLines: 2,
          //   overflow: TextOverflow.ellipsis,
          // ),

          // const SizedBox(height: 2),

          // Prix
          Text(
            "${widget.product.price.toStringAsFixed(2)} FCFA",
            style: GoogleFonts.roboto(
              fontSize: MediaQuery.of(context).size.width * AppSizes.fontSmall,
              color: AppColors.textColor,
            ),
          ),

          const SizedBox(height: 3),

          // Évaluation (rating)
          // GeneratedStarRating(rating: widget.product.rating!),
        ],
      ),
    );
  }
}
