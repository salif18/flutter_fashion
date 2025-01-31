
import 'package:ecom/models/produits_model.dart';
import 'package:ecom/services/products_api.dart';
import 'package:ecom/utils/app_color.dart';
import 'package:ecom/utils/app_size.dart';
import 'package:ecom/views/detail/single.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PromoView extends StatefulWidget {
  const PromoView({super.key});

  @override
  State<PromoView> createState() => _PromoViewState();
}

class _PromoViewState extends State<PromoView> {
  ServicesAPiProducts api = ServicesAPiProducts();

  Stream<List<ProductModel>> fetchProductPromoData() async* {
    final res = await api.getAllPromo();
    final body = res.data;
    if (res.statusCode == 200) {
      // Vérifiez la structure ici
      yield (body["offres"] as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to load products ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrincal,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.backgroundPrincal,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Promotion",
                style: GoogleFonts.roboto(
                    fontSize:
                        MediaQuery.of(context).size.width * AppSizes.fontLarge,
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 20),
              child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Meilleures offres',
                            style: GoogleFonts.roboto(
                              fontSize: MediaQuery.of(context).size.width *
                                  AppSizes.fontMedium,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor,
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
            ),
          ),
          SliverToBoxAdapter(child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                width: constraints.maxWidth,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: StreamBuilder<List<ProductModel>>(
                  stream: fetchProductPromoData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                          // child: CircularProgressIndicator()
                          );
                    } else 
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Une erreur s'est produite lors du chargement",
                          style: GoogleFonts.roboto(
                            fontSize:
                                MediaQuery.of(context).size.width *
                                    AppSizes.fontSmall,
                          ),
                        ),
                      );
                    } else if (!snapshot.hasData ||
                        snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          "Aucune donnée disponible",
                          style: GoogleFonts.roboto(
                            fontSize:
                                MediaQuery.of(context).size.width *
                                    AppSizes.fontSmall,
                          ),
                        ),
                      );
                    } else {
                      final products = snapshot.data!;
                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.72,
                        ),
                        shrinkWrap: true,
                        itemCount: products.length,
                        itemBuilder: (BuildContext context, int index) {
                          final product = products[index];
                          return GestureDetector(
                            onTap: () {
                              // Action on product tap
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SingleProduct(
                                              product: product)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                // color: AppColors.productBackground,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Stack(children: [
                                    Container(
                                      width: constraints.maxWidth,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              product.image!),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        child: Container(
                                      width: 40,
                                      height: 40,
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
                                              blurRadius:
                                                  5, // Flou de l'ombre
                                              offset: const Offset(3,
                                                  3), // Déplacement horizontal et vertical
                                            ),
                                          ],
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(
                                                  20)),
                                      child: Text(
                                        "-${product.discountPercentage!.floor().toString()}%",
                                        style: GoogleFonts.roboto(
                                            fontSize:
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    AppSizes.fontSmall,
                                            color: Colors.white),
                                      ),
                                    ))
                                  ]),
                                  const SizedBox(height: 16),
                                  Text(
                                    product.name!,
                                    style: GoogleFonts.roboto(
                                      fontSize: MediaQuery.of(context)
                                              .size
                                              .width *
                                          AppSizes.fontSmall,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor,
                                    ),
                                    // softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    // maxLines: 2,
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
          ))
        ],
      ),
    );
  }
}
