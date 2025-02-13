// ignore: depend_on_referenced_packages
import 'dart:async';
import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:ecom/components/generatedStarProduct.dart';
import 'package:ecom/components/generatedStart.dart';
import 'package:ecom/models/produits_model.dart';
import 'package:ecom/providers/auth_provider.dart';
import 'package:ecom/providers/cart_provider.dart';
import 'package:ecom/providers/favorite_provider.dart';
import 'package:ecom/services/products_api.dart';
import 'package:ecom/utils/app_color.dart';
import 'package:ecom/utils/app_size.dart';
import 'package:ecom/views/cart/cart.dart';
import 'package:ecom/views/detail/widgets/sliver_persistant_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class SingleProduct extends StatefulWidget {
  final ProductModel product;
  const SingleProduct({super.key, required this.product});

  @override
  State<SingleProduct> createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  int qty = 1;

  ServicesAPiProducts api = ServicesAPiProducts();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  Future<List<ProductModel>> fetchProductData() async {
    final res = await api.getSingleProducts(widget.product.id);
    final body = res.data;
    try {
      if (res.statusCode == 200) {
        return (body["recommandations"] as List)
            .map((json) => ProductModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to load products ");
      }
    } on DioException {
      api.showSnackBarErrorPersonalized(
          context, "Problème de connexion : Vérifiez votre Internet.");
      print("Erreur de connexion : Impossible d'accéder au serveur.");
    } on TimeoutException {
      api.showSnackBarErrorPersonalized(
          context, "Le serveur ne répond pas. Veuillez réessayer plus tard.");
      print("Erreur : Temps d'attente dépassé.");
    }
    return [];
  }

  late String mainImage;
  late String? selectedColor;
  late String? selectedSize;
  int selectedColorIndex = 0;

  // Fonction pour changer l'image principale
  void changeImage(String imgSrc) {
    setState(() {
      mainImage = imgSrc;
    });
  }

  void selectColor(int index, colorOption) {
    setState(() {
      selectedColorIndex = index;
      selectedColor = colorOption.color;
      mainImage = colorOption.images;
    });
  }

  @override
  void initState() {
    super.initState();
    // initialiser les valeur par default
    mainImage = widget.product.image!;
    selectedSize = "";
    selectedColor = "";
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

  int rating = 0; // Note sélectionnée par l'utilisateur

  void handleRating(int value) {
    setState(() {
      rating = value; // Met à jour la note sélectionnée
    });
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<AuthProvider>(context, listen: false);
      final userId = provider.userId;

      final avis = {
        "userId": userId,
        "user": _userNameController.text,
        "rating": rating,
        "commentaires": _commentController.text,
      };

      try {
        final response = await api.postCommit(widget.product.id, avis);
        final body = jsonDecode(response.body);
        if (response.statusCode == 200) {
          if (!mounted) return;
          Navigator.pop(context);
          api.showSnackBarSuccessPersonalized(context, body["message"]);
        } else {
          if (!mounted) return;
          api.showSnackBarErrorPersonalized(context, body["message"]);
        }
      } catch (e) {
        Exception(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    void Function(
            ProductModel item, String mainImage, String size, String color)
        addToCart = cartProvider.addToCart;

    ColorModel? currentColor = widget.product.othersColors.isNotEmpty &&
            selectedColorIndex < widget.product.othersColors.length
        ? widget.product.othersColors[selectedColorIndex]
        : null;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrincal,
      body: LayoutBuilder(builder: (context, constraints) {
        return CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: MySliverPersistentHeaderDelegate(
                maxHeight: constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 360),
                minHeight: constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 30),
                mainImage: mainImage,
                constraints:constraints
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              _overProductImage(context, constraints),
              _headerDescription(context, constraints),
              _productDescription(context, constraints),
              // Colors
              if (widget.product.othersColors.isNotEmpty)
                _colorOptions(context, constraints, currentColor),
              _diviser(context, constraints),
              // _actionsButtons(context, addToCart),
            ])),
            SliverFillRemaining(
              // hasScrollBody: true, // Empêche les débordements
              fillOverscroll: true,
              child: DefaultTabController(
                  length: 3,
                  child: Column(
                     mainAxisSize: MainAxisSize.min, // Évite le débordement
                    children: [
                      SizedBox(
                        height: constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 10),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 16),
                            right: constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 16)),
                        child: Material(
                          color: AppColors.productBackground,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(1),
                                  right: Radius.circular(1))),
                          child: TabBar(
                            indicator: BoxDecoration(
                                color: AppColors.colorBtnSecondary,
                                borderRadius: BorderRadius.circular(1)),
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelColor:
                                const Color.fromARGB(255, 253, 253, 253),
                            unselectedLabelColor:
                                const Color.fromARGB(255, 48, 33, 58),
                            tabs: [
                              Tab(
                                child: Text(
                                  "Voir aussi",
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w600,
                                      fontSize: constraints.maxWidth *
                                          AppSizes.converValueToadapter(
                                              context, 14)),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  "Notez",
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w600,
                                      fontSize: constraints.maxWidth *
                                          AppSizes.converValueToadapter(
                                              context, 14)),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  "Les avis",
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w600,
                                      fontSize: constraints.maxWidth *
                                          AppSizes.converValueToadapter(
                                              context, 14)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                   Expanded( // Permet au contenu de prendre toute la place disponible
                            child: SingleChildScrollView( // Ajouté pour éviter le bug d'affichage
                              child: SizedBox(
                                height: constraints.maxHeight, // Prend toute la hauteur dispo
                                child: TabBarView(
                                  children: [
                  _productRelated(context, constraints),
                  _notation(context, constraints),
                  _avis(context, constraints),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    ],
                  )),
            )
          ],
        );
      }),
      bottomNavigationBar: _actionsButtons(context, addToCart),
    );
  }

