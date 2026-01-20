import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sefer_listesi.dart';
import 'ucak_listesi.dart';
import 'login_screen.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime secilenTarih = DateTime.now();
  bool otobusSecili = true;

  String nereden = "İstanbul";
  String nereye = "Ankara";

  List<String> sehirler = [];

  void initState() {
    super.initState();
    _sehirleriVeritabanindanGetir();
  }

  Future<void> _sehirleriVeritabanindanGetir() async {
    var veriler = await FirebaseFirestore.instance
        .collection('sehirler')
        .orderBy("isim")
        .get();

    setState(() {
      sehirler.clear();
      for (var belge in veriler.docs) {
        sehirler.add(belge['isim']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    User? kullanici = FirebaseAuth.instance.currentUser;
    String isim = "Misafir";
    if (kullanici != null && kullanici.displayName != null) {
      isim = kullanici.displayName!;
    }
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        title: Column(
          children: [
            const Text(
              "CepteBilet",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            Text(
              "Hoşgeldin, $isim",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),

        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(height: 60, color: const Color(0xFF1E88E5)),

          Transform.translate(
            offset: const Offset(0, -40),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                otobusSecili = true;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: otobusSecili
                                    ? const Color(0xFF1E88E5)
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.directions_bus,
                                    color: otobusSecili
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Otobüs",
                                    style: TextStyle(
                                      color: otobusSecili
                                          ? Colors.white
                                          : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10), 
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                otobusSecili = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !otobusSecili
                                    ? const Color(0xFF1E88E5)
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.airplanemode_active,
                                    color: !otobusSecili
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Uçak",
                                    style: TextStyle(
                                      color: !otobusSecili
                                          ? Colors.white
                                          : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20), 

                    const Divider(height: 30),

                    InkWell(
                      onTap: () => _sehirListesiniAc(true),
                      child: _basitSatir("NEREDEN", nereden, Icons.my_location),
                    ),

                    const Divider(),

                    InkWell(
                      onTap: () => _sehirListesiniAc(false),
                      child: _basitSatir("NEREYE", nereye, Icons.location_on),
                    ),

                    const Divider(),

                    InkWell(
                      onTap: () => _takvimiAc(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "GİDİŞ TARİHİ",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "${secilenTarih.day}.${secilenTarih.month}.${secilenTarih.year}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: otobusSecili
                              ? const Color(0xFF1E88E5)
                              : Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (nereden == nereye) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Başlangıç ve Bitiş yeri aynı olamaz",
                                ),
                              ),
                            );
                            return;
                          }

                          String tarihYazisi =
                              "${secilenTarih.day}.${secilenTarih.month}.${secilenTarih.year}";

                          // Otobüs mü Uçak mı?
                          if (otobusSecili == true) {
                            // Otobüs seçiliyse 
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeferListesiScreen(
                                  nereden: nereden,
                                  nereye: nereye,
                                  tarih: tarihYazisi,
                                ),
                              ),
                            );
                          } else {
                            // Uçak seçiliyse 
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UcakListesiScreen(
                                  nereden: nereden,
                                  nereye: nereye,
                                  tarih: tarihYazisi,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          // Butonun üzerindeki yazı seçime göre değişiyor
                          otobusSecili
                              ? "Otobüs Bileti Bul"
                              : "Uçak Bileti Bul",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _basitSatir(String baslik, String sehir, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                baslik,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
              Text(
                sehir,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ],
      ),
    );
  }

  void _sehirListesiniAc(bool neredenMiDegisiyor) {
    if (sehirler.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Şehirler yükleniyor, lütfen bekleyin..."),
        ),
      );
      return;
    }

    List<String> gosterilecekListe = [];

    if (otobusSecili) {
      gosterilecekListe = List.from(sehirler);
    }
    else {
      List<String> havalimanlari = [
        "İstanbul",
        "Ankara",
        "İzmir",
        "Antalya",
        "Trabzon",
        "Adana",
        "Gaziantep",
        "Dalaman",
        "Bodrum",
        "Van",
        "Erzurum",
        "Samsun",
        "Diyarbakır",
        "Kayseri",
      ];

      // Veritabanındaki şehirlerle havalimanı olanları karşılaştırıyorum
      for (String sehir in sehirler) {
        if (havalimanlari.contains(sehir)) {
          gosterilecekListe.add(sehir);
        }
      }
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 400,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                otobusSecili
                    ? (neredenMiDegisiyor
                          ? "Nereden Kalkacak?"
                          : "Nereye Gidecek?")
                    : (neredenMiDegisiyor
                          ? "Hangi Havalimanı?"
                          : "Hangi Şehre Uçuş?"),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),

              Expanded(
                child: gosterilecekListe.isEmpty
                    ? const Center(
                        child: Text("Aradığınız kriterde şehir bulunamadı."),
                      )
                    : ListView.builder(
                        itemCount: gosterilecekListe.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(
                              otobusSecili
                                  ? Icons.location_city
                                  : Icons.airplanemode_active,
                              color: const Color(0xFF1E88E5),
                            ),
                            title: Text(
                              gosterilecekListe[index],
                              style: const TextStyle(fontSize: 16),
                            ),
                            onTap: () {
                              setState(() {
                                if (neredenMiDegisiyor) {
                                  nereden = gosterilecekListe[index];
                                } else {
                                  nereye = gosterilecekListe[index];
                                }
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _takvimiAc(BuildContext context) async {
    final DateTime? secilen = await showDatePicker(
      context: context,
      initialDate: secilenTarih,
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
    );
    if (secilen != null) {
      setState(() {
        secilenTarih = secilen;
      });
    }
  }

  Future<void> sahteSeferlerUret() async {
    // Kullanıcıya bilgi veriyorum
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Seferler oluşturuluyor...")));

    var firestore = FirebaseFirestore.instance;
    var random = Random();

    var snapshot = await firestore.collection('sehirler').get();

    List<String> kayitliSehirler = [];
    for (var doc in snapshot.docs) {
      if (doc.data().containsKey('isim')) {
        kayitliSehirler.add(doc['isim']);
      }
    }

    if (kayitliSehirler.isEmpty) return;

    List<String> firmalar = [
      "Kamil Koç",
      "Pamukkale",
      "Metro",
      "Varan",
      "Ali Osman Ulusoy",
      "Nilüfer",
    ];

    var batch = firestore.batch();
    int sayac = 0;

    // 300 Tane Rastgele Sefer Üretiyorum
    for (int i = 0; i < 300; i++) {
      String nereden = kayitliSehirler[random.nextInt(kayitliSehirler.length)];
      String nereye = kayitliSehirler[random.nextInt(kayitliSehirler.length)];

      if (nereden == nereye) continue; 

      // Veriyi hazırla
      var yeniRef = firestore.collection('seferler').doc();

      batch.set(yeniRef, {
        'nereden': nereden,
        'nereye': nereye,
        'firma': firmalar[random.nextInt(firmalar.length)],
        'fiyat': 350 + random.nextInt(600), 
        'saat': "${6 + random.nextInt(18)}:${random.nextBool() ? '00' : '30'}",
        'doluErkek': List.generate(
          random.nextInt(5),
          (index) => random.nextInt(30) + 1,
        ),
        'doluKadin': List.generate(
          random.nextInt(5),
          (index) => random.nextInt(30) + 1,
        ),
      });

      sayac++;

      if (sayac >= 450) { //Firebasein limitinden dolayı
        await batch.commit();
        batch = firestore.batch();
        sayac = 0;
      }
    }

    if (sayac > 0) {
      await batch.commit();
    }

    print("✅ 300 Sefer başarıyla eklendi.");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ İşlem Tamam!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> sahteUcakSeferleriUret() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(" Veritabanı ile uyumlu uçak seferleri üretiliyor..."),
      ),
    );

    var firestore = FirebaseFirestore.instance;
    var random = Random();
    var batch = firestore.batch();

    var snapshot = await firestore.collection('sehirler').get();

    List<String> dbSehirler = [];
    for (var doc in snapshot.docs) {
      if (doc.data().containsKey('isim')) {
        dbSehirler.add(doc['isim']);
      }
    }

    List<String> populerHavalimanlari = [
      "İstanbul",
      "Ankara",
      "İzmir",
      "Antalya",
      "Trabzon",
      "Adana",
      "Gaziantep",
      "Dalaman",
      "Bodrum",
      "Van",
      "Erzurum",
      "Samsun",
      "Diyarbakır",
      "Kayseri",
    ];

    List<String> kullanilacakSehirler = [];

    for (String dbSehir in dbSehirler) {
      if (populerHavalimanlari.contains(dbSehir)) {
        kullanilacakSehirler.add(dbSehir);
      }
    }

    if (kullanilacakSehirler.isEmpty) {
      print(
        "UYARI: Veritabanı isimleriyle eşleşme bulunamadı, varsayılan liste kullanılıyor.",
      );
      kullanilacakSehirler = populerHavalimanlari;
    }

    List<String> firmalar = [
      "Türk Hava Yolları",
      "Pegasus",
      "AnadoluJet",
      "SunExpress",
    ];
    int sayac = 0;

    for (int i = 0; i < 200; i++) {
      String nereden =
          kullanilacakSehirler[random.nextInt(kullanilacakSehirler.length)];
      String nereye =
          kullanilacakSehirler[random.nextInt(kullanilacakSehirler.length)];

      if (nereden == nereye) continue;

      var yeniRef = firestore.collection('ucak_seferleri').doc();

      int fiyat = 800 + random.nextInt(2200);

      batch.set(yeniRef, {
        'nereden': nereden,
        'nereye': nereye,
        'firma': firmalar[random.nextInt(firmalar.length)],
        'fiyat': fiyat,
        'saat':
            "${random.nextInt(24).toString().padLeft(2, '0')}:${random.nextBool() ? '00' : '30'}",
        'sure': "${random.nextInt(2) + 1}sa ${random.nextInt(50)}dk",
        'ucusKodu': "TK${1000 + random.nextInt(8999)}",
      });

      sayac++;
      if (sayac >= 450) {
        await batch.commit();
        batch = firestore.batch();
        sayac = 0;
      }
    }

    if (sayac > 0) await batch.commit();

    print("✅ Uyumlu uçak veritabanı hazır!");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ Uçak seferleri eklendi!"),
        backgroundColor: Colors.green,
      ),
    );
  }
}
