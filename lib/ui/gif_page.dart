


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {

 final Map _gifPage;

  GifPage(this._gifPage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black,
      appBar: AppBar(title: Text(_gifPage["title"]),centerTitle: true,
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.share),
            onPressed: (){
              Share.share(_gifPage["images"]["fixed_height"]["url"]);
            })
      ],),
      body: Center(
        child: Image.network(_gifPage["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
