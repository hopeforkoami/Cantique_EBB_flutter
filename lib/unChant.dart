import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
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
  List<String> emptyRefrain = ["<p>&nbsp;</p>", "<p>\n\n</p>"];
  dynamic donnees = [];
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
          });
          log("le current id est " + currentId.toString());
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
                  Column(
                    children: [
                      Text(
                        /*(leNumero + 1).toString() +
                            " . " +
                            donnees[leNumero.toString()]["titre"].toString()*/
                        title,
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        width: 350,
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
                      child: Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          color: Color(0xFF97524F),
                          child: Center(
                              child: Text(
                            "Texte",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: csts.primaryFont,
                                decorationColor: Colors.white,
                                decorationThickness: 5),
                          )))),
                  Expanded(child: Center(child: Text("Partition"))),
                  Expanded(child: Center(child: Text("Details")))
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
                    return ListView.builder(
                        itemCount: int.parse(
                            donnees[currentId.toString()]["nb_paragraphe"]),
                        itemBuilder: (context, index) {
                          if ((index == 0) &&
                              (!emptyRefrain.contains(
                                  donnees[currentId.toString()]["refrain"]
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
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  (index + 1).toString() +
                                                      " . ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Html(
                                                  data: donnees[currentId
                                                              .toString()][
                                                          "paraph_" +
                                                              (index + 1)
                                                                  .toString()]
                                                      .toString(),
                                                  style: {
                                                    "body": Style(
                                                        fontSize:
                                                            FontSize(16.0),
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal),
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
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Refrain . ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Html(
                                                  data: donnees[leNumero
                                                              .toString()]
                                                          ["refrain"]
                                                      .toString(),
                                                  style: {
                                                    "body": Style(
                                                        fontSize:
                                                            FontSize(16.0),
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal),
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
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              (index + 1).toString() + " . ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Html(
                                              data:
                                                  donnees[currentId.toString()][
                                                          "paraph_" +
                                                              (index + 1)
                                                                  .toString()]
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
