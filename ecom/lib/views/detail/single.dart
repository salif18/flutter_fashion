// ignore: depend_on_referenced_packages
import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
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

  Stream<List<ProductModel>> fetchProductData() async* {
    final res = await api.getSingleProducts(widget.product.id);
    final body = jsonDecode(res.body);
    if (res.statusCode == 200) {
      yield (body["recommandations"] as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to load products ");
    }
  }

  late String mainImage;
  late String selectedColor = '';
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
    return colorMap[color.toLowerCase()] ?? Colors.grey; // Gris par défaut si non trouvé
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
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: MySliverPersistentHeaderDelegate(
              maxHeight: 360,
              minHeight: 30,
              mainImage: mainImage,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.backgroundPrincal,
              child: Column(
                children: [
                  _overProductImage(context),
                  _headerDescription(context),
                  _productDescription(context),
                  // Colors
                  if (widget.product.othersColors.isNotEmpty)
                    _colorOptions(context, currentColor),
                  _diviser(context),
                  // _actionsButtons(context, addToCart),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Material(
                          color: AppColors.productBackground,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(10),
                                  right: Radius.circular(10))),
                          child: TabBar(
                            indicator: BoxDecoration(
                                color: AppColors.colorBtnSecondary,
                                borderRadius: BorderRadius.circular(10)),
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
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              AppSizes.fontSmall),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  "Notez",
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w600,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              AppSizes.fontSmall),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  "Les avis",
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w600,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              AppSizes.iconSmall),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _productRelated(context),
                          _notation(context),
                          _avis(context)
                        ],
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
      bottomNavigationBar: _actionsButtons(context, addToCart),
    );
  }

// LES AUTRE IMAGES DU PRODUIT
  Widget _overProductImage(BuildContext context) {
    return Container(
      height: 130,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: widget.product.othersColors.length,
        itemBuilder: (context, index) {
          final colorChoise = widget.product.othersColors[index];
          return GestureDetector(
            onTap: () =>
                changeImage(widget.product.othersColors[index].images ?? ""),
            child: Container(
              margin: const EdgeInsets.all(8),
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
              width: 80,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    widget.product.othersColors[index].images!,
                    fit: BoxFit.contain,
                  )),
            ),
          );
        },
      ),
    );
  }

