/// Modèle pour représenter une catégorie avec une image associée.
class CategoryModel {
  /// Le nom de la catégorie.
  String? category;

  /// L'URL ou le chemin de l'image associée à la catégorie.
  String? image;

  /// Constructeur par défaut.
  CategoryModel({this.category, this.image});

  /// Crée une instance de `CategoryModel` à partir d'une structure JSON.
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      category: json["category"] ?? "", // Utilisation d'une valeur par défaut si null.
      image: json["image"] ?? "",
    );
  }

  /// Convertit une instance de `CategoryModel` en structure JSON.
  Map<String, dynamic> toJson() {
    return {
      "category": category ?? "", // S'assure que les champs ne sont pas nulls.
      "image": image ?? "",
    };
  }
}
