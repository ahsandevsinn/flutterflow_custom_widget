import 'package:flutter/material.dart';
class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    return ImageWidget(imageUrl: "https://firebasestorage.googleapis.com/v0/b/the-owensboro-app.firebasestorage.app/o/listings%2F1763237997899.jpg?alt=media&token=6b2b1040-51ad-410a-8b8f-97a2aa991ab2",);
  }
}


class ImageWidget extends StatefulWidget {
  final imageUrl;
  const ImageWidget({super.key,this.imageUrl});

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
  borderRadius: BorderRadius.circular(14), // Apply border radius here
  child: Image.network(
    widget.imageUrl,
    fit: BoxFit.fill,
  ),);
  }
}