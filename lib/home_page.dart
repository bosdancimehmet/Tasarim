import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'waste_history_page.dart';
import 'waste_data.dart'; // Ortak veriyi dahil ettik

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sayfa içerikleri
    // HomeContent'e sayfayı yenilemesi için bir fonksiyon (onRefresh) gönderiyoruz
    final List<Widget> pages = [
      HomeContent(onRefresh: () => setState(() {})), 
      const CameraPlaceholder(),
      const ProfileContent(),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
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
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Tara'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
      ),
    );
  }
}

// --- ANA SAYFA İÇERİĞİ ---
class HomeContent extends StatelessWidget {
  final VoidCallback onRefresh; // Sayfayı yenilemek için gerekli fonksiyon
  
  const HomeContent({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    // 3. ADIM: Verileri global dosyadan okuyup topluyoruz
    int totalCount = 0;
    globalWasteData.forEach((key, value) {
      totalCount += (value['count'] as int);
    });

    // 4. ADIM: Yüzdeyi global hedefe göre hesaplıyoruz
    double progressPercent = (totalCount / (globalTargetCount > 0 ? globalTargetCount : 1)).clamp(0.0, 1.0);

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
              boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 10))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Toplam Bakiyeniz", style: TextStyle(color: Colors.white70, fontSize: 16)),
                    Icon(Icons.account_balance_wallet, color: Colors.white.withOpacity(0.8)),
                  ],
                ),
                const SizedBox(height: 10),
                const Text("1,250.00 reMoney", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                  child: const Text("+45 reMoney (Bugün)", style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // AKSİYON BUTONLARI
          const Text("Hızlı İşlemler", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _buildActionButton(icon: Icons.qr_code_scanner, label: "Atık Tara", color: Colors.orange, onTap: () {})),
              const SizedBox(width: 15),
              Expanded(child: _buildActionButton(icon: Icons.card_giftcard, label: "Ödüller", color: Colors.purple, onTap: () {})),
            ],
          ),
          const SizedBox(height: 30),

          // --- ÇEVRESEL KAZANIMLAR (DİNAMİK) ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Çevresel Kazanımlarım", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {
                  // Detay sayfasına git ve DÖNDÜĞÜNDE ekranı yenile
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const WasteHistoryPage())).then((_) {
                    onRefresh(); 
                  });
                },
                child: const Text("Tümünü Gör >", style: TextStyle(color: Colors.green)),
              )
            ],
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const WasteHistoryPage())).then((_) {
                onRefresh();
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Column(
                children: [
                  // --- ÖZEL ARC WIDGET (ARTIK DİNAMİK) ---
                  ArcProgressBar(
                    percentage: progressPercent, 
                    value: "$totalCount",
                    label: "ADET",
                  ),
                  
                  const SizedBox(height: 30),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHomeMiniStat(Icons.newspaper, "Kağıt", "${globalWasteData['Kağıt']['count']}kg", Colors.brown),
                      _buildHomeMiniStat(Icons.wine_bar, "Cam", "${globalWasteData['Cam']['count']}", Colors.teal),
                      _buildHomeMiniStat(Icons.local_drink, "Plastik", "${globalWasteData['Plastik']['count']}", Colors.blue),
                      _buildHomeMiniStat(Icons.settings, "Metal", "${globalWasteData['Metal']['count']}", Colors.grey),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))]),
        child: Column(children: [CircleAvatar(backgroundColor: color.withOpacity(0.1), radius: 25, child: Icon(icon, color: color, size: 28)), const SizedBox(height: 10), Text(label, style: const TextStyle(fontWeight: FontWeight.bold))]),
      ),
    );
  }

  Widget _buildHomeMiniStat(IconData icon, String label, String count, Color color) {
    return Column(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 24)), const SizedBox(height: 8), Text(count, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)), Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12))]);
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

// --- 3. PROFİL SAYFASI (SADELEŞTİRİLMİŞ HALİ) ---
class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 1. ÜST BAŞLIK (Profil Fotosu ve İsim) - AYNI KALDI
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
                        backgroundColor: Colors.grey[200],
                        child: Icon(Icons.person, size: 60, color: Colors.grey[400]),
                      ),
                    ),
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
                  "Emre Tekin",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 5),
                Text(
                  "deneme@gmail.com",
                  style: TextStyle(fontSize: 14, color: Colors.green[100]),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 30), // Boşluğu biraz artırdık çünkü aradaki kartlar gitti
          
          // 2. MENÜ SEÇENEKLERİ (SADELEŞTİRİLDİ)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildMenuOption(Icons.settings_outlined, "Hesap Ayarları"),
                // "Geri Dönüşüm Geçmişi" ve "Sıralama" buradan silindi.
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

  // Menü oluşturucu (İstatistik oluşturucu silindi çünkü artık kullanılmıyor)
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
          child: Icon(icon, color: isDestructive ? Colors.red : Colors.green[700]),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, color: isDestructive ? Colors.red : Colors.black87),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}

// --- GRAFİK ÇİZİM SINIFLARI ---
class ArcProgressBar extends StatelessWidget {
  final double percentage; 
  final String value;
  final String label;

  const ArcProgressBar({super.key, required this.percentage, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150, height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(size: const Size(150, 150), painter: ArcPainter(percentage: percentage)),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [const SizedBox(height: 10), const Text("TOPLAM", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)), const Text("AYLIK İADE", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)), const SizedBox(height: 5), Text(value, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87)), Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold))]),
        ],
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  final double percentage;
  ArcPainter({required this.percentage});
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = Colors.grey[200]!..style = PaintingStyle.stroke..strokeCap = StrokeCap.round..strokeWidth = 12.0;
    final progressPaint = Paint()..color = Colors.green..style = PaintingStyle.stroke..strokeCap = StrokeCap.round..strokeWidth = 12.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    const startAngle = 135 * (math.pi / 180);
    const sweepAngle = 270 * (math.pi / 180);
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, startAngle, sweepAngle, false, backgroundPaint);
    final currentSweep = sweepAngle * percentage;
    canvas.drawArc(rect, startAngle, currentSweep, false, progressPaint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}