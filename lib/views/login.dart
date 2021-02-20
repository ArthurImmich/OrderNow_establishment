import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ordernow/constants/colors.dart';
import 'package:ordernow/models/restaurants.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  double width;
  double height;

  final _loginKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Restaurant.loginCheck().then((isLogged) {
      if (isLogged) Navigator.of(context).pushReplacementNamed('/homescreen');
    });
    _validator(value) => value.isEmpty ? 'Campo obrigatório' : null;
    final TextEditingController _controladorEmail = TextEditingController();
    final TextEditingController _controladorPassword = TextEditingController();
    MediaQueryData device = MediaQuery.of(context);
    if (kIsWeb) {
      if (device.size.width > 700) {
        width = 700;
      } else if (device.size.width < 500) {
        width = 500;
      } else {
        width = device.size.width;
      }
      if (device.size.height > 850) {
        height = 850;
      } else if (device.size.height < 750) {
        height = 750;
      } else {
        height = device.size.height;
      }
    } else {
      width = device.size.width;
      height = device.size.height;
    }
    return Scaffold(
      backgroundColor: apporange,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: width,
            height: height,
            color: appgray,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  child: Container(
                    height: height * 0.41,
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: appshadow,
                          offset: Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'lib/assets/ordernowlogo.png',
                        width: width * 0.8,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: height * 0.59,
                    width: width,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: Form(
                        key: _loginKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextFormField(
                              controller: _controladorEmail,
                              decoration: const InputDecoration(
                                labelText: 'Usuário',
                              ),
                              validator: (value) => _validator(value),
                            ),
                            Column(
                              children: [
                                TextFormField(
                                  controller: _controladorPassword,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Senha',
                                  ),
                                  validator: (value) => _validator(value),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: Text(
                                          'Esqueceu a senha?',
                                          style: TextStyle(
                                            fontSize: height * 0.02,
                                            color: apporange,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .pushNamed('/register');
                                        },
                                        child: Text(
                                          'Registre-se',
                                          style: TextStyle(
                                            fontSize: height * 0.02,
                                            color: apporange,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ButtonTheme(
                                minWidth: width * 0.4,
                                height: height * 0.06,
                                child: RaisedButton(
                                  child: Text('CONTINUAR'),
                                  onPressed: () async {
                                    if (_loginKey.currentState.validate()) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('Realizando login'),
                                      ));
                                      var restaurant = Restaurant(
                                          email: _controladorEmail.text,
                                          password: sha256
                                              .convert(utf8.encode(
                                                  _controladorPassword.text))
                                              .toString());
                                      if (await restaurant.login()) {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              'Login realizado com sucesso!'),
                                        ));
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                '/homescreen');
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content:
                                              Text('Erro ao realizar login'),
                                        ));
                                      }
                                    }
                                  },
                                  color: apporange,
                                  textColor: Colors.white,
                                  elevation: 0,
                                  hoverElevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
