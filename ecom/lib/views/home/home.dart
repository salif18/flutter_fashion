import 'dart:async';

import 'package:dio/dio.dart';
import 'package:ecom/components/drawer.dart';
import 'package:ecom/components/shimmer_widget.dart';
// import 'package:ecom/components/generatedStarProduct.dart';
// import 'package:ecom/components/generatedStart.dart';
import 'package:ecom/models/categorie_model.dart';
import 'package:ecom/models/marques_model.dart';
import 'package:ecom/models/populaire_model.dart';
import 'package:ecom/models/produits_model.dart';
import 'package:ecom/providers/cart_provider.dart';
import 'package:ecom/services/marque_api.dart';
import 'package:ecom/services/products_api.dart';
import 'package:ecom/utils/app_color.dart';
import 'package:ecom/utils/app_size.dart';
import 'package:ecom/views/cart/cart.dart';
import 'package:ecom/views/detail/single.dart';
import 'package:ecom/views/home/widgets/carousel.dart';
import 'package:ecom/views/promo/promo.dart';
import 'package:ecom/views/store/stores.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  ServicesAPiProducts api = ServicesAPiProducts();
  ServicesAPiMarques marquesApi = ServicesAPiMarques();
  List<ProductModel> _products = [];

  int? selectedIndex = 0;

  // Méthodes pour récupérer les données (remplace les streams)
  late Future<List<CategoryModel>> fetchCategories;
  late Future<List<ProductModel>> fetchProducts;
  late Future<List<PopulairesModel>> fetchPopulaires;
  late Future<List<ProductModel>> fetchPromos;
  late Future<List<MarquesModel>> fetchMarques;

  @override
  void initState() {
    super.initState();

    fetchCategories = fetchCategoriData();
    fetchProducts = fetchProductData();
    fetchPopulaires = fetchProductPopulaires();
    fetchPromos = fetchProductPromoData();
    fetchMarques = fetchMarquesData();
  }

  Future<List<CategoryModel>> fetchCategoriData() async {
    try {
      final res = await api.getAllCategorys();
      final body = res.data;
      if (res.statusCode == 200) {
        //print("Body: $body"); // Vérifiez la structure ici
        return (body["categories"] as List)
            .map((json) => CategoryModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to load products ");
      }
    } on DioException {
      api.showSnackBarErrorPersonalized(
          context, "Problème de connexion : Vérifiez votre Internet.");
    } on TimeoutException {
      api.showSnackBarErrorPersonalized(
          context, "Le serveur ne répond pas. Veuillez réessayer plus tard.");
    } catch (e) {
      api.showSnackBarErrorPersonalized(context, "$e");
    }
    return [];
  }

  Future<List<ProductModel>> fetchProductData() async {
    try {
      final res = await api.getAllProducts();
      final body = res.data;
      if (res.statusCode == 200) {
        setState(() {
          _products = (body["produits"] as List)
              .map((json) => ProductModel.fromJson(json))
              .toList();
        });
        return (body["produits"] as List)
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
    } catch (e) {
      api.showSnackBarErrorPersonalized(context, "$e");
    }
    return [];
  }

  Future<List<PopulairesModel>> fetchProductPopulaires() async {
    try {
      final res = await api.getProductPlusAchete();
      final body = res.data;
      if (res.statusCode == 200) {
        return (body["produitsLesPlusAchetés"] as List)
            .map((json) => PopulairesModel.fromJson(json))
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
    } catch (e) {
      api.showSnackBarErrorPersonalized(context, "$e");
    }
    return [];
  }

  Future<List<ProductModel>> fetchProductPromoData() async {
    try {
      final res = await api.getPromo();
      final body = res.data;
      if (res.statusCode == 200) {
        //print("Body: $body"); // Vérifiez la structure ici
        return (body["allOffre"] as List)
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
    } catch (e) {
      api.showSnackBarErrorPersonalized(context, "$e");
    }
    return [];
  }

  Future<List<MarquesModel>> fetchMarquesData() async {
    try {
      final res = await marquesApi.getAllMarques();
      final body = res.data;
      if (res.statusCode == 200) {
        //print("Body: $body"); // Vérifiez la structure ici
        return (body["marques"] as List)
            .map((json) => MarquesModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to load products ");
      }
    } catch (e) {
      Exception("$e");
    }
    return [];
  }

  Widget generedImage(String? name) {
    switch (name) {
      case "Accessoires":
        return Image.asset("assets/images/accessoire.png",
            width: 30, height: 30);
      case "Chaussures":
        return Image.asset("assets/images/shoes.png", width: 30, height: 30);
      case "Vêtements":
        return Image.asset("assets/images/vetement.png", width: 30, height: 30);
      case "Sacs":
        return Image.asset("assets/images/sac.png", width: 30, height: 30);
      default:
        return const Icon(Icons.image_not_supported,
            size: 30, color: Colors.grey);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: drawerKey,
        drawer: const DrawerWidget(),
        backgroundColor: AppColors.backgroundPrincal,
        body: LayoutBuilder(builder: (context, constraints) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white, // Couleur opaque
                elevation: 0, // Supprime l'ombre si nécessaire
                // toolbarHeight: 100,
                toolbarHeight: constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 50),
                pinned: true,
                floating: true,
                leading: IconButton(
                    onPressed: () {
                      drawerKey.currentState!.openDrawer();
                    },
                    icon: Icon(
                      LineIcons.bars,
                      size: constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 30),
                      color: Colors.black,
                    )),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text("Stylify",
                      style: GoogleFonts.aladin(
                          fontSize: constraints.maxWidth *
                              AppSizes.converValueToadapter(context, 22),
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrangeAccent)),
                ),
                actions: [
                  Consumer<CartProvider>(
                    builder: (context, provider, child) {
                      return Stack(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CartView())),
                            icon: Icon(Icons.shopping_cart_outlined,
                                color: Colors.deepOrange,
                                size: constraints.maxWidth *
                                    AppSizes.converValueToadapter(context, 30)),
                          ),
                          if (provider.cart.isNotEmpty)
                            Positioned(
                              left: constraints.maxWidth *
                                  AppSizes.converValueToadapter(context, 25),
                              bottom: constraints.maxWidth *
                                  AppSizes.converValueToadapter(context, 25),
                              child: Badge.count(
                                count: provider.nombreArticles,
                                largeSize: constraints.maxWidth *
                                    AppSizes.converValueToadapter(context, 35) /
                                    2,
                                backgroundColor: Colors.black,
                                textStyle: GoogleFonts.roboto(
                                  fontSize: constraints.maxWidth *
                                      AppSizes.converValueToadapter(
                                          context, 12),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  SizedBox(
                      width: constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 28)),
                ],
              ),
              SliverToBoxAdapter(
                  child: MyCarouselWidget(constraints: constraints)),
              SliverToBoxAdapter(
                  child: _functionTitle(context, constraints, "Categories")),
              SliverToBoxAdapter(child: _categorie(context, constraints)),
              SliverToBoxAdapter(
                  child: _functionTitle(context, constraints, "Arrivages")),
              SliverToBoxAdapter(child: _arrivages(context, constraints)),
              SliverToBoxAdapter(
                  child: _functionTitle(context, constraints, "Populaires")),
              SliverToBoxAdapter(child: _populaires(context, constraints)),
              SliverToBoxAdapter(
                  child: _functionTitleOffre(
                      context, constraints, "Autres offres")),
              SliverToBoxAdapter(child: _offres(context, constraints)),
              SliverToBoxAdapter(
                  child: _functionTitle(context, constraints, "Les marques")),
              SliverToBoxAdapter(child: _marques(context, constraints)),
            ],
          );
        }));
  }

  Widget _functionTitleOffre(BuildContext context, constraints, title) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: constraints.maxWidth *
              AppSizes.converValueToadapter(context, 16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: constraints.maxWidth *
                  AppSizes.converValueToadapter(context, 15),
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const PromoView()));
              },
              child: Text(
                "Voire plus",
                style: GoogleFonts.roboto(
                  fontSize: constraints.maxWidth *
                      AppSizes.converValueToadapter(context, 14),
                ),
              ))
        ],
      ),
    );
  }

  Widget _functionTitle(BuildContext context, constraints, title) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal:
              constraints.maxWidth * AppSizes.converValueToadapter(context, 16),
          vertical:
              constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: constraints.maxWidth *
                  AppSizes.converValueToadapter(context, 15),
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          IconButton(
            onPressed: () {
              // Action à définir lors de l'appui sur l'icône
            },
            icon: Icon(
              Icons.arrow_forward_ios_sharp,
              size: constraints.maxWidth *
                  AppSizes.converValueToadapter(context, 14),
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _categorie(BuildContext context, constraints) {
    return SizedBox(
      height:
          constraints.maxWidth * AppSizes.converValueToadapter(context, 160),
      width: constraints.maxWidth,
      child: FutureBuilder<List<CategoryModel>>(
          future: fetchCategories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerLoadingForCategory(context, constraints,
                  itemCount: 5);
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
              final categories = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  final categorie = categories[index];
                  // final isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StoresView(
                                    categoSelected: categorie.category,
                                  )));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color:
                              //? AppColors
                              //         .colorBtnPrimary // Couleur active
                              // :
                              AppColors.productBackground, // Couleur normale
                          borderRadius: BorderRadius.circular(
                              constraints.maxWidth *
                                  AppSizes.converValueToadapter(context, 20))),
                      margin: EdgeInsets.all(constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 5)),
                      padding: EdgeInsets.all(constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 2)),
                      width: constraints.maxWidth / 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: constraints.maxWidth,
                            height: constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 120),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    constraints.maxWidth *
                                        AppSizes.converValueToadapter(
                                            context, 100))),
                            child: Image.network(
                              categorie.image ??
                                  "", // Laisse une chaîne vide si l'URL est null
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset("assets/images/default.jpg",
                                    fit: BoxFit.contain);
                              },
                            ),
                          ),

                          // SizedBox(
                          //   height: constraints.maxWidth *
                          //       AppSizes.converValueToadapter(context, 10),
                          // ),
                          Expanded(
                            // flex: 1,
                            child: Text(
                              categorie.category ?? "",
                              style: GoogleFonts.roboto(
                                  fontSize: constraints.maxWidth *
                                      AppSizes.converValueToadapter(
                                          context, 12),
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textColor),
                            ),
                          ),
                          // const SizedBox(width: 8), // Espace entre texte et image.
                          // generedImage(categorie.category),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }),
    );
  }

  Widget _arrivages(BuildContext context, constraints) {
    return SizedBox(
      height:
          constraints.maxWidth * AppSizes.converValueToadapter(context, 220),
      child: FutureBuilder<List<ProductModel>?>(
        future: fetchProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerLoading(context, constraints,
                isHorizontal: true, itemCount: 5);
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Une erreur s'est produite lors du chargement",
                style: GoogleFonts.roboto(
                  fontSize: constraints.maxWidth *
                      AppSizes.converValueToadapter(context, 14),
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "Aucunes données disponibles",
                style: GoogleFonts.roboto(
                  fontSize: constraints.maxWidth *
                      AppSizes.converValueToadapter(context, 14),
                ),
              ),
            );
          } else {
            final products = snapshot.data!.reversed.toList();
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    // Action lorsque le produit est cliqué
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SingleProduct(product: product)));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.productBackground,
                      borderRadius: BorderRadius.circular(constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 20)),
                    ),
                    margin: EdgeInsets.all(constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 5)),
                    padding: EdgeInsets.all(constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 16)),
                    width: constraints.maxWidth / 2.14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: constraints.maxWidth *
                              AppSizes.converValueToadapter(context, 135),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                constraints.maxWidth *
                                    AppSizes.converValueToadapter(context, 10)),
                            image: DecorationImage(
                              image: product.image != null &&
                                      product.image!.isNotEmpty
                                  ? NetworkImage(product.image!)
                                      as ImageProvider
                                  : const AssetImage(
                                      "assets/images/default.jpg"),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(
                            height: constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 8)),
                        Expanded(
                          // flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name ?? "",
                                style: GoogleFonts.roboto(
                                  fontSize: constraints.maxWidth *
                                      AppSizes.converValueToadapter(
                                          context, 12),
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textColor,
                                ),
                                // maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                product.subCategory ?? "",
                                style: GoogleFonts.roboto(
                                  fontSize: constraints.maxWidth *
                                      AppSizes.converValueToadapter(
                                          context, 12),
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.textColor,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _populaires(BuildContext context, constraints) {
    return SizedBox(
      height:
          constraints.maxWidth * AppSizes.converValueToadapter(context, 220),
      child: FutureBuilder<List<PopulairesModel>?>(
          future: fetchPopulaires,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerLoading(context, constraints,
                  isHorizontal: true, itemCount: 5);
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
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  final product = products[index];

                  final prodChoise = _products.isNotEmpty
                      ? _products.firstWhere(
                          (item) =>
                              item.id ==
                              product
                                  .produitId, // Retourne un produit par défaut
                        )
                      : null;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SingleProduct(product: prodChoise!)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.productBackground,
                          borderRadius: BorderRadius.circular(
                              constraints.maxWidth *
                                  AppSizes.converValueToadapter(context, 20))),
                      margin: EdgeInsets.all(constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 5)),
                      padding: EdgeInsets.all(constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 16)),
                      width: constraints.maxWidth / 2.14,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: constraints.maxWidth,
                            height: constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 130),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    constraints.maxWidth *
                                        AppSizes.converValueToadapter(
                                            context, 20))),
                            child: Image(
                              image: product.image != null &&
                                      product.image!.isNotEmpty
                                  ? NetworkImage(product.image ?? "")
                                      as ImageProvider
                                  : const AssetImage(
                                      "assets/images/default.jpg"),
                              fit: BoxFit.contain,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: constraints.maxWidth *
                                                AppSizes.converValueToadapter(
                                                    context, 8)),
                                        child: Text(
                                          product.name ?? "",
                                          style: GoogleFonts.roboto(
                                              fontSize: constraints.maxWidth *
                                                  AppSizes.converValueToadapter(
                                                      context, 12),
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
                                // Text(
                                //   product.categorie ?? "",
                                //   style: GoogleFonts.roboto(
                                //     fontSize: constraints.maxWidth *
                                //         AppSizes.converValueToadapter(
                                //             context, 14),
                                //     fontWeight: FontWeight.w300,
                                //     color: AppColors.textColor,
                                //   ),
                                //   maxLines: 2,
                                //   overflow: TextOverflow.ellipsis,
                                // ),
                                SizedBox(
                                    height: constraints.maxWidth *
                                        AppSizes.converValueToadapter(
                                            context, 2)),
                                Text(
                                  product.sousCategorie ?? "",
                                  style: GoogleFonts.roboto(
                                    fontSize: constraints.maxWidth *
                                        AppSizes.converValueToadapter(
                                            context, 12),
                                    fontWeight: FontWeight.w300,
                                    color: AppColors.textColor,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          // const SizedBox(height: 2),
                          // Text(
                          //   "${product.price.toStringAsFixed(2)} FCFA",
                          //   style: GoogleFonts.roboto(
                          //     fontSize:
                          //         MediaQuery.of(context).size.width *
                          //             AppSizes.fontSmall,
                          //     color: AppColors.textColor,
                          //   ),
                          // ),
                          // const SizedBox(height: 3),
                          // GeneratedStarRating(rating: product.rating!),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }),
    );
  }

  Widget _offres(BuildContext context, constraints) {
    return Container(
      width: constraints.maxWidth,
      height:
          constraints.maxWidth * AppSizes.converValueToadapter(context, 430),
      padding: EdgeInsets.symmetric(
          horizontal: constraints.maxWidth *
              AppSizes.converValueToadapter(context, 16)),
      child: FutureBuilder<List<ProductModel>>(
        future: fetchPromos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerLoading(context, constraints,
                isGrid: true, itemCount: 4);
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Une erreur s'est produite lors du chargement",
                style: GoogleFonts.roboto(
                  fontSize: constraints.maxWidth *
                      AppSizes.converValueToadapter(context, 14),
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "Aucune donnée disponible",
                style: GoogleFonts.roboto(
                  fontSize: constraints.maxWidth *
                      AppSizes.converValueToadapter(context, 14),
                ),
              ),
            );
          } else {
            final products = snapshot.data!;
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 0.80,
              ),
              itemCount: products.take(4).length,
              itemBuilder: (BuildContext context, int index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    // Action on product tap
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SingleProduct(product: product)));
                  },
                  child: Container(
                    height: constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 220),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 20)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(children: [
                          Container(
                            width: constraints.maxWidth,
                            height: constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 150),
                            padding: EdgeInsets.all(
                              constraints.maxWidth *
                                  AppSizes.converValueToadapter(context, 5),
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.productBackground,
                              borderRadius: BorderRadius.circular(constraints
                                      .maxWidth *
                                  AppSizes.converValueToadapter(context, 10)),
                              image: DecorationImage(
                                image: product.image != null &&
                                        product.image!.isNotEmpty
                                    ? NetworkImage(product.image!)
                                        as ImageProvider
                                    : const AssetImage(
                                        "assets/images/default.jpg"),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Positioned(
                              child: Container(
                            width: constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 50),
                            height: constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 50),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    // ignore: deprecated_member_use
                                    color: Colors.black
                                        // ignore: deprecated_member_use
                                        .withOpacity(0.2), // Couleur de l'ombre
                                    spreadRadius: 2, // Élargissement de l'ombre
                                    blurRadius: 5, // Flou de l'ombre
                                    offset: const Offset(3,
                                        3), // Déplacement horizontal et vertical
                                  ),
                                ],
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(
                                    constraints.maxWidth *
                                        AppSizes.converValueToadapter(
                                            context, 20))),
                            child: Text(
                              "-${product.discountPercentage!.floor().toString()}%",
                              style: GoogleFonts.roboto(
                                  fontSize: constraints.maxWidth *
                                      AppSizes.converValueToadapter(
                                          context, 14),
                                  color: Colors.white),
                            ),
                          ))
                        ]),
                        SizedBox(
                            height: constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 16)),
                        Expanded(
                          flex: 1,
                          child: Text(
                            product.name ?? "",
                            style: GoogleFonts.roboto(
                              fontSize: constraints.maxWidth *
                                  AppSizes.converValueToadapter(context, 12),
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor,
                            ),
                            // softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            // maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _marques(BuildContext context, constraints) {
    return Container(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      padding: EdgeInsets.symmetric(
          horizontal:
              constraints.maxWidth * AppSizes.converValueToadapter(context, 16),
          vertical:
              constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
      child: FutureBuilder<List<MarquesModel>>(
        future: fetchMarques,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerLoading(context, constraints,
                isGrid: true, itemCount: 4);
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Une erreur s'est produite lors du chargement",
                style: GoogleFonts.roboto(
                  fontSize: constraints.maxWidth *
                      AppSizes.converValueToadapter(context, 14),
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "Aucune donnée disponible",
                style: GoogleFonts.roboto(
                  fontSize: constraints.maxWidth *
                      AppSizes.converValueToadapter(context, 14),
                ),
              ),
            );
          } else {
            final marques = snapshot.data!;
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 1
                  // Ajustement du ratio pour afficher correctement les images
                  ),
              itemCount: marques.length,
              itemBuilder: (BuildContext context, int index) {
                final marque = marques[index];
                return GestureDetector(
                  onTap: () {
                    // Action sur l'élément de marque
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.productBackground,
                      borderRadius: BorderRadius.circular(constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 10)),
                    ),
                    // margin: EdgeInsets.all(constraints.maxWidth *
                    //     AppSizes.converValueToadapter(context, 10)),
                    padding: EdgeInsets.all(constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 8)),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(constraints
                                      .maxWidth *
                                  AppSizes.converValueToadapter(context, 10)),
                              image: DecorationImage(
                                image: NetworkImage(marque.image),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Ajoutez cette méthode pour générer un effet Shimmer réutilisable
  Widget _buildShimmerLoadingForCategory(
      BuildContext context, BoxConstraints constraints,
      {int itemCount = 3}) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: itemCount,
          itemBuilder: (_, __) => Container(
              width: constraints.maxWidth / 2,
              margin: EdgeInsets.all(constraints.maxWidth *
                  AppSizes.converValueToadapter(context, 5)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 20)),
              ),
              child: _shimmerCardCategori(context, constraints)),
        ));
  }

  // Ajoutez cette méthode pour générer un effet Shimmer réutilisable
  Widget _buildShimmerLoading(BuildContext context, BoxConstraints constraints,
      {bool isHorizontal = false, bool isGrid = false, int itemCount = 3}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: isHorizontal
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: itemCount,
              itemBuilder: (_, __) => Container(
                  width: constraints.maxWidth / 2,
                  margin: EdgeInsets.all(constraints.maxWidth *
                      AppSizes.converValueToadapter(context, 5)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 20)),
                  ),
                  child: _shimmerCard(context, constraints)),
            )
          : isGrid
              ? GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: itemCount,
                  itemBuilder: (_, __) => Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          color: Colors.grey[300],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8, left: 8),
                          width: 100,
                          height: 10,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: itemCount,
                  itemBuilder: (_, __) => _shimmerCard(context, constraints)),
    );
  }

  Widget _shimmerCardCategori(BuildContext context, constraints) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget(
            width: constraints.maxWidth,
            height: constraints.maxWidth *
                AppSizes.converValueToadapter(context, 100),
            // margin:  EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerWidget(
                    width: constraints.maxWidth,
                    height: 10,
                    margin: EdgeInsets.all(constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 8)),
                    // margin:  EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerCard(BuildContext context, constraints) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget(
            width: constraints.maxWidth,
            height: constraints.maxWidth *
                AppSizes.converValueToadapter(context, 120),
            // margin:  EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerWidget(
                    width: constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 100),
                    height: 10,
                    margin: EdgeInsets.all(constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 8)),
                  ),
                  ShimmerWidget(
                    width: constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 80),
                    height: 10,
                    // margin:  EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
