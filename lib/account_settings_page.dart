import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final _nameController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser; // Mevcut kullanıcıyı al
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Sayfa açıldığında mevcut ismi kutucuğa otomatik yaz
    _nameController.text = user?.displayName ?? "";
  }

  // --- İSİM GÜNCELLEME FONKSİYONU ---
  Future<void> _updateName() async {
    if (_nameController.text.isEmpty) return;

    setState(() => isLoading = true);

    try {
      // 1. Firebase'deki ismi güncelle
      await user?.updateDisplayName(_nameController.text.trim());
      
      // 2. Kullanıcı bilgilerini yenile (Lokal cache temizlensin)
      await user?.reload(); 

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("İsim başarıyla güncellendi!"), backgroundColor: Colors.green),
        );
        Navigator.pop(context); // Sayfayı kapat ve geri dön
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Hesap Ayarları", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Profil Bilgileri",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // İsim Değiştirme Kutusu
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
              ),
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Ad Soyad",
                  border: InputBorder.none,
                  icon: Icon(Icons.person_outline, color: Colors.green),
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            Text(
              "E-posta adresiniz: ${user?.email}",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            
            const Spacer(),

            // Kaydet Butonu
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _updateName,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("DEĞİŞİKLİKLERİ KAYDET", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}