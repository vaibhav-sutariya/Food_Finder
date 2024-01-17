import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = LatLng(45.521563, -122.677433);

  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;

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
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
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
            compassEnabled: true,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: _onMapTypeButtonPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.map, size: 36.0),
                  ),
                  const SizedBox(height: 16.0),
                  FloatingActionButton(
                    onPressed: _onAddMarkerButtonPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.add_location, size: 36.0),
                  ),
                  const SizedBox(height: 16.0),
                  FloatingActionButton(
                    backgroundColor: Colors.green,

                    onPressed: () async {
                      getUserCurrentLocation().then((value) async {
                        print(value.latitude.toString() +
                            " " +
                            value.longitude.toString());

                        // marker added for current users location
                        _markers.add(Marker(
                          markerId: MarkerId("2"),
                          position: LatLng(value.latitude, value.longitude),
                          infoWindow: InfoWindow(
                            title: 'My Current Location',
                          ),
                        ));

                        // specified current users location
                        CameraPosition cameraPosition = new CameraPosition(
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
                    child: Icon(Icons.local_activity, size: 36.0,),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
