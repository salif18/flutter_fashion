import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double height;
  final double width;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  const ShimmerWidget({
    Key? key,
    required this.width,
     required this.height,
    this.margin,
    this.padding,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container( 
        width: width,
        height: height,
        margin: margin ?? EdgeInsets.all(8), // ✅ Correction : EdgeInsets au lieu de double
        padding: padding ?? EdgeInsets.all(8), // ✅ Correction : EdgeInsets au lieu de double
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}
