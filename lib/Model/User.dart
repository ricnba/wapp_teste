
class User {

  String _idUser;
  String _nome;
  String _email;
  String _senha;
  String _urlImagem;

  User();

  Map<String, dynamic> toMap (){
    Map<String, dynamic> map = {
      "nome" : this.nome,
      "email" : this.email
    };
    return map;
  }


  String get idUser => _idUser;

  set idUser(String value) {
    _idUser = value;
  }

  String get urlImagem => _urlImagem;

  set urlImagem(String value) {
    _urlImagem = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }
}