// LES AUTRE IMAGES DU PRODUIT
  Widget _overProductImage(BuildContext context, constraints) {
    return Container(
      height:
          constraints.maxWidth * AppSizes.converValueToadapter(context, 100),
      padding: EdgeInsets.symmetric(
          vertical: constraints.maxWidth *
              AppSizes.converValueToadapter(context, 10)),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth *
                AppSizes.converValueToadapter(context, 20)),
        scrollDirection: Axis.horizontal,
        itemCount: widget.product.othersColors.length,
        itemBuilder: (context, index) {
          final colorChoise = widget.product.othersColors[index];
          return GestureDetector(
            onTap: () =>
                changeImage(widget.product.othersColors[index].images ?? ""),
            child: Container(
              margin: EdgeInsets.all(constraints.maxWidth *
                  AppSizes.converValueToadapter(context, 8)),
              decoration: BoxDecoration(
                border: Border.all(
                  width: mainImage == colorChoise.images ? 3 : 0,
                  style: BorderStyle.solid,
                  color: mainImage == colorChoise.images
                      ? Colors.blue
                      : Colors.grey,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              width: constraints.maxWidth *
                  AppSizes.converValueToadapter(context, 60),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    widget.product.othersColors[index].images ?? "",
                    // Laisse une chaîne vide si l'URL est null
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset("assets/images/default.jpg",
                          fit: BoxFit.contain);
                    },
                  )),
            ),
          );
        },
      ),
    );
  }

