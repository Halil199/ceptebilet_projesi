import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'koltuk_secimi.dart'; 

class SeferListesiScreen extends StatefulWidget {
  final String nereden;
  final String nereye;
  final String tarih;

  const SeferListesiScreen({
    super.key,
    required this.nereden,
    required this.nereye,
    required this.tarih,
  });

  @override
  State<SeferListesiScreen> createState() => _SeferListesiScreenState();
}

class _SeferListesiScreenState extends State<SeferListesiScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Sefer Sonuçları", style: TextStyle(fontSize: 16)),
            Text("${widget.nereden} > ${widget.nereye}",
                style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('seferler')
            .where('nereden', isEqualTo: widget.nereden)
            .where('nereye', isEqualTo: widget.nereye)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Bir hata oluştu: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 60, color: Colors.grey),
                  const SizedBox(height: 10),
                  Text("${widget.nereden} - ${widget.nereye} arası sefer yok.",
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          var seferler = snapshot.data!.docs;

          return ListView.builder(
            itemCount: seferler.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              var sefer = seferler[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.directions_bus,
                            color: Color(0xFF1E88E5)),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(sefer['firma'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.access_time,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 5),
                                Text(sefer['saat'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("${sefer['fiyat']} ₺",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)),
                          const SizedBox(height: 5),
                          
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E88E5),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              List<dynamic> erkekListesi = [];
                              List<dynamic> kadinListesi = [];
                              
                              try {
                                var data = sefer.data() as Map<String, dynamic>;
                                if (data.containsKey('doluErkek')) {
                                  erkekListesi = data['doluErkek'];
                                }
                                if (data.containsKey('doluKadin')) {
                                  kadinListesi = data['doluKadin'];
                                }
                              } catch (e) {
                                print("Liste çekme hatası: $e");
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => KoltukSecimiScreen(
                                    nereden: widget.nereden,
                                    nereye: widget.nereye,
                                    tarih: widget.tarih,
                                    

                                    saat: sefer['saat'].toString(),
                                    fiyat: sefer['fiyat'].toString(),
                                    
                                    doluKoltuklarErkek: erkekListesi,
                                    doluKoltuklarKadin: kadinListesi,
                                  ),
                                ),
                              );
                            },
                            child: const Text("Seç"),
                          ),
                         
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}