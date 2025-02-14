// import 'package:ecom/providers/auth_provider.dart';
import 'package:ecom/utils/app_color.dart';
import 'package:ecom/utils/app_size.dart';
import 'package:ecom/views/achats/achat.dart';
// import 'package:ecom/views/auth/login_view.dart';
import 'package:ecom/views/home/home.dart';
import 'package:ecom/views/favorites/favorites.dart';
import 'package:ecom/views/promo/promo.dart';
import 'package:ecom/views/store/stores.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';

class Routes extends StatefulWidget {
  const Routes({super.key});

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          // Consumer<AuthProvider>(
          //   builder: (context, provider, child) {
          //     // Si le token est présent, afficher les vues de l'application
          //     if (provider.token.isNotEmpty) {
          // return
          <Widget>[
        const HomeView(),
        const StoresView(categoSelected: ""),
        const PromoView(),
        const AchatView(),
        const FavoritesView()
      ][_currentIndex],
      //     } else {
      //       // Si pas de token, afficher la page de connexion
      //       return const LoginView();
      //     }
      //   },
      // ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context ,constraints){
          return  Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20), topRight: Radius.circular(20))),
            child:
                // Consumer<AuthProvider>(builder: (context, provider, child) {
                // if (provider.token.isNotEmpty) {
                // return
                _buildBottomNavigation(constraints)
            // } else {
            //   // Si pas de token, ne rien afficher
            //   return const SizedBox.shrink();
            // }
            // }
            );
        },
        
      ),
      // )
    );
  }

  Widget _buildBottomNavigation(constraints) {
    return SizedBox(
      height:  constraints.maxWidth * AppSizes.converValueToadapter(context, 80),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.deepOrange, // Couleur pour l'élément actif
        unselectedItemColor: Colors.grey, // Couleur pour les éléments inactifs
        backgroundColor: AppColors.backgroundPrincal,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_filled,
                size: constraints.maxWidth * AppSizes.converValueToadapter(context, 24),
              ),
              label: "Accueil"),
          BottomNavigationBarItem(
              icon: Icon(
                Mdi.textSearch,
                size: constraints.maxWidth * AppSizes.converValueToadapter(context, 24),
              ),
              label: "Boutique"),
          BottomNavigationBarItem(
              icon: Icon(
                Mdi.emailSeal,
                size:  constraints.maxWidth * AppSizes.converValueToadapter(context, 24),
              ),
              label: "Promo"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.shopify_sharp,
                size:  constraints.maxWidth * AppSizes.converValueToadapter(context, 24),
              ),
              label: "Achats"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                size:  constraints.maxWidth * AppSizes.converValueToadapter(context, 24),
              ),
              label: "Favoris"),
        ],
      ),
    );
  }
}
