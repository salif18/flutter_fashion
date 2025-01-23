class CartItemModel{
 final String productId;
 final String name;
 final String img;
  int qty;
  double prix;
  CartItemModel({
    required this.productId,
    required this.name,
    required this.img,
    required this.qty,
    required this.prix
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
     return CartItemModel(
      productId: json["productId"], 
      name: json['name'], 
      img: json['img'], 
      qty: json['qty'], 
      prix: json['prix']);
  }

  Map<String,dynamic> toJson(){
    return {
       "productId":productId.toString(),
       "name":name,
       "img":img,
       "qty":qty,
       "prix":prix
    };
  }

  
  @override
  String toString() {
    return 'CartItemModel(productId: $productId, name: $name, img: $img, qty: $qty, prix: $prix)';
  }
}