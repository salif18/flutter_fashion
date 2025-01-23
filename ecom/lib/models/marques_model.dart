class MarquesModel {
  String? id; // Optionnel, pour inclure l'ID MongoDB (_id)
  String name;
  String image;
 
  MarquesModel({
    this.id,
    required this.name,
    required this.image,
   
  });

  // Factory pour désérialiser les données JSON
  factory MarquesModel.fromJson(Map<String, dynamic> json) {
    return MarquesModel(
      id: json['_id'], // MongoDB utilise "_id" pour l'identifiant
      name: json['name'],
      image: json['image'],
    );
  }

  // Méthode pour sérialiser en JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
    };
  }
}
