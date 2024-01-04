import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_quran/app/data/models/surah.dart';
import 'package:my_quran/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Color(0xFFFFFFFF),
          appBar: AppBar(
            backgroundColor: Color(0xFFFFFFFF),
            automaticallyImplyLeading: false,
            centerTitle: true,
            elevation: 0,
            title: Text(
              'My Quran',
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Color(0xFF672CBC),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: GetBuilder<HomeController>(
            builder: (c) => FutureBuilder<Map<String, dynamic>?>(
              future: c.getLastRead(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) ;
                Map<String, dynamic>? lastRead = snapshot.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: 131,
                        width: Get.width,
                        child: InkWell(
                          onLongPress: () {
                            if (lastRead != null) {
                              Get.defaultDialog(
                                  title: "Hapus Last Read?",
                                  titleStyle: GoogleFonts.poppins(
                                    fontSize: 20,
                                    color: Color(0xFF672CBC),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  middleText:
                                      "yakin ingin menghapus last read?",
                                  middleTextStyle: GoogleFonts.poppins(
                                    color: Color(0xFF240F4F),
                                    fontSize: 14,
                                  ),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () => Get.back(),
                                        child: Text("Tidak")),
                                    ElevatedButton(
                                        onPressed: () {
                                          c.deleteBookmark(lastRead['id']);
                                        },
                                        child: Text("Ya"))
                                  ]);
                            } else {}
                          },
                          onTap: () {
                            if (lastRead != null) {
                              Get.toNamed(Routes.DETAIL_SURAH, arguments: {
                                "name": lastRead["surah"]
                                    .toString()
                                    .replaceAll("+", "'"),
                                "number": lastRead["number_surah"],
                                "bookmark": lastRead,
                              });
                            }
                          },
                          child: Stack(
                            children: [
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: SvgPicture.asset('assets/quran.svg')),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset('assets/book.svg'),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          'Last Read',
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    if (lastRead != null)
                                      Text(
                                        "${lastRead['surah'].toString().replaceAll("+", "'")}",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18),
                                      ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      lastRead == null
                                          ? "last read belum ada"
                                          : "ayat no: ${lastRead["ayat"]}",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
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
                                ])),
                      ),
                    ),
                    TabBar(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        unselectedLabelColor: Color(0xFF8789A3).withOpacity(.5),
                        labelColor: Color(0xFF672CBC),
                        indicatorColor: Color(0xFF672CBC),
                        indicatorWeight: 2,
                        dividerColor: Color(0xffffffff),
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: [
                          Tab(
                            child: Text("Surah",
                                style: GoogleFonts.poppins(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                          ),
                          Tab(
                            child: Text("Bookmark",
                                style: GoogleFonts.poppins(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                          ),
                        ]),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: TabBarView(children: [
                        FutureBuilder<List<Surah>>(
                            future: c.getAllSurah(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (!snapshot.hasData) {
                                return Center(
                                  child: Text("perikas koneksi  anda"),
                                );
                              }
                              return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    Surah surah = snapshot.data![index];
                                    return ListTile(
                                      onTap: () {
                                        Get.toNamed(Routes.DETAIL_SURAH,
                                            arguments: {
                                              "name": surah
                                                  .name!.transliteration!.id,
                                              "number": surah.number!,
                                            });
                                      },
                                      leading: Stack(
                                        children: [
                                          SvgPicture.asset(
                                              'assets/nomor-surah.svg'),
                                          SizedBox(
                                            height: 36,
                                            width: 36,
                                            child: Center(
                                                child: Text(
                                              "${surah.number}",
                                              style: GoogleFonts.poppins(
                                                  color: Color(0xFF240F4F),
                                                  fontWeight: FontWeight.w500),
                                            )),
                                          )
                                        ],
                                      ),
                                      title: Text(
                                        "${surah.name?.transliteration?.id ?? 'error..'}",
                                        style: GoogleFonts.poppins(
                                            color: Color(0xFF240F4F),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                      subtitle: Text(
                                        "${surah.numberOfVerses} Ayat | ${surah.revelation?.id}",
                                        style: GoogleFonts.poppins(
                                            color: Color(0xFF8789A3)
                                                .withOpacity(0.7),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12),
                                      ),
                                      trailing: Text(
                                        "${surah.name?.short ?? 'Error..'}",
                                        style: GoogleFonts.amiri(
                                            color: Color(0xFF240F4F),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  });
                            }),
                        GetBuilder<HomeController>(
                          builder: (c) {
                            return FutureBuilder<List<Map<String, dynamic>>>(
                              future: c.getBookmark(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (snapshot.data?.length == 0) {
                                  return Center(
                                    child: Text("belum ada bookmark"),
                                  );
                                }
                                return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> data =
                                        snapshot.data![index];
                                    return ListTile(
                                      onTap: () {
                                        Get.toNamed(Routes.DETAIL_SURAH,
                                            arguments: {
                                              "name": data["surah"]
                                                  .toString()
                                                  .replaceAll("+", "'"),
                                              "number": data["number_surah"],
                                              "bookmark": data,
                                            });
                                      },
                                      leading: Stack(
                                        children: [
                                          SvgPicture.asset(
                                              'assets/nomor-surah.svg'),
                                          SizedBox(
                                            height: 36,
                                            width: 36,
                                            child: Center(
                                                child: Text(
                                              "${index + 1}",
                                              style: GoogleFonts.poppins(
                                                  color: Color(0xFF240F4F),
                                                  fontWeight: FontWeight.w500),
                                            )),
                                          )
                                        ],
                                      ),
                                      title: Text(
                                        " ${data['surah'].toString().replaceAll("+", "'")}",
                                        style: GoogleFonts.poppins(
                                            color: Color(0xFF240F4F),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                      subtitle: Text(
                                        "ayat ${data['ayat']}",
                                        style: GoogleFonts.poppins(
                                            color: Color(0xFF8789A3)
                                                .withOpacity(0.7),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12),
                                      ),
                                      trailing: IconButton(
                                        onPressed: () {
                                          c.deleteBookmark(data['id']);
                                        },
                                        icon: Icon(
                                          Icons.delete_outline,
                                        ),
                                        color: Color(0xFF863ED5),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        )
                      ]),
                    )
                  ],
                );
              },
            ),
          )),
    );
  }
}
