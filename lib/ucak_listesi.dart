import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'koltuk_secimi.dart'; //  koltuk seçimine yönlendireceğim zaman ihtiyacım olabilir

class UcakListesiScreen extends StatelessWidget {
  final String nereden;
  final String nereye;
  final String tarih;

  const UcakListesiScreen({
    super.key, 
    required this.nereden, 
    required this.nereye, 
    required this.tarih
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("$nereden ✈️ $nereye"),
        backgroundColor: const Color(0xFF1E88E5), 
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: Text(
              "Seçilen Tarih: $tarih",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('ucak_seferleri')
                  .where('nereden', isEqualTo: nereden)
                  .where('nereye', isEqualTo: nereye)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                var seferler = snapshot.data!.docs;


                if (seferler.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.airplanemode_inactive, size: 80, color: Colors.grey),
                        const SizedBox(height: 10),
                        Text(
                          "Maalesef $nereden - $nereye arası\nuçuş bulunamadı.",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: seferler.length,
                  itemBuilder: (context, index) {
                    var sefer = seferler[index];
                    return _ucakKarti(context, sefer);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _ucakKarti(BuildContext context, DocumentSnapshot sefer) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red[50], 
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: const Icon(Icons.airlines, color: Colors.red, size: 28),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sefer['firma'], 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                    ),
                    Text(
                      sefer['ucusKodu'], 
                      style: const TextStyle(fontSize: 12, color: Colors.grey)
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  "${sefer['fiyat']} ₺", 
                  style: const TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold, 
                    color: Color(0xFF1E88E5)
                  )
                ),
              ],
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(sefer['saat'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(nereden, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                
                Column(
                  children: [
                    const Icon(Icons.flight_takeoff, color: Colors.grey, size: 20),
                    Container(height: 1, width: 50, color: Colors.grey),
                    Text(
                      sefer['sure'], 
                      style: const TextStyle(fontSize: 11, color: Colors.grey)
                    ),
                  ],
                ),

                Column(
                  children: [
                    const Text("--:--", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54)),
                    Text(nereye, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5), 
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Uçak koltuk seçimi özelliği yakında eklenecek!"))
                  );
                }, 
                child: const Text("SEÇ VE DEVAM ET"),
              ),
            )
          ],
        ),
      ),
    );
  }
}