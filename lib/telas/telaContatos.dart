import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wapp_teste/Model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wapp_teste/Model/conversas.dart';

class AbaContatos extends StatefulWidget {
  @override
  _AbaContatosState createState() => _AbaContatosState();
}

class _AbaContatosState extends State<AbaContatos> {

  String idLoggedUser;
  String emailLoggedUser;

  Future<List<User>> _recuperarContatos() async {
    Firestore db = Firestore.instance;
    QuerySnapshot querySnapshot =
        await db.collection("usuarios").getDocuments();

    List<User> listaContatos = List();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data;
      if(dados["email"]== emailLoggedUser) continue;
      User usuario = User();
      usuario.idUser = item.documentID;
      usuario.email = dados["nome"];
      usuario.nome = dados["email"];
      usuario.urlImagem = dados["urlImagem"];

      listaContatos.add(usuario);
    }
    return listaContatos;
  }
  _recuperaDadosUser () async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    idLoggedUser = usuarioLogado.uid;
    emailLoggedUser = usuarioLogado.email;
  }
  @override
  void initState() {
    super.initState();
    _recuperaDadosUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: _recuperarContatos(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: [Text("Carregando"), CircularProgressIndicator()],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  List<User> listaItens = snapshot.data;
                  User usuario = listaItens[index];
                  return ListTile(
                    onTap: (){
                      Navigator.pushNamed(context,
                          "/mensagens",
                        arguments: usuario
                      );
                    },
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    leading: CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage: usuario.urlImagem != null
                            ? NetworkImage(usuario.urlImagem)
                            : null),
                    title: Text(
                      usuario.nome,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  );
                });
            break;
        }
      },
    );
  }
}
