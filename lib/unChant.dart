import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import './csts/Constantes.dart';
import 'customed/Chant.dart';
import 'package:universal_html/html.dart' as html;

class UnChant extends StatefulWidget {
  final int nbre;
  const UnChant({Key? key, required this.nbre}) : super(key: key);

  @override
  State<UnChant> createState() => _UnChantState(nbre);
}

class _UnChantState extends State<UnChant> {
  Constantes csts = new Constantes();
  int leNumero;
  int currentId = 0;
  String title = "Song Title";
  String original = "(Song Original title)";
  String auteur = "";
  String traducteur = "";
  String receuil = "";
  String theme = "";
  List<String> emptyRefrain = ["<p>&nbsp;</p>", "<p>\n\n</p>"];
  dynamic donnees = [];
  String typeAffichage = "text";
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('db/songs.json');
    final data = await json.decode(response);
    if (data != null) {
      for (int i = 0; i < data["Size"]; i++) {
        if (int.parse(data[i.toString()]["id"].toString()) == leNumero) {
          /*log("le cantique choisit est le " +
              leNumero.toString() +
              " et le id du chant est " +
              data[i.toString()]["id"].toString());*/
          //leNumero = i;
          setState(() {
            currentId = i;
            donnees = data;
            title = data[i.toString()]["id"].toString() +
                " .  " +
                data[i.toString()]["titre"].toString();
            original = data[i.toString()]["description"].toString();
            auteur = data[i.toString()]["auteur"] == null
                ? "unverifed"
                : data[i.toString()]["auteur"].toString();
            traducteur = data[i.toString()]["traducteur"] == null
                ? "unverifed"
                : data[i.toString()]["traducteur"].toString();
            receuil = data[i.toString()]["receuil"] == null
                ? "unverifed"
                : data[i.toString()]["receuil"].toString();
            theme = data[i.toString()]["theme"] == null
                ? "unverifed"
                : data[i.toString()]["theme"].toString();
          });
          //log("le current id est " + currentId.toString());
        }
      }
    }

