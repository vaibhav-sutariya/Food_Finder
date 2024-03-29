import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:no_hunger/constants.dart';

class AddressBox extends StatefulWidget {
  const AddressBox({Key? key}) : super(key: key);

  @override
  State<AddressBox> createState() => _AddressBoxState();
}

class _AddressBoxState extends State<AddressBox> {
  Position? _currentPosition;
  String? _currentAddress;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getLocationPermission();
  }

  Future<void> _getLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Show a snackbar to inform the user about the importance of location permission
      final snackBar = SnackBar(
        content: const Text('Location permission is mandatory for this app.'),
        action: SnackBarAction(
          label: 'Grant',
          onPressed: () async {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
              _getLocationPermission();
            } else {
              // User granted permission, proceed to get location
              _getCurrentLocation();
            }
          },
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      // Location permission is already granted, proceed to get location
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });

      // Reverse geocode the coordinates to get the address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Extract the address details
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        _currentAddress =
            "${placemark.subThoroughfare} ${placemark.thoroughfare} "
            "${placemark.subLocality} ${placemark.locality} ${placemark.postalCode} "
            "${placemark.country}";
      } else {
        _currentAddress = "Address not found";
      }

      setState(() {
        _currentAddress = _currentAddress;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
          stops: [0.5, 1.0],
        ),
      ),
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: 30,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isLoading)
                    const CircularProgressIndicator(
                      color: kSecondaryColor,
                    )
                  else if (_currentPosition != null && _currentAddress != null)
                    Text(
                      '$_currentAddress',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
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
