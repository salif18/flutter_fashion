// import 'package:ecom/components/generatedStart.dart';
import 'package:ecom/components/generatedStarProduct.dart';
import 'package:ecom/models/produits_model.dart';
import 'package:ecom/utils/app_color.dart';
import 'package:ecom/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'dart:mirrors';

class ProductCard extends StatefulWidget {
  final ProductModel product;
  final constraints;
  const ProductCard(
      {super.key, required this.product, required this.constraints});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late String mainImage;

  @override
  void initState() {
    super.initState();
    // Initialiser l'image principale avec une image par défaut
    mainImage = widget.product.image ?? "assets/images/default.jpg";
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
      return colorMap[color.toLowerCase()] ??
          Colors.grey; // Gris par défaut si non trouvé
    } catch (e) {
      return Colors.grey; // Gris par défaut en cas d'erreur
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          widget.constraints.maxWidth *
              AppSizes.converValueToadapter(context, 10),
        ),
        // border: Border.all(
        //   width: 0.09
        // ),
        // color: Colors.grey[100]
      ),
      margin: EdgeInsets.all(widget.constraints.maxWidth *
          AppSizes.converValueToadapter(context, 4)),
      padding: EdgeInsets.all(
        widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 0),
      ),
      width: widget.constraints.maxWidth / 2.14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image principale du produit
          Container(
            width: widget.constraints.maxWidth,
            height: widget.constraints.maxWidth *
                AppSizes.converValueToadapter(context, 150),
             padding: EdgeInsets.all(
                          widget.constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 5),
                            ),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(
                widget.constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 10),
              ),
            ),
            child: Image(
              image: mainImage != null && mainImage.isNotEmpty
                  ? NetworkImage(mainImage) as ImageProvider
                  : const AssetImage("assets/images/default.jpg"),
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            height: widget.constraints.maxWidth *
                AppSizes.converValueToadapter(context, 5),
          ),

          // Liste des couleurs disponibles
          Expanded(
            // flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(
                //   height: widget.constraints.maxWidth *
                //       AppSizes.converValueToadapter(context, 20),
                //   child: ListView.builder(
                //     padding: const EdgeInsets.symmetric(horizontal: 0),
                //     scrollDirection: Axis.horizontal,
                //     itemCount: widget.product.othersColors.length,
                //     itemBuilder: (context, index) {
                //       final colorChoice = widget.product.othersColors[index];
                //       // Vérifiez si le stock est insuffisant
                //       if (colorChoice.stock > 0) {
                //         return GestureDetector(
                //           onTap: () {
                //             changeImage(colorChoice.images ?? "");
                //           },
                //           child: Container(
                //             margin: EdgeInsets.only(
                //               right: widget.constraints.maxWidth *
                //                   AppSizes.converValueToadapter(context, 8),
                //             ),
                //             decoration: BoxDecoration(
                //               color: parsedColor(colorChoice.color ?? ""),
                //               border: Border.all(color: Colors.grey),
                //               shape: BoxShape
                //                   .rectangle, // Rectangle pour le conteneur
                //             ),
                //             width: widget.constraints.maxWidth *
                //                 AppSizes.converValueToadapter(context, 20),
                //             height: widget.constraints.maxWidth *
                //                 AppSizes.converValueToadapter(context, 20),
                //           ),
                //         );
                //       } else {
                //         return const SizedBox
                //             .shrink(); // Retourne un widget vide
                //       }
                //     },
                //   ),
                // ),
                SizedBox(
                    height: widget.constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 1)),

                // Nom du produit
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 5),
                            vertical: widget.constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 2),),
                        child: Text(
                          widget.product.name ?? "",
                          style: GoogleFonts.roboto(
                            fontSize: widget.constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 12),
                           
                            color: AppColors.textColor,
                          ),
                          // softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          // maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                ),

                // Prix
                Container(
                  padding: EdgeInsets.symmetric( horizontal: widget.constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 5),),
                  child: Text(
                    "${widget.product.price.toStringAsFixed(2)} FCFA",
                    style: GoogleFonts.roboto(
                      fontSize: widget.constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 14),
                           fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                ),
                SizedBox(
                    height: widget.constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 3)),
                // Évaluation (rating)
                Container(
                    padding: EdgeInsets.symmetric( horizontal: widget.constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 5),),
                  child: GeneratedStarRating(rating: widget.product.rating ?? 0,constraints:widget.constraints)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
