// TODO Implement this library.
import 'dart:ui';
import 'dart:math';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class Constantes {
  Color primaryColor = Color(0xFF5A1515);
  Color secondaryColor = Color(0xFF2F4858);
  String primaryFont = "NoticaText";
  String phoneticFont = "phonetic";
  List<dynamic> genrate_songs(int nbre) {
    List<dynamic> retour = [];
    for (int i = 0; i < nbre; i++) {
      retour.add({"numero": i, "value": getRandomString(40).toString()});
    }
    return retour;
  }
}
