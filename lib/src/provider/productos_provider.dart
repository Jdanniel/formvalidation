
import 'dart:convert';
import 'dart:io';
import 'package:formvalidations/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

import 'package:formvalidations/src/models/producto_model.dart';


class ProductosProvider{


  final String _url = 'https://flutter-varios-74518.firebaseio.com';
  final _prefs = new PreferenciasUsuario();

  //Insertar Productos
  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json?auth=${_prefs.token}';
    
    final response = await http.post(url, body: productoModelToJson(producto));
  
    final decodeData = json.decode(response.body);
    
    print(decodeData);

    return true;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    final url = '$_url/productos/${producto.id}.json?auth=${_prefs.token}';

    final response = await http.put(url, body: productoModelToJson(producto));
  
    final decodeData = json.decode(response.body);

    print(decodeData);

    return true;
  }


  Future<List<ProductoModel>> cargarProductos() async {
    final url = '$_url/productos.json?auth=${_prefs.token}';

    final resp = await http.get(url);

    final Map<String,dynamic> decodeData = json.decode(resp.body);
    final List<ProductoModel> productos = new List();

    if(decodeData == null) return [];

    if(decodeData['error'] != null) return [];

    decodeData.forEach((id, prod){
      final prodTemp = ProductoModel.fromJson(prod);
      prodTemp.id = id;
      productos.add(prodTemp);
    });

    //print(productos);
    return productos;
  }

  Future<int> borrarProducto(String id) async{
    final url = '$_url/productos/$id.json?auth=${_prefs.token}';
    final resp = await http.delete(url);
    print(json.decode(resp.body));
    return 1;
  }


  Future<String> subirImagen(File imagen)async{

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dh2gqight/image/upload?upload_preset=rjl6n5o2');
    final mimetype = mime(imagen.path).split('/');

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url);

    final file = await http.MultipartFile.fromPath('file', imagen.path, contentType: MediaType(mimetype[0],mimetype[1]));  
    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamResponse);

    if(resp.statusCode != 200 && resp.statusCode != 201)
    {
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);
    print(respData);
    return respData['secure_url'];

  }
}