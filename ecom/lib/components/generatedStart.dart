import 'package:ecom/utils/app_size.dart';
import 'package:flutter/material.dart';

class GeneratedStarUserRating extends StatelessWidget {
  final int rating;
  final constraints;
  GeneratedStarUserRating({super.key, required this.rating, required this.constraints});
   
    List<Widget> buildStars(BuildContext context) {
    int starCount = rating.round(); // Arrondir la note à l'entier le plus proche
    const int maxStars = 5;

    return List.generate(
      maxStars,
      (index) => Icon(
        Icons.star_rate_sharp,
        color: index < starCount ? Colors.amber : Colors.grey, 
        size: constraints.maxWidth * AppSizes.converValueToadapter(context, 16),// Remplir ou non l'étoile
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Ajuster la taille au contenu
      children: buildStars(context),
    );
  }
}