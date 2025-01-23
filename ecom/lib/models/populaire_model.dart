class PopulairesModel {
  final String id;
  final int totalQuantity;
  final String? produitId;
  final String? name;
  final String? image;
  final String? categorie;
  final String? sousCategorie;

  PopulairesModel(
      {required this.id,
      required this.totalQuantity,
      required this.produitId,
      required this.name,
      required this.image,
      required this.categorie,
      required this.sousCategorie});

  factory PopulairesModel.fromJson(Map<String, dynamic> json) {
    return PopulairesModel(
        id: json["_id"] ?? "",
        totalQuantity: json["totalQuantity"] ?? "",
        produitId: json["produitId"] ?? "",
        name: json["name"] ?? "",
        image: json["image"] ?? "",
        categorie: json["categorie"] ?? "",
        sousCategorie: json["sousCategorie"] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "totalQuantity": totalQuantity,
      "produitId": produitId,
      "name": name,
      "image": image,
      "categorie": categorie,
      "sousCategorie": sousCategorie
    };
  }
}
