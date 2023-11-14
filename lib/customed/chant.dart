import 'package:cantique_ebb_flutter/customed/paragraphe.dart';

class Chant {
  int id;
  String titre;
  String auteur;
  int nbreParagraphe;
  String recueil;
  bool hasRefrain;
  bool hasPartition;
  bool hasYoutube;
  String traducteur;
  String original;
  String source;
  String theme;
  String edition;
  String youtubeLink;
  bool hasAudio;
  String audioLink;
  int numero;
  List<Paragraphe> paragraphes = [];

  Chant(
      this.id,
      this.titre,
      this.auteur,
      this.nbreParagraphe,
      this.recueil,
      this.hasRefrain,
      this.hasPartition,
      this.hasYoutube,
      this.traducteur,
      this.original,
      this.source,
      this.theme,
      this.edition,
      this.youtubeLink,
      this.hasAudio,
      this.audioLink,
      this.numero);
  factory Chant.fromJson(Map<String, dynamic> json) {
    return Chant(
      json['id'],
      json['titre'],
      json['auteur'],
      json['nbreParagraphe'],
      json['recueil'],
      json['hasRefrain'],
      json['hasPartition'],
      json['hasYoutube'],
      json['traducteur'],
      json['original'],
      json['source'],
      json['theme'],
      json['edition'],
      json['youtubeLink'],
      json['hasAudio'],
      json['audioLink'],
      json['numero'],
    );
  }
  Map toJson() => {
        'id': id,
        'titre': titre,
        'auteur': auteur,
        'nbreParagraphe': nbreParagraphe,
        'recueil': recueil,
        'hasRefrain': hasRefrain,
        'hasPartition': hasPartition,
        'hasYoutube': hasYoutube,
        'traducteur': traducteur,
        'original': original,
        'source': source,
        'theme': theme,
        'edition': edition,
        'youtubeLink': youtubeLink,
        'hasAudio': hasAudio,
        'audioLink': audioLink,
        'numero': numero
      };
}
