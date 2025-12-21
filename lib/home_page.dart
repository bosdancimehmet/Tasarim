import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Sayfaların Listesi
  final List<Widget> _pages = [
    const HomeContent(),      // 0: Ana Sayfa (Senin Tasarımın)
    const CameraPlaceholder(), // 1: Kamera Ekranı (Şimdilik boş)
    const ProfileContent(), // 2: Profil Ekranı (Güncellendi)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      // Üst Bar sadece Ana Sayfada görünsün istiyorsak burayı özelleştirebiliriz
      // Şimdilik genel tutuyoruz.
      appBar: AppBar(
        title: const Text(
          "Atık Ayrıştırma",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.green[700],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      
      // Seçili olan sayfayı göster
      body: _pages[_selectedIndex],

      // ALT MENÜ ÇUBUĞU
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Tara',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false, // Seçili olmayanların yazısını gizle (daha şık)
        onTap: _onItemTapped,
      ),
    );
  }
}

// --- 1. SENİN TASARLADIĞIN ANA SAYFA İÇERİĞİ ---
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // reMoney CÜZDAN KARTI
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green[800]!, Colors.green[500]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Toplam Bakiyeniz",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    Icon(Icons.account_balance_wallet, color: Colors.white.withOpacity(0.8)),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "1,250.00 reMoney",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "+45 reMoney (Bugün)",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // AKSİYON BUTONLARI
          const Text(
            "Hızlı İşlemler",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.qr_code_scanner,
                  label: "Atık Tara",
                  color: Colors.orange,
                  onTap: () {
                    // Buraya basınca Kamera sekmesine geçiş yapılabilir
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.card_giftcard,
                  label: "Ödüller",
                  color: Colors.purple,
                  onTap: () {
                    print("Ödül sayfasına gidilecek");
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // ATIK KATEGORİLERİ
          const Text(
            "Atık Türleri ve Değerleri",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _buildWasteCategoryItem("Plastik Atık", "10 reMoney / Adet", Icons.local_drink, Colors.blue),
          _buildWasteCategoryItem("Kağıt Atık", "5 reMoney / kg", Icons.newspaper, Colors.brown),
          _buildWasteCategoryItem("Cam Atık", "15 reMoney / Adet", Icons.wine_bar, Colors.teal),
          _buildWasteCategoryItem("Metal Atık", "20 reMoney / Adet", Icons.settings, Colors.grey),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              radius: 25,
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildWasteCategoryItem(String title, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(value, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}

// --- 2. KAMERA (TARA) SAYFASI YER TUTUCUSU ---
class CameraPlaceholder extends StatelessWidget {
  const CameraPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          const Text("Kamera Modülü Buraya Gelecek", style: TextStyle(color: Colors.grey, fontSize: 18)),
          const SizedBox(height: 10),
          const Text("(Python & CNN Entegrasyonu)", style: TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }
}

// --- 3. PROFİL SAYFASI YER TUTUCUSU ---
// --- 3. GÜNCELLENMİŞ PROFİL SAYFASI ---
// --- 3. GÜNCELLENMİŞ PROFİL SAYFASI (V2) ---
class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 1. ÜST BAŞLIK (Profil Fotosu ve İsim)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.green[700],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200], // Gri Nötr Arka Plan
                        child: Icon(
                          Icons.person, 
                          size: 60, 
                          color: Colors.grey[400]
                        ), // Klasik Profil İkonu
                      ),
                    ),
                    // Fotoğraf Düzenleme İkonu (Görsel Amaçlı)
                    Container(
                      margin: const EdgeInsets.all(4),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  "Emre Tekin", // Güncellenen İsim
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "deneme@gmail.com", // Güncellenen Mail
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green[100],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 2. İSTATİSTİK KARTLARI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard("Atık", "124", "Adet"),
                _buildStatCard("Puan", "1,250", "reMoney"),
                _buildStatCard("Seviye", "5", "Doğa Dostu"),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // 3. MENÜ SEÇENEKLERİ
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildMenuOption(Icons.settings_outlined, "Hesap Ayarları"),
                _buildMenuOption(Icons.history, "Geri Dönüşüm Geçmişi"),
                _buildMenuOption(Icons.emoji_events_outlined, "Sıralama"),
                _buildMenuOption(Icons.help_outline, "Yardım & Destek"),
                const Divider(height: 30),
                _buildMenuOption(Icons.logout, "Çıkış Yap", isDestructive: true),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Yardımcı Widget: İstatistik Kartı
  Widget _buildStatCard(String title, String value, String subtitle) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Yardımcı Widget: Menü Satırı
  Widget _buildMenuOption(IconData icon, String title, {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5)],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDestructive ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : Colors.green[700],
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red : Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          // Tıklama işlemleri buraya
        },
      ),
    );
  }
}