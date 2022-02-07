//setstate ilgili widgedin build metodu tetiklenir.//
//initstate uygulama çalışrıeken 1 kere çalışır ve gereken atamalar yapılır.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_json_http/model/araba_model.dart';

class LocalJson extends StatefulWidget {
  const LocalJson({Key? key}) : super(key: key);

  @override
  State<LocalJson> createState() => _LocalJsonState();
}

class _LocalJsonState extends State<LocalJson> {
  String _title = "local json işlemleri";
  late final Future<List<Araba>> _listeyiDoldur;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listeyiDoldur = arabalarJsonOku();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Local json işlemleri"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _title = "buton tıklandı";
            });
          },
        ),
        body: FutureBuilder<List<Araba>>(
            future: _listeyiDoldur,
            initialData: [
              Araba(
                  arabaAdi: "aaa",
                  kurulusYil: 1988,
                  ulke: "afras",
                  model: [Model(modelAdi: "asd", fiyat: 18500, benzinli: true)])
            ], // internetten veri gelmesini beklerken localdekini gösterir instagramdaki gibi
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Araba> arabaListesi = snapshot.data!;

                return ListView.builder(
                  itemCount: arabaListesi.length,
                  itemBuilder: (context, index) {
                    Araba oankiAraba = arabaListesi[index];
                    return ListTile(
                      title: Text(oankiAraba.arabaAdi),
                      subtitle: Text(oankiAraba.ulke),
                      leading: CircleAvatar(
                          child: Text(
                              arabaListesi[index].model[0].fiyat.toString())),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }

  Future<List<Araba>> arabalarJsonOku() async {
    try {
      await Future.delayed(Duration(seconds: 5));
      var okunanString = await DefaultAssetBundle.of(context)
          .loadString('assets/data/arabalar.json');
      var jsonObject = jsonDecode(okunanString);

      // debugPrint(okunanString);
      // debugPrint("***********************");
      // (jsonObject as List).map((e) => debugPrint(e.toString()));

      List<Araba> tumArabalar = (jsonObject as List)
          .map((arabaMap) => Araba.fromMap(arabaMap))
          .toList();
      debugPrint(tumArabalar[0].model[0].modelAdi);
      debugPrint(tumArabalar.length.toString());

      return tumArabalar;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error(e.toString());
    }
  }
}
