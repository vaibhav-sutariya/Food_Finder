import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:no_hunger/components/belowAppbar.dart';
import 'package:no_hunger/constants.dart';
import 'package:no_hunger/screens/main/screens/componets/bottomSlideBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = LatLng(45.521563, -122.677433);

  final Set<Marker> _markers = {};
  final List<FreeFoodLocation> _freeFoodLocations = []; // Example data

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    // Fetch and load nearby free food locations when the widget is initialized
    loadFreeFoodLocations();
  }

  void loadFreeFoodLocations() {
    // Example: Fetch nearby free food locations from your data source
    // Replace this with your actual data fetching logic
    _freeFoodLocations.add(FreeFoodLocation(
      id: '1',
      name: 'Free Food Spot 1',
      latitude: 45.520563,
      longitude: -122.677433,
    ));
    _freeFoodLocations.add(FreeFoodLocation(
      id: '2',
      name: 'Free Food Spot 2',
      latitude: 45.525563,
      longitude: -122.679433,
    ));

    // Add markers for each free food location on the map
    for (var location in _freeFoodLocations) {
      _markers.add(Marker(
        markerId: MarkerId(location.id),
        position: LatLng(location.latitude, location.longitude),
        infoWindow: InfoWindow(
          title: location.name,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));
    }
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: const InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);

    // Add markers for the user's current location
    getUserCurrentLocation().then((value) {
      _markers.add(Marker(
        markerId: const MarkerId("1"),
        position: LatLng(value.latitude, value.longitude),
        infoWindow: const InfoWindow(
          title: 'Your Current Location',
        ),
      ));

      // Center the map on the user's location
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR$error");
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapToolbarEnabled: true,
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            mapType: _currentMapType,
            markers: _markers,
            onCameraMove: _onCameraMove,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            compassEnabled: true,
          ),
          Positioned(
            bottom: 70.0,
            right: 16.0,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: _onMapTypeButtonPressed,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: kPrimaryColor,
                  child: const Icon(Icons.map, size: 35.0),
                ),
                const SizedBox(height: 10.0),
                FloatingActionButton(
                  onPressed: _onAddMarkerButtonPressed,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: kPrimaryColor,
                  child: const Icon(Icons.add_location, size: 35.0),
                ),
                const SizedBox(height: 10.0),
                FloatingActionButton(
                  backgroundColor: kPrimaryColor,
                  onPressed: () async {
                    getUserCurrentLocation().then((value) async {
                      print("${value.latitude} ${value.longitude}");

                      _markers.add(Marker(
                        markerId: const MarkerId("2"),
                        position: LatLng(value.latitude, value.longitude),
                        infoWindow: const InfoWindow(
                          title: 'My Current Location',
                        ),
                      ));

                      CameraPosition cameraPosition = CameraPosition(
                        target: LatLng(value.latitude, value.longitude),
                        zoom: 14,
                      );

                      final GoogleMapController controller =
                          await _controller.future;
                      controller.animateCamera(
                          CameraUpdate.newCameraPosition(cameraPosition));
                      setState(() {});
                    });
                  },
                  child: const Icon(
                    Icons.location_searching,
                    size: 35.0,
                  ),
                ),
              ],
            ),
          ),
          const AddressBox(),
          const BottomSlider(),
        ],
      ),
    );
  }
}

class FreeFoodLocation {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  FreeFoodLocation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}
