class Conversa {

  String _nome;
  String _msg;
  String _foto;

  Conversa(this._nome, this._msg, this._foto);

  String get foto => _foto;

  set foto(String value) {
    _foto = value;
  }

  String get msg => _msg;

  set msg(String value) {
    _msg = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }
}