//LE HEADER
  Widget _headerDescription(BuildContext context, constraints) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal:
              constraints.maxWidth * AppSizes.converValueToadapter(context, 20),
          vertical:
              constraints.maxWidth * AppSizes.converValueToadapter(context, 5)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(width:  constraints.maxWidth*AppSizes.converValueToadapter(context, 15)),
          Expanded(
            child: Consumer<FavoriteProvider>(
              builder: (context, favoriteProvider, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name ?? "",
                            style: GoogleFonts.roboto(
                              fontSize: constraints.maxWidth *
                                  AppSizes.converValueToadapter(context, 14),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            widget.product.subCategory ?? "",
                            style: GoogleFonts.roboto(
                                fontSize: constraints.maxWidth *
                                    AppSizes.converValueToadapter(context, 14),
                                color: Colors.grey),
                          ),
                          Row(
                            children: [
                              Text(
                                widget.product.price.toString(),
                                style: GoogleFonts.roboto(
                                  fontSize: constraints.maxWidth *
                                      AppSizes.converValueToadapter(
                                          context, 14),
                                  decoration: widget.product.isPromo
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                              // Évaluation (rating)
                              if (widget.product.isPromo)
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: constraints.maxWidth *
                                          AppSizes.converValueToadapter(
                                              context, 8)),
                                  child: Text(
                                    "${widget.product.promoPrice!} FCFA",
                                    style: GoogleFonts.roboto(
                                        fontSize: constraints.maxWidth *
                                            AppSizes.converValueToadapter(
                                                context, 14),
                                        color: AppColors.colorBtnSecondary),
                                  ),
                                ),
                            ],
                          ),
                          GeneratedStarRating(
                              rating: widget.product.rating ?? 0),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

// DESCRIPTION DU PRODUIT
  Widget _productDescription(BuildContext context, constraints) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
          horizontal: constraints.maxWidth *
              AppSizes.converValueToadapter(context, 20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
                vertical: constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 10)),
            width: constraints.maxWidth / 2,
            height: constraints.maxWidth *
                AppSizes.converValueToadapter(context, 40),
            padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 16)),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: AppColors.colorBtnPrimary,
                borderRadius: BorderRadius.circular(constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 10))),
            child: Text(
              "Description", // Affiche "N/A" si size est null
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                  fontSize: constraints.maxWidth *
                      AppSizes.converValueToadapter(context, 14),
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          ReadMoreText(
            widget.product.description ?? "",
            trimLines: 2,
            colorClickableText: AppColors.colorBtnSecondary,
            trimMode: TrimMode.Line,
            trimCollapsedText: 'Voir plus',
            trimExpandedText: ' réduire',
            style: TextStyle(
              // ignore: deprecated_member_use
              color: AppColors.textColor.withOpacity(0.7),
              height: constraints.maxWidth *
                  AppSizes.converValueToadapter(context, 1.5),
            ),
          ),
          SizedBox(
              height: constraints.maxWidth *
                  AppSizes.converValueToadapter(context, 8)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Catégorie", // Affiche "N/A" si size est null
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                    fontSize: constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 14),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                  width: constraints.maxWidth *
                      AppSizes.converValueToadapter(context, 10)),
              Text(
                widget.product.category ??
                    "N/A", // Affiche "N/A" si size est null
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                    fontSize: constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 14),
                    color: AppColors.colorBtnSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

