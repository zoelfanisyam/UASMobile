import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:my_quran/app/data/db/bookmark.dart';
import 'package:my_quran/app/data/models/detail_surah.dart';

import 'package:scroll_to_index/scroll_to_index.dart';

import 'package:sqflite/sqflite.dart';

class DetailSurahController extends GetxController {
  AutoScrollController scrollC = AutoScrollController();
  DatabaseManager database = DatabaseManager.instance;
  Future<void> addBookmark(
      bool lastRead, DetailSurah surah, Verse ayat, int indexAyat) async {
    Database db = await database.db;
    bool flagExist = false;
    if (lastRead == true) {
      await db.delete("bookmark", where: "last_read = 1");
    } else {
      List checkData = await db.query("bookmark",
          where:
              "surah = '${surah.name!.transliteration!.id!.replaceAll("'", "+")}' and number_surah ='${surah.number!}'  and ayat ='${ayat.number!.inSurah}' and index_ayat = '${indexAyat}' and last_read = 0 ");
      if (checkData.length != 0) {
        //ada data
        flagExist = true;
      }
    }

    if (flagExist == false) {
      db.insert("bookmark", {
        "surah": "${surah.name!.transliteration!.id!.replaceAll("'", "+")}",
        "number_surah": surah.number!,
        "ayat": ayat.number!.inSurah!,
        "index_ayat": indexAyat,
        "last_read": lastRead == true ? 1 : 0,
      });

      Get.back(); //tutup dialog

      Get.snackbar("Berhasil", "Berhasil menambahkan bookmark");
    } else {
      Get.back(); //tutup dialog
      Get.snackbar("Terjadi kesalahan", "bookmark telah tersedia");
    }

    var data = await db.query("bookmark");
    print(data);
  }

  Future<DetailSurah> getDetailSurah(String id) async {
    Uri url = Uri.parse("https://api.quran.gading.dev/surah/$id");
    var res = await http.get(url);

    Map<String, dynamic> data =
        (json.decode(res.body) as Map<String, dynamic>)["data"];

    return DetailSurah.fromJson(data);
  }
}
