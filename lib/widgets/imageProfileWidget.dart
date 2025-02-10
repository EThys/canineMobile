import 'package:canineappadmin/widgets/ZoomableImageScreen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageProfileWidget extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onClicked;

  const ImageProfileWidget({
    Key? key,
    required this.imageUrl,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: buildImage(context),
    );
  }

  Widget buildImage(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12), // Coins arrondis
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ZoomableImageScreen(imageUrl: imageUrl),
              ),
            );
          },
          child: Hero(
            tag: 'profile-image',
            child: imageUrl.isNotEmpty
                ? CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: 138,
              height: 128,
              placeholder: (context, url) => SizedBox(
                width: 128,
                height: 128,
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => SizedBox(
                width: 128,
                height: 128,
                child: Center(
                  child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
                ),
              ),
            )
                : SizedBox(
              width: 128,
              height: 128,
              child: Center(
                child: Icon(
                  Icons.image_not_supported,
                  color: Colors.white,
                  size: 80,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
