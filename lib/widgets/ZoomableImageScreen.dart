import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ZoomableImageScreen extends StatelessWidget {
  final String imageUrl;

  const ZoomableImageScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Hero(
          tag: 'profile-image',
          child: InteractiveViewer(
            panEnabled: true,
            boundaryMargin: EdgeInsets.all(100),
            minScale: 1,
            maxScale: 4,
            child: imageUrl.isNotEmpty
                ? CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Center(
                child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
              ),
            )
                : Text(
              "Aucune image disponible",
              style: TextStyle(fontSize: 20, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
