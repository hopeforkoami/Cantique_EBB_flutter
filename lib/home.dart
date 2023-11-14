import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cantique_ebb_flutter/search.dart';
import 'package:cantique_ebb_flutter/unChant.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import './csts/Constantes.dart';
import 'customed/chant.dart';
import 'package:universal_html/html.dart' as html;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Constantes csts = new Constantes();
  dynamic donnees = [];
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('db/songs.json');
    final data = await json.decode(response);
    setState(() {
      donnees = data;
    });
    //log(donnees[1.toString()]["titre"].toString());
    //log("longueur" + donnees.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            Container(
              color: Color(0xFF5A1515),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, size: 30, color: Colors.white),
                    onPressed: () {
                      // ...
                    },
                  ),
                  Text("Cantique",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: "NoticaText")),
                  Expanded(child: Container()),
                  IconButton(
                    icon: const Icon(
                      Icons.search_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Search()),
                      );
                    },
                  )
                ],
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: FutureBuilder(
                future: readJson(),
                builder: (context, snapshot) {
                  if (donnees.isNotEmpty) {
                    //log("le nombre d element " + donnees.length.toString());

                    return GridView.builder(
                        itemCount: 257,
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
                                        donnees[index.toString()]["id"]
                                            .toString(),
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
                                                data: donnees[index.toString()]
                                                        ["titre"]
                                                    .toString(),
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
