import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cantique_ebb_flutter/unChant.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import './csts/Constantes.dart';
import 'customed/chant.dart';
import 'package:universal_html/html.dart' as html;

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Constantes csts = new Constantes();
  // dynamic donnees = [];
  // dynamic source = [];
  Map<String, dynamic> donnees = Map();
  Map<String, dynamic> source = Map();
  int donneesSize = 0;

  final TextEditingController _searchController = TextEditingController();
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('db/songs.json');
    final Map<String, dynamic> data = await json.decode(response);

    if (donnees.isEmpty) {
      setState(() {
        donnees = data;
        source = data;
        donneesSize = data["Size"];
      });
    }
    //log(donnees[1.toString()]["titre"].toString());
    //log("longueur" + donnees.length.toString());
  }

  Widget buildSongList() {
    return GridView.builder(
        itemCount: (donnees["Size"] != null) ? donnees["Size"] - 3 : 0,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10),
        itemBuilder: (context, index) {
          //log("index actuel" + index.toString());
          return (Container(
            child: InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: csts.primaryColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20))),
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Center(
                          child: Text(
                        (donnees[index.toString()] != null)
                            ? donnees[index.toString()]["id"].toString()
                            : "",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: csts.secondaryColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                        padding: EdgeInsets.only(left: 10, right: 10),
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                            child: Html(
                                data: (donnees[index.toString()] != null)
                                    ? donnees[index.toString()]["titre"]
                                        .toString()
                                    : "",
                                style: {
                              "body": Style(
                                  fontSize: FontSize(14.0),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            })),
                      ),
                    )
                  ],
                ),
              ),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UnChant(nbre: index)),
                )
              },
            ),
          ));
        });
  }

  void _runFilter(String filterWord) {
    Map<String, dynamic> temps = Map();
    if (filterWord.isEmpty) {
      donnees = source;
      temps = source;
    } else {
      if ((donnees != null) && (source != null)) {
        int cpt = 0;
        for (var i = 0; i < 257; i++) {
          if (source[i.toString()] != null) {
            //log("research value " + htmlEscape.convert(filterWord));
            if (/*(source[i.toString()]["titre"]
                    .toString()
                    .contains(filterWord)) ||*/
                (source[i.toString()]["id"].toString().contains(filterWord))) {
              temps[cpt.toString()] = source[i.toString()];
              cpt++;
            }
          }
        }
      } else {
        temps = source;
      }
    }
    setState(() {
      donnees = temps;
      donneesSize = temps.length;
    });

    //log(donnees.length.toString());
    // log(donnees[231.toString()]["titre"].toString());
  }

  @override
  Widget build(BuildContext context) {
    Widget songList = buildSongList();
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            Container(
              color: Color(0xFF5A1515),
              child: TextField(
                controller: _searchController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: "NoticaText"),
                decoration: InputDecoration(
                  hintText: 'Recherche...',
                  hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: "NoticaText"),
                  // Add a clear button to the search bar
                  suffixIcon: IconButton(
                    icon: Icon(Icons.restore_from_trash_outlined,
                        size: 30, color: Colors.white),
                    onPressed: () {
                      _searchController.clear();
                      _runFilter("");
                    },
                  ),
                  // Add a search icon or button to the search bar
                  prefixIcon: IconButton(
                    icon: Icon(Icons.arrow_back, size: 30, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  // border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(20.0),
                  // ),
                ),
                onChanged: (text) => _runFilter(text),
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: FutureBuilder(
                future: readJson(),
                builder: (context, snapshot) {
                  if (donnees.isNotEmpty) {
                    // log("le nombre d element " + donnees.length.toString());
                    // log(donnees[98.toString()].toString());

                    return GridView.builder(
                        itemCount: donneesSize,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, crossAxisSpacing: 10),
                        itemBuilder: (context, index) {
                          //log("index actuel" + index.toString());
                          return (Container(
                            child: InkWell(
                              child: Container(
                                padding: EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: csts.primaryColor,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              bottomLeft: Radius.circular(20))),
                                      height:
                                          MediaQuery.of(context).size.height,
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Center(
                                          child: Text(
                                        (donnees[index.toString()] != null)
                                            ? donnees[index.toString()]["id"]
                                                .toString()
                                            : "",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: csts.secondaryColor,
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20))),
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: Center(
                                            child: Html(
                                                data: (donnees[
                                                            index.toString()] !=
                                                        null)
                                                    ? donnees[index.toString()]
                                                            ["titre"]
                                                        .toString()
                                                    : "",
                                                style: {
                                              "body": Style(
                                                  fontSize: FontSize(14.0),
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            })),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UnChant(
                                          nbre: int.parse(
                                              donnees[index.toString()]
                                                  ["id"]))),
                                )
                              },
                            ),
                          ));
                        });
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            )),
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
                ))
          ],
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton:
      //     FloatingActionButton(onPressed: null, child: Icon(Icons.menu)),
    );
  }
}
