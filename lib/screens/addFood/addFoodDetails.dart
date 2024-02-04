import 'package:flutter/material.dart';
import 'package:no_hunger/constants.dart';
import 'package:no_hunger/screens/addFood/componets/FoodDetailsForm.dart';

class AddFoodDetails extends StatefulWidget {
  const AddFoodDetails({super.key});

  @override
  State<AddFoodDetails> createState() => _AddFoodDetailsState();
}

class _AddFoodDetailsState extends State<AddFoodDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        title: const Text(
          'Food Finder',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            children: [
              AddFoodDetailsForm(),
            ],
          ),
        ),
      ),
    );
  }
}
