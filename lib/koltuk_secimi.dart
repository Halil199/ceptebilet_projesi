import 'package:flutter/material.dart';
import 'odeme_ekrani.dart';

class KoltukSecimiScreen extends StatefulWidget {
  final String nereden;
  final String nereye;
  final String tarih;
  final String saat;
  final String fiyat;
  final List<dynamic> doluKoltuklarErkek;
  final List<dynamic> doluKoltuklarKadin;

  const KoltukSecimiScreen({
    super.key,
    required this.nereden,
    required this.nereye,
    required this.tarih,
    required this.saat,
    required this.fiyat,
    required this.doluKoltuklarErkek,
    required this.doluKoltuklarKadin,
  });

  @override
  State<KoltukSecimiScreen> createState() => _KoltukSecimiScreenState();
}

class _KoltukSecimiScreenState extends State<KoltukSecimiScreen> {
  Map<int, String> secilenKoltuklar = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Koltuk Seçimi"),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[200], 
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: const [
                    Icon(Icons.door_sliding, size: 40, color: Colors.grey),
                    Text("Kapı", style: TextStyle(fontSize: 10)),
                  ],
                ),
                Column(
                  children: const [
                    Icon(Icons.circle_outlined, size: 40, color: Colors.grey),
                    Text("Şoför", style: TextStyle(fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 10, 
              itemBuilder: (context, index) {
                int sirabasi = index * 4; 
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _tekKoltuk(sirabasi + 1),
                      const SizedBox(width: 8),
                      _tekKoltuk(sirabasi + 2),
                      
                      const SizedBox(width: 40), 

                      _tekKoltuk(sirabasi + 3),
                      const SizedBox(width: 8),
                      _tekKoltuk(sirabasi + 4),
                    ],
                  ),
                );
              },
            ),
          ),

          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _renkKutusu(Colors.white, "Boş", true),
                _renkKutusu(Colors.pink[100]!, "Dolu (K)", false),
                _renkKutusu(Colors.blue[100]!, "Dolu (E)", false),
                _renkKutusu(Colors.green, "Seçilen", false),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${secilenKoltuklar.length} Koltuk Seçildi", style: const TextStyle(fontSize: 12)),
                      Text(
                        "${secilenKoltuklar.length * int.parse(widget.fiyat)} ₺",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E88E5)),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  onPressed: secilenKoltuklar.isEmpty ? null : () {
                    int toplamTutar = secilenKoltuklar.length * int.parse(widget.fiyat);
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => OdemeEkrani(toplamTutar: toplamTutar.toString())
                      )
                    );
                  },
                  child: const Text("DEVAM ET"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _koltukIslemi(int numara) {
    if (widget.doluKoltuklarErkek.contains(numara) || widget.doluKoltuklarKadin.contains(numara)) {
      _uyariGoster("Bu koltuk maalesef dolu.");
      return;
    }

    if (secilenKoltuklar.containsKey(numara)) {
      setState(() {
        secilenKoltuklar.remove(numara);
      });
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Yolcu Cinsiyeti"),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.female, color: Colors.pink),
            label: const Text("KADIN", style: TextStyle(color: Colors.pink)),
            onPressed: () {
              Navigator.pop(context);
              _kuralKontroluVeEkle(numara, "Kadın");
            },
          ),
          TextButton.icon(
            icon: const Icon(Icons.male, color: Colors.blue),
            label: const Text("ERKEK", style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.pop(context);
              _kuralKontroluVeEkle(numara, "Erkek");
            },
          ),
        ],
      ),
    );
  }

  void _kuralKontroluVeEkle(int numara, String cinsiyet) {
    int yanKoltukNo = -1;

    if (numara % 2 != 0) {
      yanKoltukNo = numara + 1; 
    } else {
      yanKoltukNo = numara - 1; 
    }


    bool yanDoluMu = widget.doluKoltuklarErkek.contains(yanKoltukNo) || widget.doluKoltuklarKadin.contains(yanKoltukNo);
    
    bool yanBendeMi = secilenKoltuklar.containsKey(yanKoltukNo);

    if (yanDoluMu && !yanBendeMi) {
      bool yanErkek = widget.doluKoltuklarErkek.contains(yanKoltukNo);
      if (yanErkek && cinsiyet == "Kadın") {
        _uyariGoster("Bay yanına Bayan yolcu seçilemez!");
        return;
      }
      if (!yanErkek && cinsiyet == "Erkek") {
         _uyariGoster("Bayan yanına Bay yolcu seçilemez!");
         return;
      }
    }

    setState(() {
      secilenKoltuklar[numara] = cinsiyet;
    });
  }

  void _uyariGoster(String mesaj) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mesaj), backgroundColor: Colors.red));
  }


  Widget _tekKoltuk(int numara) {
    bool doluE = widget.doluKoltuklarErkek.contains(numara);
    bool doluK = widget.doluKoltuklarKadin.contains(numara);
    bool secili = secilenKoltuklar.containsKey(numara);

    Color koltukRengi = Colors.white;
    Color kenarRengi = Colors.grey;
    if (doluE) { koltukRengi = Colors.blue[100]!; kenarRengi = Colors.blue; }
    else if (doluK) { koltukRengi = Colors.pink[100]!; kenarRengi = Colors.pink; }
    else if (secili) { koltukRengi = Colors.green; kenarRengi = Colors.green[800]!; }

    return GestureDetector(
      onTap: () => _koltukIslemi(numara),
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: koltukRengi,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: kenarRengi, width: 2),
          boxShadow: [
             if(!doluE && !doluK) 
               BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(2, 2))
          ]
        ),
        child: Center(
          child: secili 
            ? Icon(secilenKoltuklar[numara] == "Kadın" ? Icons.female : Icons.male, color: Colors.white)
            : Text("$numara", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
        ),
      ),
    );
  }

  Widget _renkKutusu(Color renk, String yazi, bool kenarlik) {
    return Row(
      children: [
        Container(
          width: 15, height: 15,
          decoration: BoxDecoration(
            color: renk, 
            borderRadius: BorderRadius.circular(4),
            border: kenarlik ? Border.all(color: Colors.grey) : null
          ),
        ),
        const SizedBox(width: 5),
        Text(yazi, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}