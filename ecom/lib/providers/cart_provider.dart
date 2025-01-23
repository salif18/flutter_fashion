import 'package:ecom/models/produits_model.dart';
import 'package:flutter/material.dart';

// Modèle pour un produit dans le panier
class CartItem {
  final String id;
  final String name;
  final String img;
  final double price;
  final bool promotion;
  final String selectedSize;
  final String selectedColor;
  int qty;

  CartItem({
    required this.id,
    required this.name,
    required this.img,
    required this.price,
    required this.promotion,
    required this.selectedSize,
    required this.selectedColor,
    required this.qty,
  });
}

// Le Provider pour gérer le panier
class CartProvider with ChangeNotifier {
  List<CartItem> _cart = [];
  bool _isAdded = false;

  List<CartItem> get cart => _cart;
  bool get isAdded => _isAdded;

  // Ajouter un produit au panier
  void addToCart(ProductModel item,String mainImage, String size, String color) {
    final existingItemIndex = _cart.indexWhere((cartItem) =>
        cartItem.id == item.id &&
        cartItem.selectedSize == size &&
        cartItem.selectedColor == color);

    if (existingItemIndex != -1) {
      // Si l'article existe déjà, augmenter la quantité
      _cart[existingItemIndex].qty += 1;
    } else {
      // Sinon, ajouter un nouvel article
      _cart.add(CartItem(
        id: item.id!,
        name: item.name!,
        img: mainImage,
        price: item.isPromo ? item.price : item.price,
        promotion: item.isPromo,
        selectedSize: size,
        selectedColor: color,
        qty: 1,
      ));
    }

    _isAdded = true;
    notifyListeners();

    // Réinitialiser l'état de l'animation après une durée
    Future.delayed(const Duration(seconds: 1), () {
      _isAdded = false;
      notifyListeners();
    });
  }

  // Supprimer un produit du panier
  void removeFromCart(String id, String size, String color) {
    _cart.removeWhere((item) =>
        item.id == id &&
        item.selectedSize == size &&
        item.selectedColor == color);
    notifyListeners();
  }

  // Vider tout le panier
  void clearCart() {
    _cart = [];
    notifyListeners();
  }

  // Augmenter la quantité d'un produit
  void incrementQuantity(String id, String size, String color) {
    final existingItem = _cart.firstWhere(
        (item) =>
            item.id == id &&
            item.selectedSize == size &&
            item.selectedColor == color,
        orElse: () => throw Exception('Item not found'));
    existingItem.qty += 1;
    notifyListeners();
  }

  // Diminuer la quantité d'un produit
  void decrementQuantity(String id, String size, String color) {
    final existingItem = _cart.firstWhere(
        (item) =>
            item.id == id &&
            item.selectedSize == size &&
            item.selectedColor == color,
        orElse: () => throw Exception('Item not found'));
    if (existingItem.qty > 1) {
      existingItem.qty -= 1;
    } else {
      _cart.remove(existingItem);
    }
    notifyListeners();
  }

  // Calculer le total
  double get total {
    return _cart.fold(0.0, (sum, item) => sum + (item.price * item.qty));
  }

  // Calculer le nombre total d'articles
  int get nombreArticles {
    return _cart.fold(0, (count, item) => count + item.qty);
  }
}
