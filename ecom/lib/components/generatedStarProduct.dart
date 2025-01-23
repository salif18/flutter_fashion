import 'package:flutter/material.dart';

class GeneratedStarRating extends StatelessWidget {
  final double rating;

  const GeneratedStarRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    const int maxStars = 5;
    int starRating = (rating / 20).round(); // Diviser la note pour calculer correctement la valeur

    return Row(
      mainAxisSize: MainAxisSize.min, // Adapter la taille au contenu
      children: List.generate(
        maxStars,
        (index) => Icon(
          Icons.star, // Icône étoile
          color: index < starRating ? Colors.amber : Colors.grey, // Couleur selon la note
        ),
      ),
    );
  }
}
