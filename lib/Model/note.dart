class Note {
  int? noteId;
  String? noteText;
  String? noteTitle;
  String? noteDate;
  String? noteUpdatedDate;
  int? noteColor;
  int? isEdited;
  Note(
      {this.noteId,
      this.noteTitle,
      this.noteText,
      this.noteDate,
      this.noteColor,
      this.isEdited,
      this.noteUpdatedDate,
      });

  Map<String, dynamic> toMap() => {
        'noteId': noteId,
        'noteTitle': noteTitle,
        'noteText': noteText,
        'noteDate': noteDate,
        'noteColor': noteColor,
        'isEdited':isEdited,
        'noteUpdatedDate':noteUpdatedDate,
      };

  Note.fromMap(Map<String, dynamic> map) {
    noteId = map['noteId'];
    noteTitle = map['noteTitle'];
    noteText = map['noteText'];
    noteDate = map['noteDate'];
    noteColor = map['noteColor'];
    isEdited = map['isEdited'];
    noteUpdatedDate = map['noteUpdatedDate'];
  }
}
