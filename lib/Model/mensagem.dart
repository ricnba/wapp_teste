class Mensagem {

  String _idUser;
  String _msg;
  String _urlImage;
  String _tipo;
  String _data;

  Mensagem();

  Map<String, dynamic>toMap(){
    Map<String, dynamic> map = {
      "idUser": this.idUser,
      "msg": this.msg,
      "urlImage": this.urlImage,
      "tipo": this.tipo,

    };
    return map;
  }



  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get urlImage => _urlImage;

  set urlImage(String value) {
    _urlImage = value;
  }

  String get msg => _msg;

  set msg(String value) {
    _msg = value;
  }

  String get idUser => _idUser;

  set idUser(String value) {
    _idUser = value;
  }
}