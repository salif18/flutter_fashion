import 'package:ecom/providers/auth_provider.dart';
import 'package:ecom/providers/cart_provider.dart';
import 'package:ecom/utils/app_color.dart';
import 'package:ecom/utils/app_size.dart';
import 'package:ecom/views/auth/login_view.dart';
import 'package:ecom/views/cart/widgets/address_livraison.dart';
import 'package:ecom/views/cart/widgets/cart_emptty.dart';
import 'package:ecom/views/cart/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        body: LayoutBuilder(
          builder: (context,constraints){
return CustomScrollView(
            slivers: [
              // AppBar
              SliverAppBar(
                toolbarHeight: constraints.maxWidth * AppSizes.converValueToadapter(context, 50),
                backgroundColor: AppColors.backgroundPrincal,
                pinned: true,
                floating: true,
                centerTitle: true,
                title: Text(
                  "Mon panier",
                  style: GoogleFonts.roboto(
                    fontSize:
                        constraints.maxWidth * AppSizes.converValueToadapter(context, 16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // actions: [
                //   Consumer<CartProvider>(
                //     builder: (context, provider, child) {
                //       return Stack(
                //         children: [
                //           Icon(
                //             Icons.shopping_cart_outlined,
                //             size: constraints.maxWidth * AppSizes.converValueToadapter(context, 30),
                //           ),
                //           if (provider.cart.isNotEmpty)
                //             Positioned(
                //               left:  constraints.maxWidth * AppSizes.converValueToadapter(context, 10),
                //               bottom:  constraints.maxWidth * AppSizes.converValueToadapter(context, 10),
                //               child: Badge.count(
                //                 count: provider.nombreArticles,
                //                 largeSize:  constraints.maxWidth * AppSizes.converValueToadapter(context, 20) / 2,
                //                 backgroundColor: Colors.deepOrange,
                //                 textStyle: GoogleFonts.roboto(
                //                   fontSize:  constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
                //                   fontWeight: FontWeight.bold,
                //                   color: Colors.white,
                //                 ),
                //               ),
                //             ),
                //         ],
                //       );
                //     },
                //   ),
                //   SizedBox(width:  constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                // ],
              ),
              // Body content
              Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  final cart = cartProvider.cart;
                        
                  if (cart.isEmpty) {
                    return SliverToBoxAdapter(child:EmptyCart(constraints: constraints,));
                  }
                        
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * AppSizes.converValueToadapter(context, 16),vertical: constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index){
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
                              return await _showAlertDelete(context,constraints);
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                              decoration: BoxDecoration(
                                color: AppColors.banerBtnNavigatorBackground,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 16)),
                                  bottomLeft: Radius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 16)),
                                ),
                              ),
                              child: Icon(
                                Icons.delete_rounded,
                                size: constraints.maxWidth * AppSizes.converValueToadapter(context, 24),
                                color: Colors.white,
                              ),
                            ),
                            child: MyCard(item: item,constraints:constraints),
                          );
                        },
                        childCount:cart.length, 
                      ),
                     
                    ),
                  );
                },
              ),
            ],
          );
          },
          
        ),
        bottomNavigationBar:
            Consumer<CartProvider>(builder: (context, cartProvider, child) {
          List<CartItem> cart = cartProvider.cart;
          double total = cartProvider.total;
          return cart.isEmpty
              ? const SizedBox.shrink()
              : LayoutBuilder(
                builder: (context, constraints){
                  return Container(
                    padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 16)),
                        topRight: Radius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 16)),
                      ),
                    ),
                    width: double.infinity,
                    height: constraints.maxWidth * AppSizes.converValueToadapter(context, 180),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: constraints.maxWidth * AppSizes.converValueToadapter(context, 5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Nombre d'articles",
                                style: GoogleFonts.roboto(
                                  fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 16),
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF1D1A30),
                                ),
                              ),
                              Text(
                                "${cartProvider.nombreArticles}",
                                style: GoogleFonts.roboto(
                                  fontSize:constraints.maxWidth * AppSizes.converValueToadapter(context, 16),
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1D1A30),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: constraints.maxWidth * AppSizes.converValueToadapter(context, 5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: GoogleFonts.roboto(
                                  fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "$total FCFA",
                                style: GoogleFonts.roboto(
                                  fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
                          child: Consumer<AuthProvider>(
                            builder: (context, provider, child) {
                              return ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orangeAccent,
                                  minimumSize: Size(constraints.maxWidth * AppSizes.converValueToadapter(context, 400), constraints.maxWidth * AppSizes.converValueToadapter(context, 40)),
                                ),
                                icon: Icon(
                                  provider.token.isNotEmpty ?
                                  Icons.monetization_on : Icons.login,
                                  size: constraints.maxWidth * AppSizes.converValueToadapter(context, 20),
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  if (provider.token.isNotEmpty) {
                                    _showAddLocation(context,constraints);
                                  } else {
                                    // 🔹 Stocker la page actuelle avant de naviguer
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString('currentPage', 'cartView');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginView()),
                                    );
                                  }
                                },
                                label: Text(
                                  provider.token.isNotEmpty ? "Passer à la caisse" : "Se connecter pour acheter",
                                  style: GoogleFonts.roboto(
                                    fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  );
                },
                
              );
        }));
  }

  // Modal confirmation for delete
  Future<bool?> _showAlertDelete(BuildContext context, constraints) {
    return showModalBottomSheet<bool>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: constraints.maxWidth ,
          height:constraints.maxWidth * AppSizes.converValueToadapter(context, 200),
          padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: constraints.maxWidth * AppSizes.converValueToadapter(context, 40),
                padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 10)),
                child: Text(
                  "Supprimer cet article de votre panier ?",
                  style: GoogleFonts.roboto(
                    fontSize:
                       constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
                child: Divider(
                  height: 2,
                  color: Colors.grey,
                ),
              ),
              TextButton(
                // style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  "Supprimer",
                  style: GoogleFonts.roboto(
                    fontSize:
                       constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                    color: Colors.red,
                  ),
                ),
              ),
              TextButton(
                // style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  "Annuler",
                  style: GoogleFonts.roboto(
                    fontSize:
                       constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddLocation(BuildContext context ,constraints) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return AddressLivraison(constraints: constraints,);
      },
    );
  }
}
