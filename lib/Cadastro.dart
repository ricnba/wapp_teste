import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wapp_teste/Model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {

  TextEditingController _ctrlNome = TextEditingController(text: "teste");
  TextEditingController _ctrlEmail = TextEditingController(text: "teste@teste.com");
  TextEditingController _ctrlSenha = TextEditingController(text: "123123");
  String _msgErro = "";


  _validarCamposCadastro (){
    String nome = _ctrlNome.text;
    String email = _ctrlEmail.text;
    String senha = _ctrlSenha.text;

    if( nome.length >= 3){
      if( email.isNotEmpty && email.contains("@")){
        if( senha.isNotEmpty){


          User user = User();
          user.nome = nome;
          user.email = email;
          user.senha = senha;
          _cadastrouser(user);

        }else {
          setState(() {
            _msgErro = "Preencha a senha";
          });
        }
      }else {
        setState(() {
          _msgErro = "O email não preenche os requisitos";
        });
      }
    }else {
      setState(() {
        _msgErro = "O nome deve conter mais que 3 caracteres";
      });
    }
  }

  _cadastrouser (User user){

    FirebaseAuth auth = FirebaseAuth.instance;

    auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.senha
    ).then((firebaseUser){


      Firestore db = Firestore.instance;

      db.collection("usuarios")
          .document( firebaseUser.user.uid )
          .setData( user.toMap() );

      Navigator.pushNamedAndRemoveUntil(
          context, "/home", (_) => false
      );

    }).catchError((erro){
      setState(() {
        _msgErro = "Erro: $erro";
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xff075e54)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Center(
                    child: Image.asset(
                      "images/usuario.png",
                      width: 200,
                      height: 150,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _ctrlNome,
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
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _ctrlEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(
                        32,
                        16,
                        32,
                        16,
                      ),
                      hintText: "E-mail",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ),
                ),
                TextField(
                  obscureText: true,
                  controller: _ctrlSenha,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(
                      32,
                      16,
                      32,
                      16,
                    ),
                    hintText: "Senha",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Cadastrar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.green,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                    onPressed: _validarCamposCadastro,
                  ),
                ),
                Center(
                  child: Text(
                      _msgErro,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
