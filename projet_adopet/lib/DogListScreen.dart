import 'package:flutter/material.dart';
import 'DogService.dart';
import 'DogDetailScreen.dart';
import 'AddDogScreen.dart';
import 'EditDogScreen.dart';
import 'models/Dog.dart';

class DogListScreen extends StatefulWidget {
  @override
  _DogListScreenState createState() => _DogListScreenState();
}

class _DogListScreenState extends State<DogListScreen> {
  late Future<List<Dog>> futureDogs;

  @override
  void initState() {
    super.initState();
    fetchDogs();
  }

  void fetchDogs() {
    setState(() {
      futureDogs = DogService.fetchDogs();
    });
  }

  void _deleteDog(String id) async {
    try {
      await DogService.deleteDog(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dog deleted successfully!')),
      );
      fetchDogs();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete dog: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adopt a Pet'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddDogScreen()),
              ).then((_) => fetchDogs());
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Image de fond
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenu de la liste par-dessus l'image de fond
          FutureBuilder<List<Dog>>(
            future: futureDogs,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No dogs available'));
              } else {
                final dogs = snapshot.data!;
                return ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  itemCount: dogs.length,
                  itemBuilder: (context, index) {
                    final dog = dogs[index];
                    return Card(
                      elevation: 6.0,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            "http://192.168.1.12:5000${dog.image}",
                          ),
                          onBackgroundImageError: (_, __) {
                            print("Erreur lors du chargement de l'image : ${dog.image}");
                          },
                        ),
                        title: Text(
                          dog.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${dog.age} yrs | ${dog.gender}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 16, color: Colors.redAccent),
                                SizedBox(width: 4),
                                Text(
                                  dog.location,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditDogScreen(dog: dog),
                                  ),
                                ).then((_) => fetchDogs());
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteDog(dog.id);
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DogDetailScreen(dog: dog),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