// OPTIONS COULEUR
  Widget _colorOptions(
      BuildContext context, constraints, ColorModel? currentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth *
                  AppSizes.converValueToadapter(context, 20),
              vertical: constraints.maxWidth *
                  AppSizes.converValueToadapter(context, 10)),
          child: Text(
            "Couleurs disponibles",
            style: GoogleFonts.roboto(
                fontSize: constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 14),
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height:
              constraints.maxWidth * AppSizes.converValueToadapter(context, 40),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 10)),
            scrollDirection: Axis.horizontal,
            itemCount: widget.product.othersColors.length,
            itemBuilder: (context, index) {
              final color = widget.product.othersColors[index];

              // Vérifiez si le stock est insuffisant
              if (color.stock > 0) {
                return GestureDetector(
                  onTap: () {
                    // Actions sur clic : changement d'image et sélection de la couleur
                    changeImage(color.images ?? "");
                    selectColor(index, color);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 4)),
                    decoration: BoxDecoration(
                      color: parsedColor(color.color ?? ""),
                      shape: BoxShape.circle, // Forme ronde
                      border: Border.all(
                        color: selectedColor == color.color
                            ? const Color.fromARGB(255, 12, 56, 92)
                            : Colors.grey,
                        width: mainImage == color.images
                            ? 3
                            : 1, // Largeur de la bordure
                      ),
                    ),
                    width: constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 35),
                    height: constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 40),
                  ),
                );
              } else {
                return const SizedBox.shrink(); // Retourne un widget vide
              }
            },
          ),
        ),
        SizedBox(
            height: constraints.maxWidth *
                AppSizes.converValueToadapter(context, 10)),
        if ((widget.product.category == "Vêtements" ||
                widget.product.category == "Chaussures") &&
            currentColor != null &&
            currentColor.sizes.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 14)),
                  child: Text(
                    "Tailles disponibles",
                    style: GoogleFonts.roboto(
                        fontSize: constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 14),
                        fontWeight: FontWeight.bold),
                  )),
              Padding(
                padding: EdgeInsets.all(constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 8)),
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxWidth *
                      AppSizes.converValueToadapter(context, 50),
                  child: Row(
                    children: [
                      Expanded(
                        // Permet à ListView.builder de prendre l'espace disponible
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: currentColor.sizes.length,
                          itemBuilder: (context, index) {
                            final sizeOption = currentColor.sizes[index];
                            // Vérifiez si le stock est insuffisant
                            if (sizeOption.stock > 0) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedSize = sizeOption.size;
                                  });
                                },
                                child: Container(
                                  width: constraints.maxWidth *
                                      AppSizes.converValueToadapter(
                                          context, 50),
                                  height: constraints.maxWidth *
                                      AppSizes.converValueToadapter(
                                          context, 40),
                                  margin: EdgeInsets.all(constraints.maxWidth *
                                      AppSizes.converValueToadapter(
                                          context, 10)),
                                  alignment: Alignment
                                      .center, // Centre le texte dans le conteneur
                                  decoration: BoxDecoration(
                                    color: selectedSize == sizeOption.size
                                        ? Colors.black
                                        : const Color(0xFFF1F1F1),
                                    border: Border.all(
                                        color: Colors
                                            .grey), // Ajout de style optionnel
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    sizeOption.size ??
                                        "N/A", // Affiche "N/A" si size est null
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                      fontSize: constraints.maxWidth *
                                          AppSizes.converValueToadapter(
                                              context, 14),
                                      color: selectedSize == sizeOption.size
                                          ? Colors.white
                                          : null,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox
                                  .shrink(); // Retourne un widget vide
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
      ],
    );
  }

  Widget _diviser(BuildContext context, constraints) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal:
              constraints.maxWidth * AppSizes.converValueToadapter(context, 25),
          vertical: constraints.maxWidth *
              AppSizes.converValueToadapter(context, 10)),
      child: Divider(
        height:
            constraints.maxWidth * AppSizes.converValueToadapter(context, 3),
        color: Colors.grey[200],
        indent: 1,
      ),
    );
  }

  Widget _actionsButtons(
      BuildContext context,
      void Function(
              ProductModel item, String mainImage, String size, String color)
          addToCart) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxWidth *
              AppSizes.converValueToadapter(context, 100),
          width: constraints.maxWidth,
          padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth *
                  AppSizes.converValueToadapter(context, 5),
              vertical: constraints.maxWidth *
                  AppSizes.converValueToadapter(context, 10)),
          color: AppColors.backgroundPrincal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 40),
                height: constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 40),
                decoration: BoxDecoration(
                    color: AppColors.productBackground,
                    borderRadius: BorderRadius.circular(constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 10))),
                child: Consumer<CartProvider>(
                  builder: (context, provider, child) {
                    return Stack(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CartView())),
                          icon: Icon(Icons.shopping_cart_outlined,
                              color: Colors.black,
                              size: constraints.maxWidth *
                                  AppSizes.converValueToadapter(context, 25)),
                        ),
                        if (provider.cart.isNotEmpty)
                          Positioned(
                            left: constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 20),
                            bottom: constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 20),
                            child: Badge.count(
                              count: provider.nombreArticles,
                              largeSize: constraints.maxWidth *
                                  AppSizes.converValueToadapter(context, 35) /
                                  2,
                              backgroundColor: Colors.deepOrange,
                              textStyle: GoogleFonts.roboto(
                                fontSize: constraints.maxWidth *
                                    AppSizes.converValueToadapter(context, 12),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                  width: constraints.maxWidth *
                      AppSizes.converValueToadapter(context, 10)),
              Container(
                width: constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 40),
                height: constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 40),
                decoration: BoxDecoration(
                    color: AppColors.productBackground,
                    borderRadius: BorderRadius.circular(constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 10))),
                child: Consumer<FavoriteProvider>(
                    builder: (context, favoriteProvider, child) {
                  List<ProductModel> favorites = favoriteProvider.getFavorites;
                  return SizedBox(
                    child: IconButton(
                      onPressed: () {
                        favoriteProvider.addMyFavorites(widget.product);
                      },
                      icon: favorites.firstWhereOrNull(
                                  (item) => item.id == widget.product.id) ==
                              null
                          ? Icon(
                              Icons.favorite_border,
                              size: constraints.maxWidth *
                                  AppSizes.converValueToadapter(context, 24),
                              color: const Color(0xff2c3e50),
                            )
                          : Icon(
                              Icons.favorite,
                              size: constraints.maxWidth *
                                  AppSizes.converValueToadapter(context, 24),
                              color: Colors.red,
                            ),
                    ),
                  );
                }),
              ),
              SizedBox(
                  width: constraints.maxWidth *
                      AppSizes.converValueToadapter(context, 10)),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 10)),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(
                        constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 200),
                        constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 40)),
                    backgroundColor: AppColors.banerBtnNavigatorBackground,
                  ),
                  onPressed: () {
                    // Vérifier la catégorie du produit et valider les sélections
                    if (widget.product.category == "Vêtements" ||
                        widget.product.category == "Chaussures") {
                      if (selectedColor == "" || selectedSize == "") {
                        // Afficher une alerte si la couleur ou la taille n'est pas sélectionnée
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Veuillez choisir votre couleur et votre taille avant d'ajouter au panier."),
                            duration: const Duration(seconds: 3),
                            backgroundColor: Colors.deepOrange,
                            action: SnackBarAction(
                              label: "",
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                              },
                            ),
                          ),
                        );
                        return;
                      }
                    } else if (widget.product.category == "Accessoires" ||
                        widget.product.category == "Sacs") {
                      if (selectedColor == "") {
                        // Afficher une alerte si la couleur n'est pas sélectionnée
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Veuillez choisir votre couleur avant d'ajouter au panier."),
                          duration: const Duration(seconds: 3),
                          backgroundColor: Colors.deepOrange,
                          action: SnackBarAction(
                            label: "",
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                            },
                          ),
                        ));
                        return;
                      }
                    }

                    // Ajouter au panier si toutes les validations sont passées
                    addToCart(widget.product, mainImage, selectedSize ?? "",
                        selectedColor ?? "");
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Ajouté au panier !",
                        style: GoogleFonts.roboto(
                            fontSize: constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 14)),
                      ),
                      // backgroundColor: const Color.fromARGB(255, 255, 35, 19),
                      duration: const Duration(seconds: 1),
                      backgroundColor: const Color.fromARGB(255, 5, 151, 10),
                      action: SnackBarAction(
                        label: "",
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),
                    ));
                  },
                  icon: Icon(Icons.add_shopping_cart,
                      color: Colors.white,
                      size: constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 20)),
                  label: Text(
                    "Ajouter au panier",
                    style: GoogleFonts.roboto(
                      fontSize: constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 14),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // product relatife
  Widget _productRelated(BuildContext context, constraints) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 16),
                    vertical: constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 10)),
                child: Text(
                  'Vous aimerez aussi ',
                  style: GoogleFonts.roboto(
                      fontSize: constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 14),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 16)),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: constraints.maxWidth *
                      AppSizes.converValueToadapter(context, 14),
                ),
              )
            ],
          ),
          FutureBuilder<List<ProductModel>?>(
              future: fetchProductData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "Une erreur s'est produit lors du chargement",
                    style: GoogleFonts.roboto(
                      fontSize: constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 14),
                    ),
                  ));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text(
                    "Aucuns données disponibles",
                    style: GoogleFonts.roboto(
                      fontSize: constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 14),
                    ),
                  ));
                } else {
                  final products = snapshot.data!;
                  return Expanded(
                    child: GridView.builder(
                      physics: ScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 0.1,
                        mainAxisSpacing: 1,
                        childAspectRatio: 0.66,
                      ),
                      itemCount: products.length,
                      itemBuilder: (BuildContext context, int index) {
                        final product = products[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SingleProduct(product: product)));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                // color: AppColors.productBackground,
                                borderRadius: BorderRadius.circular(
                                    constraints.maxWidth *
                                        AppSizes.converValueToadapter(
                                            context, 15))),
                            margin: EdgeInsets.all(constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 5)),
                            padding: EdgeInsets.all(constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 10)),
                            width: constraints.maxWidth / 2.14,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: constraints.maxWidth,
                                  height: constraints.maxWidth *
                                      AppSizes.converValueToadapter(
                                          context, 120),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Image(
                                    image: product.image != null &&
                                            product.image!.isNotEmpty
                                        ? NetworkImage(product.image!)
                                            as ImageProvider
                                        : const AssetImage(
                                            "assets/images/default.jpg"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: constraints.maxWidth *
                                                AppSizes.converValueToadapter(
                                                    context, 10)),
                                        child: Text(
                                          product.name ?? "",
                                          style: GoogleFonts.roboto(
                                              fontSize: constraints.maxWidth *
                                                  AppSizes.converValueToadapter(
                                                      context, 14),
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textColor),
                                          // softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          // maxLines: 2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  product.category ?? "",
                                  style: GoogleFonts.roboto(
                                    fontSize: constraints.maxWidth *
                                        AppSizes.converValueToadapter(
                                            context, 14),
                                    fontWeight: FontWeight.w300,
                                    color: AppColors.textColor,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                    height: constraints.maxWidth *
                                        AppSizes.converValueToadapter(
                                            context, 2)),
                                Text(
                                  product.subCategory ?? "",
                                  style: GoogleFonts.roboto(
                                    fontSize: constraints.maxWidth *
                                        AppSizes.converValueToadapter(
                                            context, 14),
                                    fontWeight: FontWeight.w300,
                                    color: AppColors.textColor,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                    height: constraints.maxWidth *
                                        AppSizes.converValueToadapter(
                                            context, 2)),
                                Text(
                                  "${product.price.toStringAsFixed(2)} FCFA",
                                  style: GoogleFonts.roboto(
                                    fontSize: constraints.maxWidth *
                                        AppSizes.converValueToadapter(
                                            context, 14),
                                    color: AppColors.textColor,
                                  ),
                                ),
                                SizedBox(
                                    height: constraints.maxWidth *
                                        AppSizes.converValueToadapter(
                                            context, 3)),
                                GeneratedStarRating(rating: product.rating!)
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              })
        ],
      ),
    );
  }

  Widget _notation(BuildContext context, constraints) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 20),
                vertical: constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 10)),
            child: Text(
              "Soyez le premier à laisser votre avis",
              style: GoogleFonts.roboto(
                  fontSize: constraints.maxWidth *
                      AppSizes.converValueToadapter(context, 14),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 16),
                vertical: constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Votre évaluation *",
                  style: GoogleFonts.roboto(
                      fontSize: constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 14),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor),
                ),
                SizedBox(
                    height: constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 10)),
                Row(
                  children: List.generate(5, (index) {
                    int starValue = index + 1;
                    return GestureDetector(
                      onTap: () => handleRating(starValue),
                      child: Icon(
                        Icons.star,
                        color: starValue <= rating ? Colors.amber : Colors.grey,
                        size: constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 20),
                      ),
                    );
                  }),
                ),
                SizedBox(
                    height: constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 10)),
                Text(
                  rating > 0
                      ? "Vous avez donné une note de $rating étoile(s)."
                      : "Sélectionnez une note.",
                  style: GoogleFonts.roboto(
                      fontSize: constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 14),
                      color: AppColors.textColor),
                ),
              ],
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 16),
                      vertical: constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 10)),
                  child: Text(
                    "Les champs obligatoires *",
                    style: GoogleFonts.roboto(
                        fontSize: constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 14),
                        color: AppColors.textColor),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 16),
                      vertical: constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 10)),
                  child: Text(
                    "Votre nom *",
                    style: GoogleFonts.roboto(
                        fontSize: constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 14),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(constraints.maxWidth *
                      AppSizes.converValueToadapter(context, 8)),
                  child: TextFormField(
                    controller: _userNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer un numéro ou un e-mail';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "nom",
                      hintStyle: GoogleFonts.roboto(
                          fontSize: constraints.maxWidth *
                              AppSizes.converValueToadapter(context, 14)),
                      filled: true,
                      fillColor: AppColors.productBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 10)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    height: constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 10)),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 16),
                      vertical: constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 10)),
                  child: Text(
                    "Votre avis *",
                    style: GoogleFonts.roboto(
                        fontSize: constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 14),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(constraints.maxWidth *
                      AppSizes.converValueToadapter(context, 8)),
                  child: TextFormField(
                    controller: _commentController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez un text';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "commentaire...",
                      hintStyle: GoogleFonts.roboto(
                          fontSize: constraints.maxWidth *
                              AppSizes.converValueToadapter(context, 14)),
                      filled: true,
                      fillColor: AppColors.productBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 10)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    height: constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 25)),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 50),
                      vertical: constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 20)),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                          constraints.maxWidth *
                              AppSizes.converValueToadapter(context, 400),
                          constraints.maxWidth *
                              AppSizes.converValueToadapter(context, 40)),
                      backgroundColor: AppColors.banerBtnNavigatorBackground,
                    ),
                    onPressed: () {
                      handleSubmit();
                    },
                    child: Text("Commenter".toUpperCase(),
                        style: GoogleFonts.roboto(
                            fontSize: constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 14),
                            color: AppColors.productBackground)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _avis(BuildContext context, constraints) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 20),
                vertical: constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 10)),
            child: Text(
              "Les avis des clients",
              style: GoogleFonts.roboto(
                fontSize: constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 14),
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
          ),
          // Utilisation d'un ListView pour afficher les avis
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: widget.product.commentaires.length,
              itemBuilder: (context, index) {
                final avis =
                    widget.product.commentaires.reversed.toList()[index];
                if (widget.product.commentaires.isNotEmpty) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 20),
                        vertical: constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          avis.name ?? "",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 14),
                          ),
                        ),
                        GeneratedStarUserRating(rating: avis.rating!.toInt()),
                        Text(
                          DateFormat("dd MMM yyyy").format(avis.date!),
                          style: GoogleFonts.roboto(
                            color: Colors.grey,
                            fontSize: constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 14),
                          ),
                        ),
                        Text(
                          avis.avis ?? "",
                          style: GoogleFonts.roboto(
                            fontSize: constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 14),
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      "Aucuns commentaires..",
                      style: GoogleFonts.roboto(
                        fontSize: constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 14),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
