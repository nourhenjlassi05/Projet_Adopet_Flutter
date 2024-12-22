import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      print("Utilisateur connecté : ${userCredential.user?.email}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connexion réussie !')),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      String errorMessage = 'Erreur inconnue';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'Utilisateur non trouvé.';
            break;
          case 'wrong-password':
            errorMessage = 'Mot de passe incorrect.';
            break;
          case 'invalid-email':
            errorMessage = 'Email invalide.';
            break;
          default:
            errorMessage = e.message ?? 'Erreur lors de la connexion.';
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      print("Erreur : ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
      ),
      body: Stack(
        children: [
          // Image d'arrière-plan
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'), // Vérifiez ce chemin
                fit: BoxFit.cover, // Pour couvrir tout l'écran
              ),
            ),
          ),
          // Contenu de la page (par-dessus l'image)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8), // Fond semi-transparent
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _login,
                        child: Text('Se connecter'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text("Créer un compte"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
