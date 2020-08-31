import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:wapp_teste/Model/User.dart';
import 'package:wapp_teste/Model/mensagem.dart';

class Mensagens extends StatefulWidget {
  User contatos;
  Mensagens(this.contatos);

  @override
  _MensagensState createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  Firestore db = Firestore.instance;
  String idLoggedUser;
  String idUserDest;
  final _ctrlMsg = TextEditingController();

  _sendMsg(){
    String textMsg = _ctrlMsg.text;
    if (textMsg.isNotEmpty) {
      Mensagem msg = Mensagem();
      msg.idUser = idLoggedUser;
      msg.msg = textMsg;
      msg.urlImage = "";
      msg.tipo = "texto";

      _salvarMsg(idLoggedUser, idUserDest, msg);
      _salvarMsg(idUserDest, idLoggedUser, msg);
    }
  }

  _salvarMsg(String idRem, String idDest, Mensagem msg) async {
   await db  .collection("mensagens")
        .document(idRem)
        .collection(idDest)
        .add(msg.toMap());
    _salvarMsg(idRem, idDest, msg);
    _ctrlMsg.clear();
  }

  _sendPic() {}
  _recuperaDadosUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    idLoggedUser = usuarioLogado.uid;
    idUserDest = widget.contatos.idUser;
  }



  @override
  void initState() {
    super.initState();
    _recuperaDadosUser();
  }

  @override
  Widget build(BuildContext context) {
    var messageBox = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: TextField(
                controller: _ctrlMsg,
                autofocus: true,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: _sendPic,
                  ),
                  contentPadding: EdgeInsets.fromLTRB(
                    32,
                    8,
                    32,
                    8,
                  ),
                  hintText: "Digite uma mensagem",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
              ),
            ),
          ),
          FloatingActionButton(
            backgroundColor: Color(0xff075E54),
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
            mini: true,
            onPressed: _sendMsg,
          )
        ],
      ),
    );

    var stream = StreamBuilder(
        stream: db
            .collection("mensagens")
            .document(idLoggedUser)
            .collection(idUserDest)
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  children: [
                    Text("Carregando mensagens"),
                    CircularProgressIndicator()
                  ],
                ),
              );
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              QuerySnapshot query = snapshot.data;
              if (snapshot.hasError) {
                return Expanded(child: Text("Erro ao carregar mensagens"));
              } else {
                return Expanded(
                    child: ListView.builder(
                        itemCount: query.documents.length,
                        itemBuilder: (context, index) {
                          double ctnrWidth =
                              MediaQuery.of(context).size.width * 0.7;

                          List<DocumentSnapshot> mensagens = query.documents.toList();
                          DocumentSnapshot item = mensagens[index];
                          Alignment alignment = Alignment.centerRight;
                          Color color = Color(0xffd2ffa5);
                          if (idLoggedUser != item["idUser"]) {
                            alignment = Alignment.centerLeft;
                            color = Colors.white;
                          }
                          return Align(
                            alignment: alignment,
                            child: Padding(
                              padding: EdgeInsets.all(6),
                              child: Container(
                                width: ctnrWidth,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                child: Text(
                                  item["msg"],
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          );
                        })
                );
              }
              break;
          }
        }
        );

    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: CircleAvatar(
                maxRadius: 20,
                backgroundColor: Colors.grey,
                backgroundImage: widget.contatos.urlImagem != null
                    ? NetworkImage(widget.contatos.urlImagem)
                    : null),
          ),
          SizedBox(
            width: 16,
          ),
          Text(widget.contatos.email),
        ],
      )),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/bg.png"), fit: BoxFit.cover)),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                stream,
                messageBox
              ],
            ),
          ),
        ),
      ),
    );
  }
}
