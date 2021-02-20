import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Restaurant {
  String email;
  String password;
  String cnpj;
  String adress;
  String number;
  String city;
  String image;
  String name;
  String descricao;
  String _server = kIsWeb ? 'http://localhost:8888' : 'http://10.0.2.2:8888';

  Restaurant(
      {this.email,
      this.password,
      this.cnpj,
      this.adress,
      this.number,
      this.city,
      this.name,
      this.descricao,
      this.image});

  void fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    cnpj = json['cnpj'];
    adress = json['adress'];
    number = json['number'];
    name = json['name'];
    descricao = json['descricao'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    var data = Map<String, dynamic>();
    data['email'] = email;
    data['password'] = password;
    data['cnpj'] = cnpj;
    data['adress'] = adress;
    data['number'] = number;
    data['city'] = city;
    data['image'] = image;
    data['descricao'] = descricao;
    data['name'] = name;
    return data;
  }

  Future<bool> register() async {
    var url = _server + "/restaurant/register";

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    try {
      var response =
          await http.post(url, headers: headers, body: jsonEncode(toJson()));
      if (response.statusCode == HttpStatus.created)
        return true;
      else
        return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Box<E>> openEncryptedBox<E>() async => await Hive.openBox('vaultBox',
      encryptionCipher: HiveAesCipher([
        23,
        250,
        239,
        129,
        71,
        112,
        177,
        197,
        150,
        180,
        176,
        232,
        2,
        220,
        31,
        108,
        196,
        131,
        61,
        178,
        154,
        166,
        113,
        182,
        143,
        252,
        235,
        23,
        164,
        193,
        242,
        174
      ]));

  Future<bool> login() async {
    var url = _server + "/restaurant/login";

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      var response =
          await http.post(url, headers: headers, body: jsonEncode(toJson()));
      if (response.statusCode == HttpStatus.ok) {
        Map<String, dynamic> user = jsonDecode(response.body);
        if (kIsWeb) {
          final encryptedBox = await openEncryptedBox();
          encryptedBox.put('id', user['id'].toString());
          encryptedBox.put('email', user['email'].toString());
          encryptedBox.put('token', user['token'].toString());
        } else {
          final FlutterSecureStorage secureStorage =
              const FlutterSecureStorage();
          secureStorage.write(key: 'id', value: user['id'].toString());
          secureStorage.write(key: 'email', value: user['email'].toString());
          secureStorage.write(key: 'token', value: user['token'].toString());
        }
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> loginCheck() async {
    if (kIsWeb) {
      return await Hive.boxExists('vaultBox');
    } else
      return await FlutterSecureStorage().containsKey(key: 'id');
  }

  //   Future<bool> loginCheck() async {
  //   var url = _server + "/restaurant/check/login";
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //   };
  //   if (kIsWeb) {
  //     if (await Hive.boxExists('vaultBox')) {
  //       final box = await Hive.openBox('vaultBox');
  //       try {
  //         this.token = box.get('token');
  //         print(token);
  //         var response = await http.post(url,
  //             headers: headers, body: jsonEncode(toJson()));
  //         if (response.statusCode == HttpStatus.ok)
  //           return true;
  //         else
  //           return false;
  //       } catch (e) {
  //         print(e);
  //         return false;
  //       }
  //     }
  //   } else {
  //     if (await FlutterSecureStorage().containsKey(key: 'token')) {
  //       final token = await FlutterSecureStorage().read(key: 'token');
  //       try {
  //         var response = await http.post(url, body: jsonEncode(token));
  //         if (response.statusCode == HttpStatus.ok)
  //           return true;
  //         else
  //           return false;
  //       } catch (e) {
  //         print(e);
  //         return false;
  //       }
  //     }
  //   }
  // }
}
