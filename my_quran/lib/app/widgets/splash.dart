import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: SvgPicture.asset(
            'assets/splash.svg',
            width: 290,
            height: 178,
          ),
        ),
      ),
    );
  }
}
// Expanded(
//                 child: TabBarView(children: [
//                   FutureBuilder<List<Surah>>(
//                       future: controller.getAllSurah(),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//                         if (!snapshot.hasData) {
//                           return Center(
//                             child: Text("perikas koneksi  anda"),
//                           );
//                         }
//                         return ListView.builder(
//                             itemCount: snapshot.data!.length,
//                             itemBuilder: (context, index) {
//                               Surah surah = snapshot.data![index];
//                               return ListTile(
//                                 onTap: () {
//                                   Get.toNamed(Routes.DETAIL_SURAH,
//                                       arguments: surah);
//                                 },
//                                 leading: Stack(
//                                   children: [
//                                     SvgPicture.asset('assets/nomor-surah.svg'),
//                                     SizedBox(
//                                       height: 36,
//                                       width: 36,
//                                       child: Center(
//                                           child: Text(
//                                         "${surah.number}",
//                                         style: GoogleFonts.poppins(
//                                             color: Color(0xFF240F4F),
//                                             fontWeight: FontWeight.w500),
//                                       )),
//                                     )
//                                   ],
//                                 ),
//                                 title: Text(
//                                   "${surah.name?.transliteration?.id ?? 'error..'}",
//                                   style: GoogleFonts.poppins(
//                                       color: Color(0xFF240F4F),
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 16),
//                                 ),
//                                 subtitle: Text(
//                                   "${surah.numberOfVerses} Ayat | ${surah.revelation?.id}",
//                                   style: GoogleFonts.poppins(
//                                       color: Color(0xFF8789A3),
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 12),
//                                 ),
//                                 trailing: Text(
//                                   "${surah.name?.short ?? 'Error..'}",
//                                   style: GoogleFonts.amiri(
//                                       color: Color(0xFF240F4F),
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               );
//                             });
//                       }),
//                   Center(child: Text("page 1")),
//                   Center(child: Text("page 1")),
//                 ]),
//               )
