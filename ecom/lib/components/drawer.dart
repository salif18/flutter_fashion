import 'package:ecom/providers/auth_provider.dart';
import 'package:ecom/utils/app_size.dart';
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
              child: Column(
            children: [
              Icon(LineIcons.user,
                  size: MediaQuery.of(context).size.width * AppSizes.iconLarge),
              const SizedBox(height: 10),
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
            ],
          )),
          ListTile(
            onTap: () {
              provider.logoutButton();
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
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Center(
                  child: Text(
                "Version 0.0.1",
                style: GoogleFonts.roboto(
                    fontSize:
                        MediaQuery.of(context).size.width * AppSizes.fontSmall,
                    color: Colors.grey[300]),
              )))
        ],
      ),
    );
  }
}