//LE HEADER
  Widget _headerDescription(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 15),
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
                            widget.product.name!,
                            style: GoogleFonts.roboto(
                              fontSize: MediaQuery.of(context).size.width *
                                  AppSizes.fontSmall,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            widget.product.subCategory ?? "",
                            style: GoogleFonts.roboto(
                                fontSize: MediaQuery.of(context).size.width *
                                    AppSizes.fontSmall,
                                color: Colors.grey),
                          ),
                          Row(
                            children: [
                              Text(
                                widget.product.price.toString(),
                                style: GoogleFonts.roboto(
                                  fontSize: MediaQuery.of(context).size.width *
                                      AppSizes.fontSmall,
                                  decoration: widget.product.isPromo
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                              // Évaluation (rating)
                              if (widget.product.isPromo)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "${widget.product.promoPrice!} FCFA",
                                    style: GoogleFonts.roboto(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                AppSizes.fontSmall,
                                        color: AppColors.colorBtnSecondary),
                                  ),
                                ),
                            ],
                          ),
                          GeneratedStarRating(rating: widget.product.rating!),
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
  Widget _productDescription(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: MediaQuery.of(context).size.width / 2,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: AppColors.colorBtnPrimary,
                borderRadius: BorderRadius.circular(10)),
            child: Text(
              "Description", // Affiche "N/A" si size est null
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                  fontSize:
                      MediaQuery.of(context).size.width * AppSizes.fontSmall,
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
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Catégorie", // Affiche "N/A" si size est null
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                    fontSize:
                        MediaQuery.of(context).size.width * AppSizes.fontSmall,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              Text(
                widget.product.category ??
                    "N/A", // Affiche "N/A" si size est null
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                    fontSize:
                        MediaQuery.of(context).size.width * AppSizes.fontSmall,
                    color: AppColors.colorBtnSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

// OPTIONS COULEUR
  Widget _colorOptions(BuildContext context, ColorModel? currentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Text(
            "Couleurs disponibles",
            style: GoogleFonts.roboto(
                fontSize:
                    MediaQuery.of(context).size.width * AppSizes.fontSmall,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 90,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    margin: const EdgeInsets.all(8),
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
                    width: 45,
                    height: 50,
                  ),
                );
              } else {
                return const SizedBox.shrink(); // Retourne un widget vide
              }
            },
          ),
        ),
        const SizedBox(height: 10),
        if ((widget.product.category == "Vêtements" ||
                widget.product.category == "Chaussures") &&
            currentColor != null &&
            currentColor.sizes.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    "Tailles disponibles",
                    style: GoogleFonts.roboto(
                        fontSize: MediaQuery.of(context).size.width *
                            AppSizes.fontSmall,
                        fontWeight: FontWeight.bold),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
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
                                  width: 50,
                                  height: 40,
                                  margin: const EdgeInsets.all(10),
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
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              AppSizes.fontSmall,
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

  Widget _diviser(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Divider(
        height: 3,
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
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      color: AppColors.backgroundPrincal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
             width: 60,
            height: 60,
            decoration: BoxDecoration(
                color: AppColors.productBackground,
                borderRadius: BorderRadius.circular(10)),
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
                          size: MediaQuery.of(context).size.width *
                              AppSizes.iconHyperLarge),
                    ),
                    if (provider.cart.isNotEmpty)
                      Positioned(
                        left: 35,
                        bottom: 30,
                        child: Badge.count(
                          count: provider.nombreArticles,
                          largeSize: 35 / 2,
                          backgroundColor: Colors.deepOrange,
                          textStyle: GoogleFonts.roboto(
                            fontSize: 12,
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
          const SizedBox(width: 10),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                color: AppColors.productBackground,
                borderRadius: BorderRadius.circular(10)),
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
                          size: MediaQuery.of(context).size.width *
                              AppSizes.iconHyperLarge,
                          color: const Color(0xff2c3e50),
                        )
                      : Icon(
                          Icons.favorite,
                          size: MediaQuery.of(context).size.width *
                              AppSizes.iconHyperLarge,
                          color: Colors.red,
                        ),
                ),
              );
            }),
          ),
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                backgroundColor: AppColors.banerBtnNavigatorBackground,
              ),
              onPressed: () {
                addToCart(
                    widget.product, mainImage, selectedSize!, selectedColor);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "Article ajouté",
                    style: GoogleFonts.roboto(fontSize: 16),
                  ),
                  // backgroundColor: const Color.fromARGB(255, 255, 35, 19),
                  duration: const Duration(seconds: 1),
                  backgroundColor: Colors.blueAccent,
                  action: SnackBarAction(
                    label: "",
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                ));
              },
              icon: const Icon(Icons.add_shopping_cart,
                  color: Colors.white, size: 30),
              label: Text(
                "Ajouter au panier",
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // product relatife
  Widget _productRelated(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Vous aimerez aussi ',
                    style: GoogleFonts.roboto(
                        fontSize: MediaQuery.of(context).size.width *
                            AppSizes.fontMedium,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size:
                        MediaQuery.of(context).size.width * AppSizes.iconMedium,
                  ),
                )
              ],
            ),
            Expanded(
                child: StreamBuilder<List<ProductModel>?>(
                    stream: fetchProductData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(
                          "Une erreur s'est produit lors du chargement",
                          style: GoogleFonts.roboto(
                            fontSize: MediaQuery.of(context).size.width *
                                AppSizes.fontSmall,
                          ),
                        ));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text(
                          "Aucuns données disponibles",
                          style: GoogleFonts.roboto(
                            fontSize: MediaQuery.of(context).size.width *
                                AppSizes.fontSmall,
                          ),
                        ));
                      } else {
                        final products = snapshot.data!;
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 0.1,
                            mainAxisSpacing: 2,
                            childAspectRatio: 0.49,
                          ),
                          shrinkWrap: true,
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
                                    color: AppColors.productBackground,
                                    borderRadius: BorderRadius.circular(20)),
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(16),
                                width: MediaQuery.of(context).size.width / 2.14,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: constraints.maxWidth,
                                      height: 150,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Image(
                                        image: NetworkImage(product.image!),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            child: Text(
                                              product.name!,
                                              style: GoogleFonts.roboto(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          AppSizes.fontSmall,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.textColor),
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      product.category!,
                                      style: GoogleFonts.roboto(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                AppSizes.fontSmall,
                                        fontWeight: FontWeight.w300,
                                        color: AppColors.textColor,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      product.subCategory!,
                                      style: GoogleFonts.roboto(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                AppSizes.fontSmall,
                                        fontWeight: FontWeight.w300,
                                        color: AppColors.textColor,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "${product.price.toStringAsFixed(2)} FCFA",
                                      style: GoogleFonts.roboto(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                AppSizes.fontSmall,
                                        color: AppColors.textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    GeneratedStarUserRating(
                                        rating: product.rating!.toInt())
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    }))
          ],
        ),
      );
    });
  }

  Widget _notation(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Soyez le premier à laisser votre avis",
              style: GoogleFonts.roboto(
                  fontSize:
                      MediaQuery.of(context).size.width * AppSizes.fontMedium,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Votre évaluation *",
                  style: GoogleFonts.roboto(
                      fontSize: MediaQuery.of(context).size.width *
                          AppSizes.fontMedium,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor),
                ),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(5, (index) {
                    int starValue = index + 1;
                    return GestureDetector(
                      onTap: () => handleRating(starValue),
                      child: Icon(
                        Icons.star,
                        color: starValue <= rating ? Colors.amber : Colors.grey,
                        size: 36,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10),
                Text(
                  rating > 0
                      ? "Vous avez donné une note de $rating étoile(s)."
                      : "Sélectionnez une note.",
                  style: GoogleFonts.roboto(
                      fontSize: MediaQuery.of(context).size.width *
                          AppSizes.fontSmall,
                      color: AppColors.textColor),
                ),
              ],
            ),
          ),
          Expanded(
              child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10),
                  child: Text(
                    "Les champs obligatoires *",
                    style: GoogleFonts.roboto(
                        fontSize: MediaQuery.of(context).size.width *
                            AppSizes.fontSmall,
                        color: AppColors.textColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10),
                  child: Text(
                    "Votre nom *",
                    style: GoogleFonts.roboto(
                        fontSize: MediaQuery.of(context).size.width *
                            AppSizes.fontMedium,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                          fontSize: MediaQuery.of(context).size.width *
                              AppSizes.fontSmall),
                      filled: true,
                      fillColor: AppColors.productBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10),
                  child: Text(
                    "Votre avis *",
                    style: GoogleFonts.roboto(
                        fontSize: MediaQuery.of(context).size.width *
                            AppSizes.fontMedium,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                          fontSize: MediaQuery.of(context).size.width *
                              AppSizes.fontSmall),
                      filled: true,
                      fillColor: AppColors.productBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(400, 50),
                      backgroundColor: AppColors.banerBtnNavigatorBackground,
                    ),
                    onPressed: () {
                      handleSubmit();
                    },
                    child: Text("Commenter".toUpperCase(),
                        style: GoogleFonts.roboto(
                            fontSize: MediaQuery.of(context).size.width *
                                AppSizes.fontSmall,
                            color: AppColors.productBackground)),
                  ),
                ),
              ],
            ),
          ))
        ],
      );
    });
  }

  Widget _avis(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Les avis des clients",
              style: GoogleFonts.roboto(
                fontSize:
                    MediaQuery.of(context).size.width * AppSizes.fontMedium,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
          ),
          // Utilisation d'un ListView pour afficher les avis
          Expanded(
            child: ListView.builder(
              itemCount: widget.product.commentaires.length,
              itemBuilder: (context, index) {
                final avis = widget.product.commentaires.reversed.toList()[index];
                if (widget.product.commentaires.isNotEmpty) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          avis.name!,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width *
                                AppSizes.fontSmall,
                          ),
                        ),
                        GeneratedStarUserRating(rating: avis.rating!.toInt()),
                        Text(
                          DateFormat("dd MMM yyyy").format(avis.date!),
                          style: GoogleFonts.roboto(
                            color: Colors.grey,
                            fontSize: MediaQuery.of(context).size.width *
                                AppSizes.fontSmall,
                          ),
                        ),
                        Text(
                          avis.avis!,
                          style: GoogleFonts.roboto(
                            fontSize: MediaQuery.of(context).size.width *
                                AppSizes.fontSmall,
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
                        fontSize: MediaQuery.of(context).size.width *
                            AppSizes.fontSmall,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      );
    });
  }
}
