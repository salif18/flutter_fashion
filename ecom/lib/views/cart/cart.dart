import 'package:ecom/providers/cart_provider.dart';
import 'package:ecom/utils/app_color.dart';
import 'package:ecom/utils/app_size.dart';
import 'package:ecom/views/cart/widgets/address_livraison.dart';
import 'package:ecom/views/cart/widgets/cart_emptty.dart';
import 'package:ecom/views/cart/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundPrincal,
        body: CustomScrollView(
          slivers: [
            // AppBar
            SliverAppBar(
              expandedHeight: 80,
              backgroundColor: AppColors.backgroundPrincal,
              pinned: true,
              floating: true,
    
              centerTitle: true,
              title: Text(
                "Mon panier",
                style: GoogleFonts.roboto(
                  fontSize:
                      MediaQuery.of(context).size.width * AppSizes.fontLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                Consumer<CartProvider>(
                  builder: (context, provider, child) {
                    return Stack(
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: MediaQuery.of(context).size.width *
                              AppSizes.iconHyperLarge,
                        ),
                        if (provider.cart.isNotEmpty)
                          Positioned(
                            left: 15,
                            bottom: 18,
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
            // Body content
            SliverToBoxAdapter(
              child: Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  final cart = cartProvider.cart;

                  if (cart.isEmpty) {
                    return const EmptyCart();
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return Dismissible(
                        key: Key(item.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          cartProvider.removeFromCart(
                            item.id,
                            item.selectedSize,
                            item.selectedColor,
                          );
                        },
                        confirmDismiss: (direction) async {
                          return await _showAlertDelete(context);
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: const BoxDecoration(
                            color: AppColors.banerBtnNavigatorBackground,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: const Icon(
                            Icons.delete_rounded,
                            size: AppSizes.iconLarge,
                            color: Colors.white,
                          ),
                        ),
                        child: MyCard(item: item),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar:
            Consumer<CartProvider>(builder: (context, cartProvider, child) {
          List<CartItem> cart = cartProvider.cart;
          double total = cartProvider.total;
          return cart.isEmpty
              ? const SizedBox.shrink()
              : Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  width: double.infinity,
                  height: 200,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Nombre d'articles",
                              style: GoogleFonts.roboto(
                                fontSize: MediaQuery.of(context).size.width *
                                    AppSizes.fontMedium,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF1D1A30),
                              ),
                            ),
                            Text(
                              "${cartProvider.nombreArticles}",
                              style: GoogleFonts.roboto(
                                fontSize: MediaQuery.of(context).size.width *
                                    AppSizes.fontSmall,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1D1A30),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total",
                              style: GoogleFonts.roboto(
                                fontSize: MediaQuery.of(context).size.width *
                                    AppSizes.fontMedium,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "$total FCFA",
                              style: GoogleFonts.roboto(
                                fontSize: MediaQuery.of(context).size.width *
                                    AppSizes.fontMedium,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            minimumSize: const Size(400, 50),
                          ),
                          icon: Icon(
                            Icons.monetization_on,
                            size: MediaQuery.of(context).size.width *
                                AppSizes.iconLarge,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _showAddLocation(context);
                            
                          },
                          label: Text(
                            "Passer à la caisse",
                            style: GoogleFonts.roboto(
                              fontSize: MediaQuery.of(context).size.width *
                                  AppSizes.fontMedium,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
        }));
  }

  // Modal confirmation for delete
  Future<bool?> _showAlertDelete(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.3,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 50,
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Supprimer cet article de votre panier ?",
                  style: GoogleFonts.roboto(
                    fontSize:
                        MediaQuery.of(context).size.width * AppSizes.fontSmall,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(
                  height: 2,
                  color: Colors.grey,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  "Supprimer",
                  style: GoogleFonts.roboto(
                    fontSize:
                        MediaQuery.of(context).size.width * AppSizes.fontSmall,
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  "Annuler",
                  style: GoogleFonts.roboto(
                    fontSize:
                        MediaQuery.of(context).size.width * AppSizes.fontSmall,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddLocation(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return const AddressLivraison();
      },
    );
  }
}
