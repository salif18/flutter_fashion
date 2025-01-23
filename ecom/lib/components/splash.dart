import 'dart:async';

import 'package:ecom/routes.dart';
import 'package:ecom/utils/app_color.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class SplashWidget extends StatefulWidget {
  const SplashWidget({super.key});

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {

   @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 5),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const Routes())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrincal,
      body: LayoutBuilder(builder: (context, constraints) {
        return AnimatedSwitcher(
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          duration: const Duration(seconds: 5),
          child: Container(
            padding: const EdgeInsets.only(top: 50),
            height: constraints.maxHeight,
            alignment: Alignment.center,
            child: Center(
              key: UniqueKey(),
              child:
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                              image: AssetImage("assets/logos/logo1.jpg"),
                              fit: BoxFit.contain)
                              ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 8.0),
                    //   child: SizedBox(
                    //       child: RichText(
                    //           text: TextSpan(children: [
                    //     TextSpan(
                    //       text: "H-",
                    //       style: GoogleFonts.roboto(
                    //         fontSize: 28,
                    //         fontWeight: FontWeight.w600,
                    //         color: const Color(0xff2fc0f2),
                    //       ),
                    //     ),
                    //     TextSpan(
                    //       text: "Fashion",
                    //       style: GoogleFonts.roboto(
                    //         fontSize: 28,
                    //         fontWeight: FontWeight.w600,
                    //         color: const Color.fromARGB(255, 255, 123, 0),
                    //       ),
                    //     ),
                    //   ]))),
                    // ),
                  
                ),
              
            ),
        );
      }),
    );
  }
}