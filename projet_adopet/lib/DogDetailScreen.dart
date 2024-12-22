import 'package:flutter/material.dart';
import 'models/Dog.dart';

class DogDetailScreen extends StatelessWidget {
  final Dog dog;

  DogDetailScreen({required this.dog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          dog.name.isNotEmpty ? dog.name : "Unknown Dog",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 300,
                  color: Colors.blue.shade50,
                  child: dog.image.isNotEmpty
                      ? Image.network(
                    "http://192.168.1.12:5000${dog.image}",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(Icons.broken_image,
                            size: 100, color: Colors.grey),
                      );
                    },
                  )
                      : Center(
                    child: Icon(Icons.image, size: 100, color: Colors.grey),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 16,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dog.name.isNotEmpty ? dog.name : "Unknown Dog",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${dog.age} yrs | ${dog.gender} | ${dog.color.isNotEmpty ? dog.color : "Unknown"}',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // About Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Me',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    dog.about.isNotEmpty
                        ? dog.about
                        : "No description available.",
                    style: TextStyle(color: Colors.grey.shade600, height: 1.5),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  QuickInfoCard(title: "Age", value: "${dog.age} yrs"),
                  QuickInfoCard(
                      title: "Color",
                      value: dog.color.isNotEmpty ? dog.color : "Unknown"),
                  QuickInfoCard(title: "Weight", value: "${dog.weight} kg"),
                ],
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class QuickInfoCard extends StatelessWidget {
  final String title;
  final String value;

  const QuickInfoCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
