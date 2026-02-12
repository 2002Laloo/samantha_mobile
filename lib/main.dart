import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}


List<Map<String, String>> users = [
  {
    "email": "leila@joazile.com",
    "password": "11112222"
  }
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            Image.asset(
              'image/logo.png',
              width: 150,
              height: 150,
            ),
            SizedBox(height: 12),
            Text(
              "Samantha",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool _showPassword = false;

  
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email requis";
    }
    if (!value.contains('@')) {
      return "Email invalide";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Mot de passe requis";
    }
    if (value.length < 6) {
      return "Minimum 6 caractères";
    }
    return null;
  }

  void login() {
    if (_formKey.currentState!.validate()) {
      bool userFound = users.any((u) =>
          u["email"] == emailCtrl.text && 
          u["password"] == passCtrl.text);

      if (userFound) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Connexion réussie!")),
        );
        
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email ou mot de passe incorrect")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Connexion",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                          validator: validateEmail,
                        ),
                        const SizedBox(height: 12),

                        TextFormField(
                          controller: passCtrl,
                          obscureText: !_showPassword,
                          decoration: InputDecoration(
                            labelText: "Mot de passe",
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.lock),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(_showPassword 
                                  ? Icons.visibility_off 
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() => _showPassword = !_showPassword);
                              },
                            ),
                          ),
                          validator: validatePassword,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: login,
                            child: const Text(
                              "Se connecter",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: OutlinedButton(
                            onPressed: (){
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(),
                                
                              ),
                            );
                          },
                          child: 
                            const Text("S'inscrire",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  bool _showPassword = false;
  bool _showConfirm = false;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email requis";
    }
    if (!value.contains('@')) {
      return "Email invalide";
    }
    if (users.any((u) => u["email"] == value)) {
      return "Cet email existe déjà";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Mot de passe requis";
    }
    if (value.length < 6) {
      return "Minimum 6 caractères";
    }
    return null;
  }

  String? validateConfirm(String? value) {
    if (value == null || value.isEmpty) {
      return "Confirmation requise";
    }
    if (value != passCtrl.text) {
      return "Les mots de passe ne correspondent pas";
    }
    return null;
  }

  void signup() {
    if (_formKey.currentState!.validate()) {
      users.add({
        "email": emailCtrl.text,
        "password": passCtrl.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Compte créé avec succès!")),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // ← Important
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Titre compact
                        const Text(
                          "Inscription",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                          validator: validateEmail,
                        ),
                        const SizedBox(height: 12),

                        // Mot de passe
                        TextFormField(
                          controller: passCtrl,
                          obscureText: !_showPassword,
                          decoration: InputDecoration(
                            labelText: "Mot de passe",
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.lock),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(_showPassword 
                                  ? Icons.visibility_off 
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() => _showPassword = !_showPassword);
                              },
                            ),
                          ),
                          validator: validatePassword,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: confirmCtrl,
                          obscureText: !_showConfirm,
                          decoration: InputDecoration(
                            labelText: "Confirmer",
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.lock_outline),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(_showConfirm 
                                  ? Icons.visibility_off 
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() => _showConfirm = !_showConfirm);
                              },
                            ),
                          ),
                          validator: validateConfirm,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: signup,
                            child: const Text(
                              "S'inscrire",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Welcome",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}