import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<Map> _recuperarPreco() async{
      String url = "https://blockchain.info/ticker";
      http.Response response = await http.get(url);

      print(response.body);

      return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Future Test"),),
      body: FutureBuilder<Map>(
        future: _recuperarPreco(),
        builder: (context, snapshot){
          String resultado;

          switch(snapshot.connectionState){
            case ConnectionState.none:
              resultado = "Não foi possível conectar ao servidor";
              break;
            case ConnectionState.waiting:
              resultado = "Aguardando dados do servidor";
              break;
            case ConnectionState.active:
              resultado = "Conexão está ativa";
              break;
            case ConnectionState.done:


              if(!snapshot.hasError){
                resultado = "${snapshot.data["BRL"]["symbol"].toString()} ${snapshot.data["BRL"]["buy"].toString()}";
              }
              else{
                resultado = "Algo deu errado";
              }
              break;
          }

          return myWidget(resultado);
        },
      ),
    );
  }

  Widget myWidget(String resultado){
    return Text(resultado);
  }
}
