import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class MapSample extends StatefulWidget {
  const MapSample({Key? key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition _currentCameraPosition = CameraPosition(
    target: LatLng(10, 100), // Default to HCM City coordinates
    zoom: 10.0, // Adjust the zoom level
  );

  Set<Marker> _markers = {}; // Set to hold the markers

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        setState(() {
          _currentCameraPosition = CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 18.0,
          );
          _markers.add(
            Marker(
              markerId: MarkerId("my_location"),
              position: LatLng(position.latitude, position.longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              infoWindow: InfoWindow(
                title: "You are here!",
                snippet: "Custom Marker",
              ),
            ),
          );
        });
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  // Function to handle "Go to My Place" button click
  void _goToMyPlace() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );

      if (_controller.isCompleted) {
        GoogleMapController controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(position.latitude, position.longitude),
          ),
        );
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _currentCameraPosition,
            markers: _markers, // Set of markers to be displayed on the map
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onCameraMove: (CameraPosition position) {
              // Update the camera position dynamically
              _currentCameraPosition = position;
            },
          ),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                _goToMyPlace();
              },
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}

