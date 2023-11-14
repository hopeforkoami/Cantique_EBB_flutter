class Paragraphe {
  int id;
  int chanId;
  int position;
  String textContent = "";
  String noteContent = "";
  bool isRefrain;
  bool hasNote;
  Paragraphe(this.id, this.chanId, this.position, this.isRefrain, this.hasNote);
}
