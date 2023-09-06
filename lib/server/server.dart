import '../model/model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

Future<List<Riverpod>> getUsers() async {
  String url = "https://jsonplaceholder.typicode.com/users";

  try {
    var res = await http.get(
      Uri.parse(url),
     
    );

    var data = convert.jsonDecode(res.body);
    
    if (res.statusCode == 200 && data.isNotEmpty) {
      var welcomeData = data.map<Riverpod>((e) => Riverpod.fromJson(e)).toList();
      return welcomeData;
    }
  } catch (e) {
    print(e);
  }
  return [];
}