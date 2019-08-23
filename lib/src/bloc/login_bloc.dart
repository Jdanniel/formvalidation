import 'dart:async';

import 'package:formvalidations/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/streams.dart';

class LoginBloc with Validators{

  //Los streamController no existen en rxdart CombineLatestStream
  //final _emailController    = StreamController<String>.broadcast();
  //final _passwordController = StreamController<String>.broadcast();

  final _emailController    = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //Recupera los datos del stream
  Stream<String> get emailStream    => _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform(validarPassword);

  Stream<bool> get formValidStream => 
    Observable.combineLatest2(emailStream, passwordStream, (e,p) => true);

  //Insertar valores al Stream

  Function(String) get changeEmail    => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;


  //Obtener el ultimo ingresado en los streams
  String get gemail    => _emailController.value;
  String get gpassword => _passwordController.value;

  //cerrar Stream
  dispose(){
    _emailController?.close();
    _passwordController?.close();
  }


}