import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _register() async {
    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Les mots de passe ne correspondent pas')),
      );
      return;
    }

    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      print("Utilisateur créé : ${userCredential.user?.email}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inscription réussie !')),
      );
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      String errorMessage = 'Erreur inconnue';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'Cet email est déjà utilisé.';
            break;
          case 'invalid-email':
            errorMessage = 'Email invalide.';
            break;
          case 'weak-password':
            errorMessage = 'Le mot de passe est trop faible.';
            break;
          default:
            errorMessage = e.message ?? 'Erreur lors de l\'inscription.';
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
      body: Stack(
        children: [
          // Image d'arrière-plan
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenu par-dessus l'image
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // Marges droite et gauche
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8), // Fond semi-transparent
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Mot de passe'),
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(labelText: 'Confirmer le mot de passe'),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _register,
                      child: Text('S\'inscrire'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Retour à la connexion"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
