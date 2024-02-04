import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';

class AddFoodDetailsForm extends StatefulWidget {
  const AddFoodDetailsForm({super.key});

  @override
  State<AddFoodDetailsForm> createState() => _AddFoodDetailsFormState();
}

class _AddFoodDetailsFormState extends State<AddFoodDetailsForm> {
  TextEditingController FnameController = TextEditingController();
  TextEditingController LnameController = TextEditingController();
  TextEditingController PhoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  File? profilepic;

  String? userId;

  void saveUser(String userId) async {
    String Fname = FnameController.text.trim();
    String Lname = LnameController.text.trim();
    String phone = PhoneController.text.trim();
    String address = addressController.text.trim();

    // int age = int.parse(ageString);

    // FnameController.clear();
    // LnameController.clear();
    // addressController.clear();

    if (Fname != "" &&
        Lname != "" &&
        phone != "" &&
        address != "" &&
        profilepic != null) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("profilepictures")
          .child(const Uuid().v1())
          .putFile(profilepic!);

      StreamSubscription taskSubscription =
          uploadTask.snapshotEvents.listen((snapshot) {
        double percentage =
            snapshot.bytesTransferred / snapshot.totalBytes * 100;
        log(percentage.toString());
      });

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print(downloadUrl);
      taskSubscription.cancel();

      Map<String, dynamic> userData = {
        "profilepic": downloadUrl,
        "Fname": Fname,
        "Lname": Lname,
        "phone": phone,
        "address": address,
        // "samplearray": [name, email, address]
      };
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .set(userData);

      // FirebaseFirestore.instance.collection("users").add(userData);
      log("User Created");
    } else {
      log("please fill all the fields");
    }
    setState(() {
      profilepic = null;
    });
  }

  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? address;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Stack(
            children: [
              CupertinoButton(
                padding: EdgeInsetsDirectional.zero,
                onPressed: () async {
                  XFile? selectedImage = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);

                  if (selectedImage != null) {
                    File convertedFile = File(selectedImage.path);
                    setState(() {
                      profilepic = convertedFile;
                    });
                    log("image selected");
                  } else {
                    log("No image Selected");
                  }
                },
                child: CircleAvatar(
                  backgroundImage:
                      (profilepic != null) ? FileImage(profilepic!) : null,
                  radius: 50,
                  backgroundColor: Colors.grey,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: const BorderSide(color: Colors.white),
                      ),
                      backgroundColor: const Color(0xFFF5F6F9),
                    ),
                    onPressed: () async {
                      XFile? selectedImage = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);

                      if (selectedImage != null) {
                        File convertedFile = File(selectedImage.path);
                        setState(() {
                          profilepic = convertedFile;
                        });
                        log("image selected");
                      } else {
                        log("No image Selected");
                      }
                    },
                    child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: FnameController,
            onSaved: (newValue) => firstName = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kNamelNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "First Name",
              hintText: "Enter your first name",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon:
                  const CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: kTextColor),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: LnameController,
            onSaved: (newValue) => lastName = newValue,
            decoration: InputDecoration(
              labelText: "Last Name",
              hintText: "Enter your last name",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon:
                  const CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: kTextColor),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: PhoneController,
            keyboardType: TextInputType.phone,
            onSaved: (newValue) => phoneNumber = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPhoneNumberNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPhoneNumberNullError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Phone Number",
              hintText: "Enter your phone number",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon:
                  const CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: kTextColor),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: addressController,
            onSaved: (newValue) => address = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kAddressNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kAddressNullError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Address",
              hintText: "Enter your address",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const CustomSurffixIcon(
                  svgIcon: "assets/icons/Location point.svg"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: kTextColor),
              ),
            ),
          ),
          FormError(errors: errors),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (profilepic == null) {
                log("Please select a profile picture");
              } else {
                User? user = FirebaseAuth.instance.currentUser;

                if (user != null) {
                  String userId = user.uid;
                  saveUser(userId);

                  FirebaseFirestore.instance
                      .collection("users")
                      .get()
                      .then((querySnapshot) {
                    if (querySnapshot.docs.isNotEmpty) {
                      // Navigator.pushNamed(context, SignInSuccessScreen.routeName);
                      // Navigator.of(context)
                      //     .pushNamed(SignInSuccessScreen.routeName);
                    }
                  });
                }
              }
            },
            child: const Text(
              "Continue",
            ),
          ),
        ],
      ),
    );
  }
}
