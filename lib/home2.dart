import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import './csts/Constantes.dart';
import 'search.dart';
import 'unChant.dart';

class Home2 extends StatefulWidget {
  const Home2({Key? key}) : super(key: key);

  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  Constantes csts = Constantes();
  dynamic donnees = [];

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('db/songs.json');
    final data = await json.decode(response);
    setState(() {
      donnees = data;
    });
  }

  int getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 600) return 1; // Téléphones
    if (width < 900) return 2; // Petites tablettes
    return 3; // Tablettes larges / desktop
  }

  double getFontSize(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 600) return 14;
    if (width < 900) return 16;
    return 18;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            // Header
            Container(
              color: const Color(0xFF5A1515),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(child: Container()),
                  Text(
                    "Cantique",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: getFontSize(context) + 2,
                      fontFamily: "NoticaText",
                    ),
                  ),
                  Expanded(child: Container()),
                  IconButton(
                    icon: const Icon(Icons.search_rounded,
                        size: 30, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Search()),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Liste des cantiques
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                child: FutureBuilder(
                  future: readJson(),
                  builder: (context, snapshot) {
                    if (donnees.isNotEmpty) {
                      bool isMobile = MediaQuery.of(context).size.width < 600;

                      if (isMobile) {
                        // 📱 Design mobile : grille comme ton code original
                        return GridView.builder(
                          itemCount: donnees.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UnChant(
                                      nbre: int.parse(
                                          donnees[index.toString()]["id"]),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    // ID du chant
                                    Container(
                                      decoration: BoxDecoration(
                                        color: csts.primaryColor,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Center(
                                        child: Text(
                                          donnees[index.toString()]["id"]
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Titre du chant
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: csts.secondaryColor,
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Center(
                                          child: Html(
                                            data: donnees[index.toString()]
                                                    ["titre"]
                                                .toString(),
                                            style: {
                                              "body": Style(
                                                fontSize: FontSize(14.0),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        // 💻 Design tablette/desktop : liste simple
                        return ListView.builder(
                          itemCount: donnees.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              tileColor: index % 2 == 0
                                  ? csts.secondaryColor.withOpacity(0.2)
                                  : Colors.transparent,
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: csts.primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  donnees[index.toString()]["id"].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              title: Html(
                                data: donnees[index.toString()]["titre"]
                                    .toString(),
                                style: {
                                  "body": Style(
                                    fontSize: FontSize(16.0),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    margin: Margins.zero,
                                  ),
                                },
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UnChant(
                                      nbre: int.parse(
                                          donnees[index.toString()]["id"]),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),

            // Footer
            Container(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                color: csts.primaryColor,
                child: Center(
                  child: Text(
                    "\u00a9 Eglises Baptistes ",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: csts.primaryFont,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
