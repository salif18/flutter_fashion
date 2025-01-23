// USER
class User {
  final String nom;
  final String numero;
  final String email;

  User({required this.nom, required this.numero, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nom: json["nom"] ?? "",
      numero: json["numero"] ?? "",
      email: json["email"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nom": nom, 
      "numero": numero, 
      "email": email
    };
  }
}

// ADDRESSE
class Address {
  final String ville;
  final String rue;
  final String logt;
  Address({required this.ville, required this.rue, required this.logt});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
        ville: json["ville"] ?? "", 
        rue: json["rue"] ?? "", 
        logt: json["logt"] ?? ""
      );
  }

  Map<String, dynamic> toJson() {
    return {
      "ville": ville, 
      "rue": rue, 
      "logt": logt
    };
  }
}

//LOCATION
class LocationModel {
  final double? lat; // Latitude
  final double? lng;

  LocationModel({required this.lat, required this.lng});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(lat: json["lat"], lng: json["lng"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "lat": lat, 
      "lng": lng
    };
  }
}

class OrderModel {
  final String id;
  final String userId;
  final User user;
  final Address address;
  final String payementMode;
  final String status;
  final List<CartItem> cart;
  final LocationModel? location;
  final int total;
  final DateTime date;

  OrderModel({
    required this.id,
    required this.userId,
    required this.user,
    required this.address,
    required this.payementMode,
    required this.status,
    required this.cart,
    required this.location,
    required this.total,
    required this.date,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json["_id"] ?? "",
      userId: json["userId"] ?? "",
      user:User.fromJson(json["user"]),
      address: Address.fromJson(json["address"]),
      payementMode: json["payementMode"],
      status: json["status"],
      cart: json["cart"] != null
        ? (json["cart"] as List).map((e) => CartItem.fromJson(e)).toList()
        : [], // Liste vide si cart est null
      location: json["location"] != null
          ? LocationModel.fromJson(json["location"])
          : null,
      total: json["total"],
      date: json["createdAt"] != null
        ? DateTime.parse(json["createdAt"])
        : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "userId": userId,
      "user": user.toJson(),
      "address": address.toJson(),
      "payementMode": payementMode,
      "status": status,
      "cart": cart.map((elemt) => elemt.toJson()).toList(),
      "location": location?.toJson(),
      "total": total,
      "createdAt": date.toIso8601String(),
    };
  }
}

class CartItem {
  final String producId;
  final String image;
  final String name;
  final int price;
  final bool promotion;
  final int qty;
  final String size;
  final String color;

  CartItem({
    required this.producId,
    required this.image,
    required this.name,
    required this.price,
    required this.promotion,
    required this.qty,
    required this.size,
    required this.color,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      producId:json["productId"] ?? "",
      image: json["image"] ?? "" ,
      name: json["name"] ?? "",
      price: json["price"],
      promotion: json["promotion"] ?? false,
      qty: json["qty"] ,
      size: json["size"] ?? "",
      color: json["color"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "productId": producId,
      "image": image,
      "name": name,
      "price": price,
      "promotion": promotion,
      "qty": qty,
      "size": size,
      "color": color,
    };
  }
}
