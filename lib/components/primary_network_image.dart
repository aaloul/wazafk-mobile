import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/res/AppIcons.dart';

class PrimaryNetworkImage extends StatelessWidget {
  const PrimaryNetworkImage(
      {super.key,
      required this.url,
      required this.width,
      required this.height,
      this.fit,
      this.errorWidget,
      this.placeholderWidget,
      this.placeholder,
      this.errorBorderRadius});

  final String url;
  final String? placeholder;
  final double? width;
  final double? height;
  final double? errorBorderRadius;
  final BoxFit? fit;
  final Widget? placeholderWidget;
  final Widget? errorWidget;

  String getExtensionFromUrl(String url) {
    Uri uri = Uri.parse(url); // Parse the URL
    String path = uri.path; // Get the path from the URL
    String extension = path.split('.').last; // Extract the file extension

    return extension; // Return the extension
  }

  @override
  Widget build(BuildContext context) {
    return getExtensionFromUrl(url.toString()).toString().contains('svg')
        ? SvgPicture.network(
            width: width ?? double.infinity,
            height: height ?? double.infinity,
            url.toString(),
            fit: fit ?? BoxFit.fitWidth,
            placeholderBuilder: (BuildContext context) =>
                placeholderWidget ??
                SizedBox(
                  width: width ?? double.infinity,
                  height: height ?? double.infinity,
                ),
          )
        : CachedNetworkImage(
            height: height,
            width: width,
            imageUrl: url.toString(),
            placeholder: (context, url) =>
                placeholderWidget ??
                SizedBox(
                  width: width ?? double.infinity,
                  height: height ?? double.infinity,
                ),
            errorWidget: (context, url, error) => ClipRRect(
              borderRadius: BorderRadius.circular(errorBorderRadius ?? 6),
              child: errorWidget ??
                  Image.asset(
                    AppIcons.placeholder,
                    height: height ?? double.infinity,
                    width: width ?? double.infinity,
                    fit: BoxFit.cover,
                  ),
            ),
            fit: fit ?? BoxFit.fitWidth,
          );
  }
}
