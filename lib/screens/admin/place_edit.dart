import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_plan/services/api/api_service.dart';
import 'package:travel_plan/theme/res/palette_theme.dart';

class PlaceEdit extends StatefulWidget {
  final String placeId;

  PlaceEdit({
    Key? key,
    required this.placeId,
  }) : super(key: key);

  @override
  _PlaceEditState createState() => _PlaceEditState();
}

class _PlaceEditState extends State<PlaceEdit> {
  @override
  void initState() {
    super.initState();
  }

  bool _isDataInitialized = false;
  bool _recomand = false;

  final _nameController = TextEditingController();
  final _provinceController = TextEditingController();
  final _districtController = TextEditingController();
  final _locationController = TextEditingController();
  final _detailController = TextEditingController();
  final ApiService apiService = ApiService();

  File? _selectedImage;
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _delete() async {
    try {
      await pb.collection('places').delete(widget.placeId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Deleted successfully!')),
      );
    } catch (e) {
      print('Err: $e');
    }
  }

  // Save changes after validating
  Future<void> _saveChanges() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('place name cannot be empty!')),
      );
      return;
    }
    if (_provinceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Province cannot be empty!')),
      );
      return;
    }
    if (_districtController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('District name cannot be empty!')),
      );
      return;
    }
    final updatedData = <String, dynamic>{
      "title": _nameController.text,
      "detial": _detailController.text,
      "province": _provinceController.text,
      "district": _districtController.text,
      "location_place": _locationController.text,
      "recomand": _recomand,
    };

    try {
      await apiService.updatePlace(widget.placeId, updatedData, _selectedImage);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Updated successfully!')),
      );
    } catch (e) {
      log('ERR: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: apiService.getPlaceDetails(widget.placeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error fetching  data.'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No  data available.'));
          }

          final place = snapshot.data!;

          // Initialize data only once
          if (!_isDataInitialized) {
            _nameController.text = place.title;
            _provinceController.text = place.province;
            _districtController.text = place.district;
            _locationController.text = place.locationPlace;
            _detailController.text = place.detail;
            _recomand = place.recommend;
            _isDataInitialized = true;
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Update',
                style: TextStyle(
                  color: Color(0xFF201A09),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // DELete buttond
                    _showPopup(context);
                  },
                ),
              ],
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: _selectedImage != null
                                  ? FileImage(_selectedImage!)
                                  : place.img.isNotEmpty
                                      ? NetworkImage(
                                          "${pb.baseURL}/api/files/pbc_3384545563/${place.id}/${place.img}")
                                      : NetworkImage(
                                              'https://via.placeholder.com/150')
                                          as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ElevatedButton(
                              onPressed: _pickImage,
                              child: IconButton(
                                onPressed: _pickImage,
                                icon:
                                    Icon(Icons.image, color: PaletteTheme.blue),
                                iconSize: 30,
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 7),
                                backgroundColor: PaletteTheme.grey200,
                                textStyle: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 8),

                  SizedBox(height: 16),

                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                  ),

                  SizedBox(height: 16),
                  TextField(
                    controller: _provinceController,
                    decoration: InputDecoration(
                      labelText: 'province',
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                  ),

                  SizedBox(height: 16),
                  TextField(
                    controller: _districtController,
                    decoration: InputDecoration(
                      labelText: 'District',
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                  ),

                  SizedBox(height: 16),
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Location_link',
                      prefixIcon: Icon(Icons.location_on),
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                  ),

                  // Bio Text Area

                  TextField(
                    controller: _detailController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Make detail of place',
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                  ),

                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Make recommend',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 16),
                      Switch(
                        value: _recomand,
                        onChanged: (bool newValue) {
                          setState(() {
                            _recomand = newValue;
                          });
                        },
                        activeColor: Colors.blue,
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey.shade300,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Save Changes Button
                  Center(
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      child: Text(
                        'Save change',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        backgroundColor: PaletteTheme.blue,
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

//POP UP OPTIONS
  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text('Are you sure!!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: PaletteTheme.blue),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Delete Button
              ElevatedButton(
                onPressed: _delete,
                style: ElevatedButton.styleFrom(
                    backgroundColor: PaletteTheme.grey200),
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
