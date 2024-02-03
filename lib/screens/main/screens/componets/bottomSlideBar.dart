import 'package:flutter/material.dart';
import 'package:no_hunger/constants.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Restaurant {
  final String name;
  final String address;

  Restaurant({required this.name, required this.address});
}

class BottomSlider extends StatefulWidget {
  const BottomSlider({super.key});

  @override
  _BottomSliderState createState() => _BottomSliderState();
}

class _BottomSliderState extends State<BottomSlider> {
  final PanelController _panelController = PanelController();

  List<Restaurant> restaurants = [
    Restaurant(name: 'Restaurant 1', address: 'Address 1'),
    Restaurant(name: 'Restaurant 2', address: 'Address 2'),
    Restaurant(name: 'Restaurant 3', address: 'Address 3'),
    Restaurant(name: 'Restaurant 3', address: 'Address 3'),
    Restaurant(name: 'Restaurant 3', address: 'Address 3'),
    Restaurant(name: 'Restaurant 3', address: 'Address 3'),
    Restaurant(name: 'Restaurant 3', address: 'Address 3'),
    Restaurant(name: 'Restaurant 3', address: 'Address 3'),
    Restaurant(name: 'Restaurant 3', address: 'Address 3'),
    Restaurant(name: 'Restaurant 3', address: 'Address 3'),
    Restaurant(name: 'Restaurant 3', address: 'Address 3'),
    Restaurant(name: 'Restaurant 3', address: 'Address 3'),
    // Add more restaurants as needed
  ];

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: _panelController,
      // maxHeight: MediaQuery.of(context).size.height * 0.8,
      minHeight: 60,
      panel: buildPanel(),
      isDraggable: true,
      parallaxEnabled: true,
      defaultPanelState: PanelState.CLOSED,
      collapsed: buildCollapsedPanel(),
    );
  }

  Widget buildPanel() {
    return Container(
      color: Colors.orangeAccent,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Restaurants',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(restaurants[index].name),
                  subtitle: Text(restaurants[index].address),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Handle direction button press
                      print(
                          'Directions pressed for ${restaurants[index].name}');
                    },
                    child: const Text('Directions'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCollapsedPanel() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      child: const Center(
        child: Column(
          children: [
            Icon(Icons.drag_handle, color: Colors.black),
            Text('Restaurants', style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
