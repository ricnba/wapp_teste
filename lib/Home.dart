import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wapp_teste/telas/telaContatos.dart';
import 'package:wapp_teste/telas/telaConversas.dart';
import 'Model/User.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  User user = User();
  TabController _tabCtrl;
  String _emailUser = "";
  List<String> listaMenu = [
    "Configurações", "Sair"
  ];

  Future _recuperarDadosUser () async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser userLogged = await auth.currentUser();
    setState(() {
      _emailUser = userLogged.email;
    });
  }

  @override
  void initState() {
    super.initState();
    checkUserLogged();
    _recuperarDadosUser();

    _tabCtrl = TabController(
        length: 2,
        vsync: this
    );
  }
  _itensMenu (String itemEscolhido){
    switch (itemEscolhido){
      case "Configurações":
        Navigator.pushNamed(
            context, "/config");
        break;
      case "Sair":
        _deslogar();
        break;
    }
  }
  _deslogar () async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
    Navigator.pushReplacementNamed(context, "/login"
    );
  }

  Future checkUserLogged()async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser loggedUser = (await auth.currentUser());
    if(loggedUser == null){
      Navigator.pushReplacementNamed(
          context, "/login"
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("wapp", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),
          controller: _tabCtrl,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(text: "Conversas",),
            Tab(text: "Contatos",)
          ],
        ),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: _itensMenu,
              itemBuilder: (context){
              return listaMenu.map((String item){
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
              }
          )
        ],
      ),
      body: TabBarView(
        controller: _tabCtrl,
          children: <Widget>[
            AbaConversas(),
            AbaContatos()

          ],
      ),
    );
  }
}
