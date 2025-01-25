import 'package:ecom/components/drawer.dart';
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

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  ServicesAPiProducts api = ServicesAPiProducts();
  ServicesAPiMarques marquesApi = ServicesAPiMarques();
  List<ProductModel> _products = [];

  int? selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _fetchProducts();
  }

  Stream<List<CategoryModel>> fetchCategoriData() async* {
    final res = await api.getAllCategorys();
    final body = res.data;
    if (res.statusCode == 200) {
      //print("Body: $body"); // Vérifiez la structure ici
      yield (body["categories"] as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to load products ");
    }
  }

  Stream<List<ProductModel>> fetchProductData() async* {
    final res = await api.getAllProducts();
    final body = res.data;
    if (res.statusCode == 200) {
      yield (body["produits"] as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to load products ");
    }
  }

// recuperation du produit
  Future<void> _fetchProducts() async {
    try {
      final response = await api.getAllProducts();
      if (response.statusCode == 200) {
        final body = response.data;
        setState(() {
          _products = (body["produits"] as List)
              .map((json) => ProductModel.fromJson(json))
              .toList();
        });
      }
    } catch (e) {
      Exception('Erreur : $e');
    }
  }

  Stream<List<PopulairesModel>> fetchProductPopulaires() async* {
    final res = await api.getProductPlusAchete();
    final body = res.data;
    if (res.statusCode == 200) {
      yield (body["produitsLesPlusAchetés"] as List)
          .map((json) => PopulairesModel.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to load products ");
    }
  }

  Stream<List<ProductModel>> fetchProductPromoData() async* {
    final res = await api.getPromo();
    final body = res.data;
    if (res.statusCode == 200) {
      //print("Body: $body"); // Vérifiez la structure ici
      yield (body["allOffre"] as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to load products ");
    }
  }

  Stream<List<MarquesModel>> fetchMarquesData() async* {
    final res = await marquesApi.getAllMarques();
    final body = res.data;
    if (res.statusCode == 200) {
      //print("Body: $body"); // Vérifiez la structure ici
      yield (body["marques"] as List)
          .map((json) => MarquesModel.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to load products ");
    }
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

//  base64Decode(base64Image.split(',').last);

// Widget imageWidget = Image.memory(decodedImage);
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
                toolbarHeight: 80,
                pinned: true,
                floating: true,
                leading: IconButton(
                    onPressed: () {
                      drawerKey.currentState!.openDrawer();
                    },
                    icon: Icon(
                      LineIcons.user,
                      size: MediaQuery.of(context).size.width *
                          AppSizes.iconLarge,
                      color: AppColors.textColor,
                    )),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text("Shop-Line".toUpperCase(),
                      style: GoogleFonts.roboto(
                          fontSize: MediaQuery.of(context).size.width *
                              AppSizes.fontMedium,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange)),
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
                  const SizedBox(width: 28.8),
                ],
              ),
              const SliverToBoxAdapter(
                child: MyCarouselWidget(),
              ),
              SliverToBoxAdapter(child: _categorie(context)),
              SliverToBoxAdapter(child: _arrivages(context)),
              SliverToBoxAdapter(child: _populaires(context)),
              SliverToBoxAdapter(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Autres offres',
                        style: GoogleFonts.roboto(
                          fontSize: MediaQuery.of(context).size.width *
                              AppSizes.fontMedium,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PromoView()));
                          },
                          child: Text(
                            "Voire plus",
                            style: GoogleFonts.roboto(
                              fontSize: MediaQuery.of(context).size.width *
                                  AppSizes.fontSmall,
                            ),
                          ))
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: _offres(context)),
              SliverToBoxAdapter(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Les marques',
                        style: GoogleFonts.roboto(
                          fontSize: MediaQuery.of(context).size.width *
                              AppSizes.fontMedium,
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
                          size: MediaQuery.of(context).size.width *
                              AppSizes.iconSmall,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: _marques(context)),
            ],
          );
        }));
  }

  Widget _categorie(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: 250,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Categories',
                    style: GoogleFonts.roboto(
                        fontSize: MediaQuery.of(context).size.width *
                            AppSizes.fontMedium,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Icon(
                    Icons.arrow_forward_ios_sharp,
                    size:
                        MediaQuery.of(context).size.width * AppSizes.iconSmall,
                  ),
                )
              ],
            ),
            Expanded(
                child: StreamBuilder<List<CategoryModel>>(
                    stream: fetchCategoriData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator()
                          );
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(
                          "Une erreur s'est produit lors du chargement",
                          style: GoogleFonts.roboto(
                            fontSize: MediaQuery.of(context).size.width *
                                AppSizes.fontSmall,
                          ),
                        ));
                      } else if (!snapshot.hasData) {
                        return Center(
                            child: Text(
                          "Aucuns données disponibles",
                          style: GoogleFonts.roboto(
                            fontSize: MediaQuery.of(context).size.width *
                                AppSizes.fontSmall,
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
                                              categoSelected:
                                                  categorie.category,
                                            )));
                              },
                              child: Container(
                                decoration: BoxDecoration(

                                    //  color:   ? AppColors
                                    //         .colorBtnPrimary // Couleur active
                                    //     : AppColors
                                    //         .productBackground, // Couleur normale
                                    borderRadius: BorderRadius.circular(5)),
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(4),
                                width: MediaQuery.of(context).size.width / 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: Image.network(
                                        categorie.image!,
                                        fit: BoxFit.contain,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      categorie.category!,
                                      style: GoogleFonts.roboto(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              AppSizes.fontSmall,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textColor),
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
                    }))
          ],
        ),
      );
    });
  }

  Widget _arrivages(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: 360,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Arrivages',
                      style: GoogleFonts.roboto(
                        fontSize: MediaQuery.of(context).size.width *
                            AppSizes.fontMedium,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: MediaQuery.of(context).size.width *
                          AppSizes.iconSmall,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: StreamBuilder<List<ProductModel>?>(
                  stream: fetchProductData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator()
                        );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Une erreur s'est produite lors du chargement",
                          style: GoogleFonts.roboto(
                            fontSize: MediaQuery.of(context).size.width *
                                AppSizes.fontSmall,
                          ),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          "Aucunes données disponibles",
                          style: GoogleFonts.roboto(
                            fontSize: MediaQuery.of(context).size.width *
                                AppSizes.fontSmall,
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
                                borderRadius: BorderRadius.circular(20),
                              ),
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(16),
                              width: MediaQuery.of(context).size.width / 2.14,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(product.image!),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    product.name!,
                                    style: GoogleFonts.roboto(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              AppSizes.fontSmall,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _populaires(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: 390,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Populaires',
                    style: GoogleFonts.roboto(
                        fontSize: MediaQuery.of(context).size.width *
                            AppSizes.fontMedium,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward_ios_sharp,
                    size:
                        MediaQuery.of(context).size.width * AppSizes.iconSmall,
                  ),
                ),
              ],
            ),
            Expanded(
                child: StreamBuilder<List<PopulairesModel>?>(
                    stream: fetchProductPopulaires(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator()
                          );
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
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: products.length,
                          itemBuilder: (BuildContext context, int index) {
                            final product = products[index];
                            final prodChoise = _products.firstWhere(
                                (item) => item.id == product.produitId);
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SingleProduct(
                                            product: prodChoise)));
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
                                      product.categorie!,
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
                                      product.sousCategorie!,
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
                    }))
          ],
        ),
      );
    });
  }

  Widget _offres(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: StreamBuilder<List<ProductModel>>(
            stream: fetchProductPromoData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator()
                  );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Une erreur s'est produite lors du chargement",
                    style: GoogleFonts.roboto(
                      fontSize: MediaQuery.of(context).size.width *
                          AppSizes.fontSmall,
                    ),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "Aucune donnée disponible",
                    style: GoogleFonts.roboto(
                      fontSize: MediaQuery.of(context).size.width *
                          AppSizes.fontSmall,
                    ),
                  ),
                );
              } else {
                final products = snapshot.data!;
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.65,
                  ),
                  shrinkWrap: true,
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
                        decoration: BoxDecoration(
                          color: AppColors.productBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(children: [
                              Container(
                                width: constraints.maxWidth,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(product.image!),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Positioned(
                                  child: Container(
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        // ignore: deprecated_member_use
                                        color: Colors.black
                                            // ignore: deprecated_member_use
                                            .withOpacity(
                                                0.2), // Couleur de l'ombre
                                        spreadRadius:
                                            2, // Élargissement de l'ombre
                                        blurRadius: 5, // Flou de l'ombre
                                        offset: const Offset(3,
                                            3), // Déplacement horizontal et vertical
                                      ),
                                    ],
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  "-${product.discountPercentage!.floor().toString()}%",
                                  style: GoogleFonts.roboto(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              AppSizes.fontSmall,
                                      color: Colors.white),
                                ),
                              ))
                            ]),
                            const SizedBox(height: 8),
                            Text(
                              product.name!,
                              style: GoogleFonts.roboto(
                                fontSize: MediaQuery.of(context).size.width *
                                    AppSizes.fontSmall,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textColor,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
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
      },
    );
  }

  Widget _marques(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: StreamBuilder<List<MarquesModel>>(
            stream: fetchMarquesData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator()
                  );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Une erreur s'est produite lors du chargement",
                    style: GoogleFonts.roboto(
                      fontSize: MediaQuery.of(context).size.width *
                          AppSizes.fontSmall,
                    ),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "Aucune donnée disponible",
                    style: GoogleFonts.roboto(
                      fontSize: MediaQuery.of(context).size.width *
                          AppSizes.fontSmall,
                    ),
                  ),
                );
              } else {
                final marques = snapshot.data!;
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio:
                        1, // Ajustement du ratio pour afficher correctement les images
                  ),
                  shrinkWrap: true,
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
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
      },
    );
  }
}
