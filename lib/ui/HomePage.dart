import 'package:flutter/material.dart';
import 'package:gif_buscador/ui/gif_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String search;
  int offset = 0;

  _getFile() async {
    http.Response response;
    if (search == null) {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=Y5TOttGCzBD6a60C7Rlmvwo6hNcH2pzD&limit=25&rating=g");
    } else {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=Y5TOttGCzBD6a60C7Rlmvwo6hNcH2pzD&q=$search&limit=19&$offset=0&rating=g&lang=en");
    }

    return json.decode(response.body);
  }

  int getCount(List data) {
    if (search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquise Aqui!",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
              onSubmitted: (text) {
                setState(() {
                  search = text;
                });
              },
            ),
          ),
          Expanded(
              child: FutureBuilder(
                  future: _getFile(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case (ConnectionState.waiting):
                      case (ConnectionState.none):
                        return Container(
                          height: 200.0,
                          width: 200.0,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 5.0,
                          ),
                        );
                      default:
                        return GridView.builder(
                            padding: EdgeInsets.all(10.0),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 10.0,
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10.0),
                            itemCount: getCount(snapshot.data["data"]),
                            itemBuilder: (context, index) {
                              if (search == null ||
                                  index < snapshot.data["data"].length) {
                                return GestureDetector(
                                  child: Image.network(
                                    snapshot.data["data"][index]["images"]
                                        ["fixed_height"]["url"],
                                    fit: BoxFit.cover,
                                  ),onTap: (){
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context)=> GifPage(snapshot.data["data"][index])));
                                },onLongPress: (){
                                    Share.share( snapshot.data["data"][index]["images"]
                                    ["fixed_height"]["url"]);
                                },
                                );
                              }else{
                                return Container(
                                  child:GestureDetector(
                                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                      Icon(Icons.add,size: 70.0,color: Colors.white,),
                                      Text("Carregar mais...",style: TextStyle(fontSize: 22.0,color: Colors.white),)

                                    ],),
                                  onTap: (){
                                      setState(() {
                                        offset+=19;
                                      });
                                  },),
                                );
                              }
                            });
                    }
                  }))
        ],
      ),
    );
  }
}
