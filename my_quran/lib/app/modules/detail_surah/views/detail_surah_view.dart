import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_quran/app/data/models/detail_surah.dart' as detail;

import 'package:my_quran/app/modules/home/controllers/home_controller.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../controllers/detail_surah_controller.dart';

class DetailSurahView extends GetView<DetailSurahController> {
  final homeC = Get.find<HomeController>();
  Map<String, dynamic>? bookmark;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFFFFFF),
          centerTitle: true,
          elevation: 0,
          title: Text(
            "${Get.arguments["name"]}",
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Color(0xFF672CBC),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: FutureBuilder<detail.DetailSurah>(
          future: controller.getDetailSurah(Get.arguments["number"].toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: Text("tidak ada data"),
              );
            }
            if (Get.arguments["bookmark"] != null) {
              dynamic bookmark = Get.arguments["bookmark"];
              if (bookmark != null && bookmark["index_ayat"] != null) {
                int? indexAyat =
                    int.tryParse(bookmark["index_ayat"].toString());
                if (indexAyat != null) {
                  print("INDEX AYAT: $indexAyat");
                  print("GO TO INDEX AUTO SCROLL: ${indexAyat + 2}");
                  controller.scrollC.scrollToIndex(indexAyat + 2,
                      preferPosition: AutoScrollPosition.begin);
                }
              }
            }

            print(bookmark);
            detail.DetailSurah surah = snapshot.data!;
            List<Widget> allAyat =
                List.generate(snapshot.data?.verses?.length ?? 0, (index) {
              detail.Verse? ayat = snapshot.data?.verses?[index];
              return AutoScrollTag(
                key: ValueKey(index + 2),
                index: index + 2,
                controller: controller.scrollC,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xff121931).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                SvgPicture.asset(
                                  'assets/nomor-surah.svg',
                                  fit: BoxFit.contain,
                                  width: 32,
                                  height: 32,
                                ),
                                SizedBox(
                                  height: 32,
                                  width: 32,
                                  child: Center(
                                      child: Text(
                                    "${index + 1}",
                                    style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: Color(0xFF240F4F),
                                        fontWeight: FontWeight.w500),
                                  )),
                                )
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                Get.defaultDialog(
                                    title: "Bookmark",
                                    titleStyle: GoogleFonts.poppins(
                                      fontSize: 20,
                                      color: Color(0xFF672CBC),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    middleText: "simpan sebagai",
                                    middleTextStyle: GoogleFonts.poppins(
                                      color: Color(0xFF240F4F),
                                      fontSize: 14,
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          await controller.addBookmark(true,
                                              snapshot.data!, ayat!, index);
                                          homeC.update();
                                        },
                                        child: Text("Last Read"),
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            controller.addBookmark(false,
                                                snapshot.data!, ayat!, index);
                                          },
                                          child: Text("Bookmark")),
                                    ]);
                              },
                              icon: Icon(
                                Icons.bookmark_outline,
                              ),
                              color: Color(0xFF863ED5),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "${ayat!.text?.arab}",
                      textAlign: TextAlign.end,
                      style: GoogleFonts.amiri(
                        color: Color(0xFF240F4F),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "${ayat.translation?.id}",
                      style: GoogleFonts.poppins(
                        color: Color(0xFF240F4F),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            });
            // sudah ada data
            return ListView(
              controller: controller.scrollC,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                AutoScrollTag(
                  key: ValueKey(0),
                  index: 0,
                  controller: controller.scrollC,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xFF863ED5).withOpacity(.6),
                            spreadRadius: -6,
                            blurRadius: 20,
                            offset: Offset(0, 7)),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [
                            0,
                            .6,
                            1
                          ],
                          colors: [
                            Color(0xFFDF98FA),
                            Color(0xFFB070FD),
                            Color(0xFF9055FF)
                          ]),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 20),
                      child: Column(
                        children: [
                          Text(
                            "( ${surah.name?.translation?.id} )",
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                          Text(
                            "${surah.revelation?.id}  |  ${surah.numberOfVerses} ayat",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SvgPicture.asset('assets/bismillah.svg')
                        ],
                      ),
                    ),
                  ),
                ),
                AutoScrollTag(
                  key: ValueKey(1),
                  index: 1,
                  controller: controller.scrollC,
                  child: const SizedBox(
                    height: 20,
                  ),
                ),
                ...allAyat,
              ],
            );
          },
        ));
  }
}
