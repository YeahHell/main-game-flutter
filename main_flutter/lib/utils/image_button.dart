import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final VoidCallback onTap;
  final double borderRadius;

  const ImageButton({
    super.key,
    required this.imageUrl,
    required this.onTap,
    this.width = 300,
    this.height = 210,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.network(
          imageUrl,
          width: width,
          height: height,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: width,
              height: height,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: width,
              height: height,
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: Icon(Icons.error, color: Colors.red),
            );
          },
        ),
      ),
    );
  }
}
