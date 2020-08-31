import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


class Config extends StatefulWidget {
  @override
  _ConfigState createState() => _ConfigState();
}

class _ConfigState extends State<Config> {

  TextEditingController _controller = TextEditingController();
  File _image;
  final picker = ImagePicker();
  String statusUpload = "";
  String idLoggedUser;
  bool _upload = false;
  String _urlImagemRecuperada;

  Future getImageCam() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera);

    setState(() {
      _upload = true;
      _image = File(pickedFile.path);
      if(_image != null){
        _uploadImage();
        _updateImagemPerfil(_urlImagemRecuperada);
      }
    });
  }

  Future getImageGal() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery);

    setState(() {
      _upload = true;
      _image = File(pickedFile.path);
      if(_image != null){
        _uploadImage();
      }
    });
  }

  Future _uploadImage () async{

    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
      .child("perfil")
      .child(idLoggedUser + ".jpg");

    StorageUploadTask task = arquivo.putFile(_image);
    task.events.listen((StorageTaskEvent storageEvent) {
      if(storageEvent.type == StorageTaskEventType.progress){
        setState(() {
          _upload = true;
        });
      }else if(storageEvent.type == StorageTaskEventType.success){
        setState(() {
          _upload = false;
        });
      }
    });

    task.onComplete.then((StorageTaskSnapshot snapshot){
      _recuperarUrlImagem(snapshot);
    });
  }
  Future _recuperarUrlImagem(StorageTaskSnapshot snapshot) async {

    String url = await snapshot.ref.getDownloadURL();
    _updateImagemPerfil(url);
    setState(() {
      _urlImagemRecuperada = url;
    });

  }

  _atualizarNomeFirestore(){

    String nome = _controller.text;
    Firestore db = Firestore.instance;

    Map<String, dynamic> dadosAtualizar = {
      "nome" : nome
    };

    db.collection("usuarios")
        .document(idLoggedUser)
        .updateData( dadosAtualizar );

  }

  _recuperaDadosUser () async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    idLoggedUser = usuarioLogado.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await db.collection("usuarios")
        .document( idLoggedUser )
        .get();

    Map<String, dynamic> dados = snapshot.data;
    _controller.text = dados["nome"];

    if( dados["urlImagem"] != null ){
      setState(() {
        _urlImagemRecuperada = dados["urlImagem"];
      });
    }
  }
  _updateImagemPerfil (String url){
    Firestore db = Firestore.instance;

    Map<String, dynamic> dadosAtualizar = {
      "urlImagem" : url
    };

    db.collection("usuarios")
        .document(idLoggedUser)
        .updateData( dadosAtualizar );



  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperaDadosUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                  _urlImagemRecuperada != null
                      ? NetworkImage(_urlImagemRecuperada)
                      : null
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                        onPressed: getImageCam,
                        child: Text("Camera")),
                    FlatButton(
                        onPressed: getImageGal,
                        child: Text("Galeria")),

                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(
                        32,
                        16,
                        32,
                        16,
                      ),
                      hintText: "Nome",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Salvar dados",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.blueAccent,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    onPressed: _atualizarNomeFirestore,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
