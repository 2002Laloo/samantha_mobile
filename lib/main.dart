
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
    Timer(const Duration(seconds: 5), () {
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


class VirtualKeyboard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onSubmit;
  final bool isNumeric;

  const VirtualKeyboard({
    super.key,
    required this.controller,
    this.onSubmit,
    this.isNumeric = false,
  });

  void _onKeyPress(String value) {
    final text = controller.text;
    final selection = controller.selection;
    
    if (value == '⌫') {
      if (selection.start > 0) {
        final newText = text.substring(0, selection.start - 1) +
            text.substring(selection.start);
        controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: selection.start - 1),
        );
      }
    } else if (value == '✓' && onSubmit != null) {
      onSubmit!();
    } else {
      final newText = text.substring(0, selection.start) +
          value +
          text.substring(selection.start);
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: selection.start + value.length),
      );
    }
  }

    @override
    Widget build(BuildContext context) {
      final keys = [
        ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
        ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
        ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
        ['z', 'x', 'c', 'v', 'b', 'n', 'm', '@', '.'],
        ['⌫', ' ', '✓'],
      ];

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: keys.map((row) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row.map((key) {
                  final isSpecial = key == '⌫' || key == '✓';
                  final isSpace = key == ' ';
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.5),
                    child: Material(
                      color: isSpecial ? Colors.blue[400] : Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      child: InkWell(
                        onTap: () => _onKeyPress(key),
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          width: isSpace ? 100 : 28,
                          height: 34,
                          alignment: Alignment.center,
                          child: Text(
                            isSpace ? 'espace' : key,
                            style: TextStyle(
                              fontSize: isSpecial ? 16 : 14,
                              fontWeight: FontWeight.w500,
                              color: isSpecial ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
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
  TextEditingController? _activeController;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email requis";
    if (!value.contains('@')) return "Email invalide";
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Mot de passe requis";
    if (value.length < 8) return "Minimum 8 caractères";
    return null;
  }

  void login() {
    if (_formKey.currentState!.validate()) {
      bool userFound = users.any((u) =>
          u["email"] == emailCtrl.text && u["password"] == passCtrl.text);
      
      if (userFound) {
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Connexion réussie!")),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        });
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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),
                      const Text("Connexion", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      
                      TextFormField(
                        controller: emailCtrl,
                        readOnly: true,
                        onTap: () => setState(() => _activeController = emailCtrl),
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.email, size: 20),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          filled: _activeController == emailCtrl,
                          fillColor: Colors.blue[50],
                        ),
                        validator: validateEmail,
                      ),
                      const SizedBox(height: 12),
                      
                      TextFormField(
                        controller: passCtrl,
                        readOnly: true,
                        obscureText: !_showPassword,
                        onTap: () => setState(() => _activeController = passCtrl),
                        decoration: InputDecoration(
                          labelText: "Mot de passe",
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock, size: 20),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          filled: _activeController == passCtrl,
                          fillColor: Colors.blue[50],
                          suffixIcon: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility, size: 20),
                            onPressed: () => setState(() => _showPassword = !_showPassword),
                          ),
                        ),
                        validator: validatePassword,
                      ),
                      const SizedBox(height: 16),
                      
                      SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: ElevatedButton(
                          onPressed: login,
                          child: const Text("Se connecter", style: TextStyle(fontSize: 14)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: OutlinedButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen())),
                          child: const Text("S'inscrire", style: TextStyle(fontSize: 14)),
                        ),
                      ),
                      const Spacer(flex: 1),
                    ],
                  ),
                ),
              ),
            ),
            if (_activeController != null)
              VirtualKeyboard(controller: _activeController!, onSubmit: login),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
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
  TextEditingController? _activeController;

  String? _validate(String? value, String field, [bool isConfirm = false]) {
    if (value == null || value.isEmpty) return "$field requis${isConfirm ? 'e' : ''}";
    if (field == "Email") {
      if (!value.contains('@')) return "Email invalide";
      if (users.any((u) => u["email"] == value)) return "Cet email existe déjà";
    }
    if (field == "Mot de passe" && value.length < 8) return "Minimum 8 caractères";
    if (isConfirm && value != passCtrl.text) return "Les mots de passe ne correspondent pas";
    return null;
  }

  void _signup() {
    if (!_formKey.currentState!.validate()) return;
    users.add({"email": emailCtrl.text, "password": passCtrl.text});
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Compte créé avec succès!")));
    Navigator.pop(context);
  }

  Widget _buildField(TextEditingController ctrl, String label, IconData icon, String field, [bool isPassword = false, bool isConfirm = false]) {
    final showPass = isPassword ? (ctrl == confirmCtrl ? _showConfirm : _showPassword) : false;
    return TextFormField(
      controller: ctrl,
      readOnly: true,
      obscureText: isPassword && !showPass,
      onTap: () => setState(() => _activeController = ctrl),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon, size: 20),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        filled: _activeController == ctrl,
        fillColor: Colors.blue[50],
        suffixIcon: isPassword ? IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(showPass ? Icons.visibility_off : Icons.visibility, size: 20),
          onPressed: () => setState(() => ctrl == confirmCtrl ? _showConfirm = !_showConfirm : _showPassword = !_showPassword),
        ) : null,
      ),
      validator: (v) => _validate(v, field, isConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 50,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),
                      const Text("Inscription", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      _buildField(emailCtrl, "Email", Icons.email, "Email"),
                      const SizedBox(height: 12),
                      _buildField(passCtrl, "Mot de passe", Icons.lock, "Mot de passe", true),
                      const SizedBox(height: 12),
                      _buildField(confirmCtrl, "Confirmer", Icons.lock_outline, "Confirmation", true, true),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: ElevatedButton(
                          onPressed: _signup,
                          child: const Text("S'inscrire", style: TextStyle(fontSize: 14)),
                        ),
                      ),
                      const Spacer(flex: 1),
                    ],
                  ),
                ),
              ),
            ),
            if (_activeController != null)
              VirtualKeyboard(controller: _activeController!, onSubmit: _signup),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
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


