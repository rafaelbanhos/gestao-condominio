import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';

class ImageDetailsScreen extends StatelessWidget {
  String image;

  ImageDetailsScreen(this.image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes avançados'),
        centerTitle: true,
          backgroundColor: Color.fromRGBO(8, 86, 151, 1),
      ),
      body: Container(
        child: ZoomableWidget(
          panLimit: 1.0,
          maxScale: 2.0,
          minScale: 0.5,
          singleFingerPan: true,
          multiFingersPan: false,
          enableRotate: true,
          child: Image(
            image: NetworkImage(image),
          ),
          zoomSteps: 3,
        ),
      ),
    );
  }
}
