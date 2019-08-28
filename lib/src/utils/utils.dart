


import 'package:flutter/material.dart';

bool isNumeric(String s){

  if(s.isEmpty) return false;

  final n = num.tryParse(s);
  return(n == null) ? false : true;

}

void mostrarAlerta(BuildContext context, String mensaje){
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title: Text('Informacion incorrecta'),
        content: Text(mensaje),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
    }
  );
}

void mostrarDialogCargando(BuildContext context){
  showDialog(
    context: context,
    builder: (context){
      return Container(
        height: 30.0,
        width: 30.0,
        child: Column(
          children: <Widget>[
            Image.asset('assets/jar-loading.gif',width: 20.0, height: 20.0,),
            Text('Cargando'),
          ],
        ),
      );
    }
  );
}