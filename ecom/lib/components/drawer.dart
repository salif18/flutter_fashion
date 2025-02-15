import 'package:ecom/providers/auth_provider.dart';
import 'package:ecom/utils/app_size.dart';
import 'package:ecom/views/auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});
  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              child: Image.asset("assets/logos/logo1.jpg",width:MediaQuery.of(context).size.width*0.5)),
              Container(
                child: Column(
                  children: [
              //    Icon(LineIcons.user,
              //     size: MediaQuery.of(context).size.width * AppSizes.iconLarge),
              // const SizedBox(height: 10),
              Text(
                provider.userName,
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    fontSize:
                        MediaQuery.of(context).size.width * AppSizes.fontSmall),
              ),
              // const SizedBox(height: 5),
              Text(
                provider.userEmail,
                style: GoogleFonts.roboto(
                    fontSize:
                        MediaQuery.of(context).size.width * AppSizes.fontSmall),
              )
              ],),),
               const SizedBox(height: 50),
           ListTile(
            onTap: () {
             
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.language_rounded,
                      size: MediaQuery.of(context).size.width * AppSizes.iconLarge,
                    ),
                    const SizedBox(width: 20),
                Text(
                  "Change language",
                  style: GoogleFonts.roboto(
                      fontSize: MediaQuery.of(context).size.width *
                          AppSizes.fontSmall),
                ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: MediaQuery.of(context).size.width * AppSizes.iconMedium,
                ),
              ],
            ),
          ),
           ListTile(
            onTap: () {
              
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.notifications_none_outlined,
                      size: MediaQuery.of(context).size.width * AppSizes.iconLarge,
                    ),
                    const SizedBox(width: 20),
                Text(
                  "Notifications",
                  style: GoogleFonts.roboto(
                      fontSize: MediaQuery.of(context).size.width *
                          AppSizes.fontSmall),
                ),
                  ],
                ),
                 Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: MediaQuery.of(context).size.width * AppSizes.iconMedium,
                ),
              ],
            ),
          ),
          if(provider.token.isEmpty)
           ListTile(
            onTap: () {
             Navigator.push(context, MaterialPageRoute(builder: (context) => LoginView()));
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.login,
                      size: MediaQuery.of(context).size.width * AppSizes.iconLarge,
                    ),
                      const SizedBox(width: 20),
                Text(
                  "Login",
                  style: GoogleFonts.roboto(
                      fontSize: MediaQuery.of(context).size.width *
                          AppSizes.fontSmall),
                )
                  ],
                ),
               Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: MediaQuery.of(context).size.width * AppSizes.iconMedium,
                ),
              ],
            ),
          ),
          if(provider.token.isNotEmpty)
          ListTile(
            onTap: () {
              provider.logoutButton();
              Navigator.pop(context);
            },
            title: Row(
              children: [
                Icon(
                  Icons.logout,
                  size: MediaQuery.of(context).size.width * AppSizes.iconLarge,
                ),
                const SizedBox(width: 20),
                Text(
                  "Se deconnecter",
                  style: GoogleFonts.roboto(
                      fontSize: MediaQuery.of(context).size.width *
                          AppSizes.fontSmall),
                )
              ],
            ),
          ),
          const SizedBox(height: 200,),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                children: [
              
                   Center(
                      child: Text(
                    "Developper Salif Moctar Konaté",
                    style: GoogleFonts.roboto(
                        fontSize:
                            MediaQuery.of(context).size.width * AppSizes.fontSmall,
                        color: Colors.grey[300]),
                  )),
                   Center(
                      child: Text(
                    "+223 78 30 32 08",
                    style: GoogleFonts.roboto(
                        fontSize:
                            MediaQuery.of(context).size.width * AppSizes.fontSmall,
                        color: Colors.grey[300]),
                  )),
                    Center(
                      child: Text(
                    "Version 0.0.1",
                    style: GoogleFonts.roboto(
                        fontSize:
                            MediaQuery.of(context).size.width * AppSizes.fontSmall,
                        color: Colors.grey[300]),
                  )),
                ],
              ))
        ],
      ),
    );
  }
}
