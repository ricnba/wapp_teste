import 'package:flutter/material.dart';
import 'package:wapp_teste/Model/conversas.dart';

class AbaConversas extends StatefulWidget {
  @override
  _AbaConversasState createState() => _AbaConversasState();
}

class _AbaConversasState extends State<AbaConversas> {
  List<Conversa> listaConversas = [
    Conversa("nome", "_msg", "_foto"),
    Conversa("nome2", "_msg2", "_foto"),
    Conversa("nome3", "_msg3", "_foto"),
    Conversa("nome4", "_msg4", "_foto"),
    Conversa("nome5", "msg5", "_foto"),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listaConversas.length,
        itemBuilder: (context, index) {
          Conversa conversa = listaConversas[index];
          return ListTile(
            contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            leading: CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.grey,
              //backgroundImage: NetworkImage(),
            ),
            title: Text(
              conversa.nome,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              conversa.msg,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          );
        });
  }
}
