import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; //Veritabanı paketi
import 'firebase_options.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Atık Ayrıştırma',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  // --- GİRİŞ YAP FONKSİYONU ---
  Future<void> _login() async {
    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? "Bir hata oluştu");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // --- KAYIT OL FONKSİYONU ---
  Future<void> _register() async {
    setState(() => isLoading = true);
    try {
      // 1. Auth: Kullanıcıyı oluştur (Kimlik Kartı)
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2. Auth: İsmini güncelle
      await userCredential.user?.updateDisplayName(_nameController.text.trim());

      // 3. Firestore: Veritabanına Başlangıç Verilerini Yaz (Özlük Dosyası)
      // "users" isminde klasör aç, içine bu kullanıcının ID'si ile bir dosya koy.
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'reMoney': 250,          // 250 Puan Bonusu!
        'totalRecycled': 0,      // Toplam ayrıştırılan atık sayısı
        'plasticCount': 0,       // Plastik sayacı
        'glassCount': 0,         // Cam sayacı
        'paperCount': 0,         // Kağıt sayacı
        'metalCount': 0,         // Metal sayacı
        'createdAt': FieldValue.serverTimestamp(), // Kayıt tarihi
      });

      // 4. Ana Sayfaya git
      if (mounted) {
        _showSuccess("Kayıt başarılı! 250 reMoney hesabına tanımlandı. 🎁");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? "Kayıt yapılamadı");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.recycling, size: 100, color: Colors.green[700]),
              const SizedBox(height: 20),
              
              Text(
                isLogin ? 'Tekrar Hoşgeldiniz' : 'Hesap Oluştur',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green[900]),
              ),
              const SizedBox(height: 10),
              Text(
                isLogin ? 'Geri dönüşüme katkı sağlamak için giriş yapın' : 'Aramıza katılın ve ödüller kazanın',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),

              if (!isLogin)
                _buildInput(_nameController, 'Ad Soyad', Icons.person_outline),

              _buildInput(_emailController, 'E-posta', Icons.email_outlined, isEmail: true),
              _buildInput(_passwordController, 'Şifre', Icons.lock_outline, isPassword: true),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading 
                    ? null 
                    : () {
                        if (isLogin) {
                          _login();
                        } else {
                          _register();
                        }
                      },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                  ),
                  child: isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        isLogin ? 'GİRİŞ YAP' : 'KAYIT OL',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(isLogin ? 'Hesabınız yok mu?' : 'Zaten hesabınız var mı?', style: const TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () => setState(() => isLogin = !isLogin),
                    child: Text(isLogin ? 'Kayıt Ol' : 'Giriş Yap', style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String hint, IconData icon, {bool isPassword = false, bool isEmail = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}