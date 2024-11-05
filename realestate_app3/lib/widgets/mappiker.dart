import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPicker extends StatefulWidget {
  @override
  _MapPickerState createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  GoogleMapController? mapController; // Declare the map controller
  LatLng _currentLatLng =
      LatLng(37.7749, -122.4194); // Default location (San Francisco)

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller; // Assign the controller
    // For example, you can log the controller to make use of it
    print("Map controller initialized");
  }

  void _onCameraMove(CameraPosition position) {
    _currentLatLng = position.target;
  }

  void _confirmLocation() {
    Navigator.pop(context, _currentLatLng); // Pass the selected location back
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _confirmLocation,
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated, // Assign the map created callback
        initialCameraPosition: CameraPosition(
          target: _currentLatLng,
          zoom: 14.0,
        ),
        onCameraMove: _onCameraMove,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
