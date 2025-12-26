import 'package:flutter/material.dart';
import 'waste_data.dart';

class WasteHistoryPage extends StatefulWidget {
  const WasteHistoryPage({super.key});

  @override
  State<WasteHistoryPage> createState() => _WasteHistoryPageState();
}

class _WasteHistoryPageState extends State<WasteHistoryPage> {
  String selectedMonth = "Aralık";
  String selectedYear = "2025";

  late TextEditingController _countController;
  late TextEditingController _moneyController;

  @override
  void initState() {
    super.initState();
    // Global değişkenlerden başlangıç değerlerini al
    _countController = TextEditingController(text: globalTargetCount.toString());
    _moneyController = TextEditingController(text: globalTargetMoney.toString());
  }

  @override
  void dispose() {
    _countController.dispose();
    _moneyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // --- HESAPLAMA ---
    int totalCount = 0;
    int totalRemoney = 0;

    globalWasteData.forEach((key, value) {
      int count = value['count'] as int;
      int price = value['price'] as int;
      totalCount += count;
      totalRemoney += (count * price); 
    });

    // --- YÜZDE HESAPLAMA ---
    double countPercent = (totalCount / (globalTargetCount > 0 ? globalTargetCount : 1)).clamp(0.0, 1.0);
    double moneyPercent = (totalRemoney / (globalTargetMoney > 0 ? globalTargetMoney : 1)).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Çevresel Kazanımlarım", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[700],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // TARİH FİLTRESİ
            Row(
              children: [
                Expanded(child: _buildDropdown(selectedMonth)),
                const SizedBox(width: 15),
                Expanded(child: _buildDropdown(selectedYear)),
              ],
            ),
            const SizedBox(height: 15),

            // HEDEF BELİRLEME ALANI
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.track_changes, color: Colors.green),
                  const SizedBox(width: 10),
                  const Text("Aylık Hedefler:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildGoalInput(
                      controller: _countController, 
                      label: "Adet", 
                      onChanged: (val) {
                        setState(() {
                          globalTargetCount = int.tryParse(val) ?? 1; 
                        });
                      }
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildGoalInput(
                      controller: _moneyController, 
                      label: "Puan", 
                      onChanged: (val) {
                        setState(() {
                          globalTargetMoney = int.tryParse(val) ?? 1; 
                        });
                      }
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // BÜYÜK ÖZET KARTI
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  const Text("Aylık Kazanımlarınız", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                    children: [
                      _buildCircularSummary(
                        value: "$totalCount",
                        label: "ADET",
                        color: Colors.green,
                        percent: countPercent,
                      ),
                      Container(height: 80, width: 1, color: Colors.grey[200]),
                      _buildCircularSummary(
                        value: "$totalRemoney",
                        label: "reMoney",
                        color: Colors.orange, 
                        percent: moneyPercent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMiniStat(Icons.newspaper, "Kağıt", "${globalWasteData['Kağıt']['count']}kg", Colors.brown),
                      _buildMiniStat(Icons.wine_bar, "Cam", "${globalWasteData['Cam']['count']}", Colors.teal),
                      _buildMiniStat(Icons.local_drink, "Pet", "${globalWasteData['Plastik']['count']}", Colors.blue),
                      _buildMiniStat(Icons.settings, "Metal", "${globalWasteData['Metal']['count']}", Colors.grey),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // DETAY LİSTESİ
            const Align(alignment: Alignment.centerLeft, child: Text("Detaylı Döküm", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            const SizedBox(height: 10),
            _buildDetailRow("Plastik Atık", globalWasteData['Plastik']['count'], globalWasteData['Plastik']['price'], Icons.local_drink, Colors.blue),
            _buildDetailRow("Kağıt Atık", globalWasteData['Kağıt']['count'], globalWasteData['Kağıt']['price'], Icons.newspaper, Colors.brown, unit: "kg"),
            _buildDetailRow("Cam Atık", globalWasteData['Cam']['count'], globalWasteData['Cam']['price'], Icons.wine_bar, Colors.teal),
            _buildDetailRow("Metal Atık", globalWasteData['Metal']['count'], globalWasteData['Metal']['price'], Icons.settings, Colors.grey),
          ],
        ),
      ),
    );
  }

  // YARDIMCI METOTLAR
  Widget _buildGoalInput({required TextEditingController controller, required String label, required Function(String) onChanged}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        isDense: true,
      ),
    );
  }

  Widget _buildCircularSummary({required String value, required String label, required Color color, required double percent}) {
    return SizedBox(
      width: 130, height: 130, 
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(width: 130, height: 130, child: CircularProgressIndicator(value: 1.0, strokeWidth: 10, valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[100]!))),
          SizedBox(width: 130, height: 130, child: CircularProgressIndicator(value: percent, strokeWidth: 10, valueColor: AlwaysStoppedAnimation<Color>(color), strokeCap: StrokeCap.round)),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)), const SizedBox(height: 2), Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey))])
        ],
      ),
    );
  }
  
  Widget _buildDropdown(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.withOpacity(0.3))),
      child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: value, isExpanded: true, icon: const Icon(Icons.arrow_drop_down), items: [DropdownMenuItem(value: value, child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)))], onChanged: (val) {})),
    );
  }

  Widget _buildMiniStat(IconData icon, String label, String count, Color color) {
    return Column(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 24)), const SizedBox(height: 8), Text(count, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12))]);
  }

  Widget _buildDetailRow(String name, int count, int price, IconData icon, Color color, {String unit = "Adet"}) {
    int totalValue = count * price;
    return Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)), child: Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color)), const SizedBox(width: 15), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.bold)), Text("$price reMoney / $unit", style: TextStyle(fontSize: 12, color: Colors.grey[600]))]), const Spacer(), Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text("$count $unit", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text("+$totalValue reMoney", style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold, fontSize: 12))])]));
  }
}