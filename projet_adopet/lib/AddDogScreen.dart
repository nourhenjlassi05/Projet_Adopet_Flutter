import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'DogService.dart';

class AddDogScreen extends StatefulWidget {
  @override
  _AddDogScreenState createState() => _AddDogScreenState();
}

class _AddDogScreenState extends State<AddDogScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  File? _selectedImage;
  Uint8List? _webImageBytes;

  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImageBytes = Uint8List.fromList(bytes);
        });
      } else {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final dogData = {
        "name": nameController.text,
        "age": double.tryParse(ageController.text) ?? 0.0,
        "gender": genderController.text,
        "color": colorController.text,
        "weight": double.tryParse(weightController.text) ?? 0.0,
        "location": locationController.text,
        "about": aboutController.text,
      };

      try {
        await DogService.addDog(dogData, _selectedImage, _webImageBytes);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Dog added successfully!")),
        );
        Navigator.pop(context);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add dog: $error")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Palette de couleurs adaptée
    final Color primaryColor = Color(0xFFA1887F); // Marron plus clair
    final Color secondaryColor = Color(0xFFD7CCC8); // Beige clair
    final Color backgroundColor = Color(0xFF5D4037); // Marron foncé

    return Scaffold(
      appBar: AppBar(
        title: Text("Add a Dog"),
        backgroundColor: primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Chemin de votre image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add a New Dog",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField("Name", nameController, primaryColor),
                        _buildTextField("Age", ageController, primaryColor,
                            inputType: TextInputType.number),
                        _buildTextField("Gender", genderController, primaryColor),
                        _buildTextField("Color", colorController, primaryColor),
                        _buildTextField("Weight", weightController, primaryColor,
                            inputType: TextInputType.number),
                        _buildTextField("Location", locationController, primaryColor),
                        _buildTextField("About", aboutController, primaryColor,
                            maxLines: 3),
                        SizedBox(height: 20),
                        _buildImagePicker(),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _submitForm,
                          icon: Icon(Icons.add),
                          label: Text("Add Dog"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor, // Marron plus clair
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      Color primaryColor,
      {TextInputType inputType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: primaryColor),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
        keyboardType: inputType,
        maxLines: maxLines,
        validator: (value) =>
        value!.isEmpty ? "Enter $label" : null,
      ),
    );
  }

  Widget _buildImagePicker() {
    return InkWell(
      onTap: _pickImage,
      splashColor: Colors.brown.withOpacity(0.5),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
          image: _webImageBytes != null || _selectedImage != null
              ? DecorationImage(
            image: kIsWeb
                ? MemoryImage(_webImageBytes!)
                : FileImage(_selectedImage!) as ImageProvider,
            fit: BoxFit.cover,
          )
              : null,
        ),
        child: _webImageBytes == null && _selectedImage == null
            ? Icon(Icons.camera_alt, size: 50, color: Colors.grey)
            : null,
      ),
    );
  }
}
