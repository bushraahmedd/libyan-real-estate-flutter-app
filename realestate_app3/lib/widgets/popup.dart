import 'package:flutter/material.dart';

class SimulationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' خريطه'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
                'assets/images/map_image.png'), // Your static map image
          ),
          Positioned(
            left: 100,
            top: 200,
            child: Icon(
              Icons.location_on,
              color: Colors.red,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
