import 'package:flutter/material.dart';
import 'home_screen.dart'; 

class OdemeEkrani extends StatefulWidget {
  final String toplamTutar;

  const OdemeEkrani({super.key, required this.toplamTutar});

  @override
  State<OdemeEkrani> createState() => _OdemeEkraniState();
}

class _OdemeEkraniState extends State<OdemeEkrani> {
  final TextEditingController _kartNoCtrl = TextEditingController();
  final TextEditingController _sktCtrl = TextEditingController();
  final TextEditingController _cvvCtrl = TextEditingController();
  final TextEditingController _adSoyadCtrl = TextEditingController();

  bool odemeYapiliyor = false;

  void _odemeYap() async {
    if (_kartNoCtrl.text.isEmpty || _cvvCtrl.text.isEmpty || _sktCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen tüm kart bilgilerini girin.")));
      return;
    }

    setState(() {
      odemeYapiliyor = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return; 

    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) => AlertDialog(
        title: const Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 60),
            SizedBox(height: 10),
            Text("Ödeme Başarılı!"),
          ],
        ),
        content: const Text("Biletiniz başarıyla oluşturuldu. İyi yolculuklar dileriz!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context, 
                MaterialPageRoute(builder: (context) => const HomeScreen()), 
                (route) => false
              );
            },
            child: const Text("ANA SAYFAYA DÖN"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Güvenli Ödeme"),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E2841), 
                borderRadius: BorderRadius.circular(20),
                boxShadow: [const BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
              ),
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.contactless, color: Colors.white70, size: 30),
                  Text(_kartNoCtrl.text.isEmpty ? "**** **** **** ****" : _kartNoCtrl.text, style: const TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 2)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_adSoyadCtrl.text.isEmpty ? "AD SOYAD" : _adSoyadCtrl.text.toUpperCase(), style: const TextStyle(color: Colors.white70)),
                      Text(_sktCtrl.text.isEmpty ? "AY/YIL" : _sktCtrl.text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 30),

            _kartInputu("Kart Üzerindeki İsim", _adSoyadCtrl, icon: Icons.person),
            const SizedBox(height: 15),
            _kartInputu("Kart Numarası", _kartNoCtrl, icon: Icons.credit_card, klavye: TextInputType.number),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: _kartInputu("Son Kul. Tarihi (AA/YY)", _sktCtrl, icon: Icons.calendar_today, klavye: TextInputType.datetime)),
                const SizedBox(width: 15),
                Expanded(child: _kartInputu("CVV", _cvvCtrl, icon: Icons.lock, klavye: TextInputType.number, sifreli: true)),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: odemeYapiliyor ? null : _odemeYap, 
                child: odemeYapiliyor 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text("ÖDEMEYİ TAMAMLA (${widget.toplamTutar} ₺)", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _kartInputu(String baslik, TextEditingController ctrl, {IconData? icon, TextInputType klavye = TextInputType.text, bool sifreli = false}) {
    return TextField(
      controller: ctrl,
      keyboardType: klavye,
      obscureText: sifreli,
      onChanged: (val) => setState(() {}), 
      decoration: InputDecoration(
        labelText: baslik,
        prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }
}