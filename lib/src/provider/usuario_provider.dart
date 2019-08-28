
import 'dart:convert';

import 'package:formvalidations/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {

    final String _firabaseToke = 'AIzaSyBIbEjkAqawJO6mMLanBSoy242Ei_Lgq3w';
    final _prefs = new PreferenciasUsuario();

    Future<Map<String,dynamic>> login(String email, String password) async{
      final authData = {
        'email'            : email,
        'password'         : password,
        'returnSecureToken' : true
      };

      final resp = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firabaseToke',
        body: json.encode(authData)
      );

      Map<String, dynamic>decodeRes = json.decode(resp.body);
      print(decodeRes);

      if(decodeRes.containsKey('idToken')){
        //TODO: salvar el token en el storage
        _prefs.token = decodeRes['idToken'];
        return {'ok': true, 'token': decodeRes['idToken']};
      }else{
        return {'ok': false, 'mensaje': decodeRes['error']['message']};
      }
    }

    Future<Map<String,dynamic>> nuevoUsuario(String email, String password) async {

      final authData = {
        'email'            : email,
        'password'         : password,
        'returnSecureToken' : true
      };

      final resp = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firabaseToke',
        body: json.encode(authData)
      );

      Map<String, dynamic>decodeRes = json.decode(resp.body);
      print(decodeRes);

      if(decodeRes.containsKey('idToken')){
        //TODO: salvar el token en el storage
        _prefs.token = decodeRes['idToken'];
        return {'ok': true, 'token': decodeRes['idToken']};
      }else{
        return {'ok': false, 'mensaje': decodeRes['error']['message']};
      }

    }

}