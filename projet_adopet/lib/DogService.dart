import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'models/Dog.dart';

class DogService {
  static const String baseUrl = "http://192.168.1.12:5000/dogs";


  static Future<List<Dog>> fetchDogs() async {
    final response = await http.get(Uri.parse(baseUrl));
    print(response
        .body);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Dog.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load dogs");
    }
  }


  static Future<void> addDog(Map<String, dynamic> dogData, File? image, Uint8List? webImage) async {
    try {
      var uri = Uri.parse(baseUrl);
      var request = http.MultipartRequest('POST', uri);


      dogData.forEach((key, value) {
        request.fields[key] = value.toString();
      });


      if (image != null) {

        request.files.add(await http.MultipartFile.fromPath(
          'image',
          image.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      } else if (webImage != null) {

        request.files.add(http.MultipartFile.fromBytes(
          'image',
          webImage,
          filename: 'image.jpg',
          contentType: MediaType('image', 'jpeg'),
        ));
      }


      var response = await request.send();
      if (response.statusCode == 201) {
        print("Dog added successfully");
      } else {

        final responseBody = await response.stream.bytesToString();
        print("Failed to add dog, status code: ${response.statusCode}");
        print("Response body: $responseBody");
        throw Exception("Failed to add dog");
      }
    } catch (e) {

      print("Error: $e");
      throw Exception("Error uploading dog data");
    }
  }


  static Future<void> editDog({
    required String id,
    required Map<String, dynamic> data,
    File? imageFile,
    Uint8List? webImageBytes,
  }) async {
    final uri = Uri.parse("$baseUrl/$id");

    var request = http.MultipartRequest('PUT', uri);
    data.forEach((key, value) {
      print("Field $key: $value");
      request.fields[key] = value.toString();
    });

    if (imageFile != null) {
      print("Sending image file: ${imageFile.path}");
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    } else if (webImageBytes != null) {
      print("Sending web image bytes");
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        webImageBytes,
        filename: 'image.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    try {
      final response = await request.send();
      if (response.statusCode != 200) {
        final responseBody = await response.stream.bytesToString();
        print("Error Response Body: $responseBody");
        throw Exception(
            "Failed to update dog. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in editDog: $e");
      throw Exception("Error updating dog");
    }
  }




  static Future<void> deleteDog(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete dog");
    }
  }

}
