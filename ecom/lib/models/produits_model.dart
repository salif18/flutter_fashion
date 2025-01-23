

class SizeModel {
  String? id;
  String? size;
  int stock;

  SizeModel({this.id,this.size, this.stock = 0});

  factory SizeModel.fromJson(Map<String, dynamic> json) {
    return SizeModel(
      id:json["id"],
      size: json['size'] ?? "",
      stock: json['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id":id,
      'size': size,
      'stock': stock,
    };
  }
}

class ColorModel {
  String? id;
  String? color;
  String? images;
  int stock;
  List<SizeModel> sizes;

  ColorModel({
    this.id,
    this.color,
    this.images,
    this.stock = 0,
    this.sizes = const [],
  });

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      id:json["_id"],
      color: json['color'],
      images: json['images'],
      stock: json['stock'] ?? 0,
      sizes: (json['sizes'] as List<dynamic>?)
              ?.map((e) => SizeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id":id,
      'color': color,
      'images': images,
      'stock': stock,
      'sizes': sizes.map((e) => e.toJson()).toList(),
    };
  }
}

class CommentModel {
  String? id;
  String? userId;
  String? name;
  double? rating;
  String? avis;
  DateTime? date;

  CommentModel({
    this.id,
    this.userId,
    this.name,
    this.rating,
    this.avis,
    this.date,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id:json["_id"],
      userId: json['userId'],
      name: json['name'],
      rating: (json['rating'] as num?)?.toDouble(),
      avis: json['avis'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id":id,
      'userId': userId,
      'name': name,
      'rating': rating,
      'avis': avis,
      'date': date?.toIso8601String(),
    };
  }
}

class ProductModel {
  String? id;
  String? name;
  String? category;
  String? subCategory;
  String? brand;
  double? rating;
  List<CommentModel> commentaires;
  String? description;
  double price;
  bool isPromo;
  double? promoPrice;
  double? discountPercentage;
  int stockGlobal;
  List<ColorModel> othersColors;
  String? image;

  ProductModel({
    this.id,
    this.name,
    this.category,
    this.subCategory,
    this.brand,
    this.rating = 0.0,
    this.commentaires = const [],
    this.description,
    required this.price,
    this.isPromo = false,
    this.promoPrice,
    this.discountPercentage,
    required this.stockGlobal,
    this.othersColors = const [],
     this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id:json["_id"],
      name: json['name'],
      category: json['category'],
      subCategory: json['subCategory'],
      brand: json['brand'],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      commentaires: (json['commentaires'] as List<dynamic>?)
              ?.map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      isPromo: json['is_promo'] ?? false,
      promoPrice: (json['promo_price'] as num?)?.toDouble(),
      discountPercentage: (json['discount_percentage'] as num?)?.toDouble(),
      stockGlobal: json['stockGlobal'] ?? 0,
      othersColors: (json['othersColors'] as List<dynamic>?)
              ?.map((e) => ColorModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
          image:json["image"]
      // image:completeImageUrl(json["image"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id":id,
      'name': name,
      'category': category,
      'subCategory': subCategory,
      'brand': brand,
      'rating': rating,
      'commentaires': commentaires.map((e) => e.toJson()).toList(),
      'description': description,
      'price': price,
      'is_promo': isPromo,
      'promo_price': promoPrice,
      'discount_percentage': discountPercentage,
      'stockGlobal': stockGlobal,
      'othersColors': othersColors.map((e) => e.toJson()).toList(),
      'image':image,
    };
  }

  containsKey(String s) {}

  // static String completeImageUrl(String imgPath) {
  //   String baseUrl = BackendApi.imageHttps;
  //   return imgPath.startsWith("https") ? imgPath : baseUrl + imgPath;
  // }
}
