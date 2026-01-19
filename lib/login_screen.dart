import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool girisModu = false; 

  final TextEditingController _adSoyadController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();

  Future<void> _islemiYap() async {
    try {
      if (girisModu) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _sifreController.text.trim(),
        );
      } else {

        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _sifreController.text.trim(),
        );

        if (userCredential.user != null) {
          await userCredential.user!.updateDisplayName(_adSoyadController.text.trim());
        }
      }

      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      }

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: ${e.message}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.airplane_ticket, size: 80, color: Color(0xFF1E88E5)),
                const Text("CepteBilet", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E88E5))),
                const SizedBox(height: 30),

                Text(
                  girisModu ? "Giriş Yap" : "Kayıt Ol", 
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 20),
            
                if (!girisModu) 
                  Column(
                    children: [
                      _kutucukYap(Icons.person, "Ad Soyad", _adSoyadController),
                      const SizedBox(height: 15),
                    ],
                  ),

                _kutucukYap(Icons.email, "E-Posta", _emailController, klavyeTipi: TextInputType.emailAddress),
                const SizedBox(height: 15),
                _kutucukYap(Icons.lock, "Şifre", _sifreController, sifreliMi: true),
            
                const SizedBox(height: 25),
            
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E88E5), foregroundColor: Colors.white),
                    onPressed: _islemiYap, 
                    child: Text(girisModu ? "GİRİŞ YAP" : "KAYIT OL"),
                  ),
                ),
                
                const SizedBox(height: 15),

                TextButton(
                  onPressed: () {
                    setState(() {
                      girisModu = !girisModu; 
                    });
                  },
                  child: Text(
                    girisModu ? "Hesabın yok mu? Kayıt Ol" : "Hesabın var mı? Giriş Yap",
                    style: const TextStyle(color: Colors.blueGrey),
                  ),
                ),
                
                TextButton(
                  onPressed: () {
                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                  },
                  child: const Text("Üye Olmadan Devam Et", style: TextStyle(color: Colors.grey)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _kutucukYap(IconData icon, String yazi, TextEditingController kontrolcu, {bool sifreliMi = false, TextInputType klavyeTipi = TextInputType.text}) {
    return TextField(
      controller: kontrolcu,
      obscureText: sifreliMi,
      keyboardType: klavyeTipi,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        hintText: yazi,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }
}