    //log(donnees[1.toString()]["titre"].toString());
    //log("longueur" + donnees.length.toString());
  }

  _UnChantState(this.leNumero);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            Container(
              color: Color(0xFF5A1515),
              padding: EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        size: 40, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        Html(data: title, style: {
                          "body": Style(
                              fontSize: FontSize(14.0),
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        }),
                        /*Text(
                          /*(leNumero + 1).toString() +
                              " . " +
                              donnees[leNumero.toString()]["titre"].toString()*/
                          title,
                          style: TextStyle(color: Colors.white),
                        ),*/
                        Container(
                          //width: 350,
                          height: 3,
                          color: Colors.white,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width * 0.8,
                          alignment: Alignment.centerRight,
                          child: Text(
                            original,
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                width: 3,
                color: Color(0xFF5A1515),
              ))),
              child: Row(
                children: [
                  Expanded(
                      child: InkWell(
                    child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        color:
                            typeAffichage == "text" ? Color(0xFF97524F) : null,
                        child: Center(
                            child: Text(
                          "Texte",
                          style: TextStyle(
                              fontSize: 16,
                              color: typeAffichage == "text"
                                  ? Colors.white
                                  : Colors.black,
                              fontFamily: csts.primaryFont,
                              decorationColor: Colors.white,
                              decorationThickness: 5),
                        ))),
                    onTap: () => updateAffichage("text"),
                  )),
                  Expanded(
                      child: InkWell(
                    child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        color:
                            typeAffichage == "note" ? Color(0xFF97524F) : null,
                        child: Center(
                            child: Text(
                          "Partition",
                          style: TextStyle(
                              fontSize: 16,
                              color: typeAffichage == "note"
                                  ? Colors.white
                                  : Colors.black,
                              fontFamily: csts.primaryFont,
                              decorationColor: Colors.white,
                              decorationThickness: 5),
                        ))),
                    onTap: () => updateAffichage("note"),
                  )),
                  Expanded(
                      child: InkWell(
                    child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        color: typeAffichage == "details"
                            ? Color(0xFF97524F)
                            : null,
                        child: Center(
                            child: Text(
                          "Details",
                          style: TextStyle(
                              fontSize: 16,
                              color: typeAffichage == "details"
                                  ? Colors.white
                                  : Colors.black,
                              fontFamily: csts.primaryFont,
                              decorationColor: Colors.white,
                              decorationThickness: 5),
                        ))),
                    onTap: () => updateAffichage("details"),
                  )),
                ],
              ),
            ),
            Expanded(
                child: Container(
                    padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: generateContent())),
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

  Widget generateContent() {
    readJson();
    log(typeAffichage);
    if (typeAffichage == "text") {
      return FutureBuilder(
        future: readJson(),
        builder: (context, snapshot) {
          if (donnees.isNotEmpty) {
            //log("le nombre d element " + donnees.length.toString());
            return ListView.builder(
                itemCount:
                    int.parse(donnees[currentId.toString()]["nb_paragraphe"]),
                itemBuilder: (context, index) {
                  if ((index == 0) &&
                      (!emptyRefrain.contains(donnees[currentId.toString()]
                              ["refrain"]
                          .toString()))) {
                    return (Container(
                      //padding: EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: [
                          InkWell(
                            child: Container(
                              child: Container(
                                //padding: EdgeInsets.only(top: 10, bottom: 10),
                                margin: EdgeInsets.only(top: 10.0),
                                decoration: BoxDecoration(
                                  // color: Colors.green,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15)),
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          (index + 1).toString() + " . ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Html(
                                          data: donnees[currentId.toString()][
                                                  "paraph_" +
                                                      (index + 1).toString()]
                                              .toString(),
                                          style: {
                                            "body": Style(
                                                fontSize: FontSize(16.0),
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal),
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            onTap: () => null,
                          ),
                          InkWell(
                            child: Container(
                              child: Container(
                                //padding: EdgeInsets.only(top: 10, bottom: 10),
                                margin: EdgeInsets.only(top: 10.0),
                                decoration: BoxDecoration(
                                  // color: Colors.green,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15)),
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Refrain . ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Html(
                                          data: donnees[currentId.toString()]
                                                  ["refrain"]
                                              .toString(),
                                          style: {
                                            "body": Style(
                                                fontSize: FontSize(16.0),
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal),
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            onTap: () => null,
                          )
                        ],
                      ),
                    ));
                  } else {
                    return (Container(
                      //padding: EdgeInsets.only(left: 15, right: 15),
                      child: InkWell(
                        child: Container(
                          child: Container(
                            //padding: EdgeInsets.only(top: 10, bottom: 10),
                            margin: EdgeInsets.only(top: 10.0),
                            decoration: BoxDecoration(
                              // color: Colors.green,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      (index + 1).toString() + " . ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Html(
                                      data: donnees[currentId.toString()][
                                              "paraph_" +
                                                  (index + 1).toString()]
                                          .toString(),
                                      style: {
                                        "body": Style(
                                            fontSize: FontSize(16.0),
                                            color: Colors.black),
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: () => null,
                      ),
                    ));
                  }
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );
    } else if (typeAffichage == "note") {
      return Center(
        child: Text("La Partition n'est pas encore disponible"),
      );
    } else if (typeAffichage == "details") {
      return detailSection();
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  updateAffichage(String s) {
    setState(() {
      typeAffichage = s;
    });
  }

  Widget detailSection() {
    TextStyle style_text_libelle = TextStyle(
        color: Colors.black,
        fontFamily: csts.primaryFont,
        fontWeight: FontWeight.bold,
        fontSize: 16);
    TextStyle style_text_valeur = TextStyle(
        color: Colors.black87, fontFamily: csts.primaryFont, fontSize: 14);
    String baseUrl = "https://www.youtube.com/results?search_query=";
    String callUrl = "";
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          margin: EdgeInsets.only(bottom: 50),
          //details text
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Titre : ",
                    style: style_text_libelle,
                  )),
                  Expanded(
                      child: Html(data: title, style: {
                    "body": Style(
                        fontSize: FontSize(14.0),
                        color: Colors.black,
                        fontFamily: csts.primaryFont,
                        fontWeight: FontWeight.normal),
                  })),
                ],
              ),
              Container(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text("Original : ", style: style_text_libelle)),
                  Expanded(child: Text(original, style: style_text_valeur))
                ],
              ),
              Container(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(child: Text("Auteur : ", style: style_text_libelle)),
                  Expanded(child: Text(auteur, style: style_text_valeur))
                ],
              ),
              Container(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text("Traducteur : ", style: style_text_libelle)),
                  Expanded(child: Text(traducteur, style: style_text_valeur))
                ],
              ),
              Container(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text("Receuil : ", style: style_text_libelle)),
                  Expanded(child: Text(receuil, style: style_text_valeur))
                ],
              ),
              Container(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(child: Text("Theme : ", style: style_text_libelle)),
                  Expanded(child: Text(theme, style: style_text_valeur))
                ],
              ),
            ],
          ),
        ),
        Expanded(
          //video or audio link
          child: InkWell(
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                  color: csts.primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Center(
                child: Icon(
                  Icons.play_circle_fill_outlined,
                  color: Colors.white,
                  size: 70,
                ),
              ),
            ),
            onTap: () =>
                {_launchInBrowser(baseUrl + updateStringForResearch())},
          ),
        ),
        Container(
          height: 50,
        )
      ],
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String updateStringForResearch() {
    String retour = "";
    //remove parentesises on the original
    if (original != "<p>&nbsp;</p>") {
      String rech = original.replaceAll(new RegExp(r'[^\w\s]+'), '');
      retour = rech.replaceAll(" ", "+");
    }

    return retour;
  }
}
