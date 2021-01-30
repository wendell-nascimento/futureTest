import 'package:flutter/material.dart';
import 'package:future_app/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _urlBase = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> _recuperaPost() async {
    String url = _urlBase + "/posts";
    http.Response response = await http.get(url);
    var dados = json.decode(response.body);


    List<Post> lista = [];

    for(var post in dados){
      Post p = Post(post["userId"], post["id"], post["title"], post["body"]);
      lista.add(p);
    }

    return lista;
  }

  @override
  Widget build(BuildContext context) {
    bool check = false;

    return Scaffold(
        appBar: AppBar(
          title: Text("Revisão Future"),
        ),
        body: FutureBuilder<List<Post>>(
          future: _recuperaPost(),
          builder: (context, snapshot) {

            switch (snapshot.connectionState){
              case ConnectionState.none:
                print("Não consegui conectar");
                break;
                case ConnectionState.waiting:
                  print("Aguardando conexão");
                  return Center(child: CircularProgressIndicator());
                break;
                case ConnectionState.active:
                  print("Conexão ativa");
                break;
                case ConnectionState.done:
                  if(snapshot.hasError){
                    print("Tem alguma coisa errada");
                  }
                  else{
                    print("Tudo certo");
                    check = true;
                  }
                break;
            }

            if(check){
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index){

                    List<Post> lista = snapshot.data;

                    return ListTile(
                      leading: Icon(Icons.account_box),
                      title: Text("${lista[index].title}"),
                      subtitle: Text("${lista[index].id}"),
                    );

                  });
            }else{
              return Center(child: Text("Algo deu errado"));
            }



            return null;


          },
        ));
  }
}
