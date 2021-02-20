import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ordernow/constants/colors.dart';
import 'package:ordernow/models/restaurants.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  double width;
  double height;

  _validator(value) => value.isEmpty ? 'Campo obrigatório' : null;
  final TextEditingController _controladorEmail = TextEditingController();
  final TextEditingController _controladorPassword = TextEditingController();
  final TextEditingController _controladorCNPJ = TextEditingController();
  final TextEditingController _controladorAdress = TextEditingController();
  final TextEditingController _controladorNumber = TextEditingController();
  final TextEditingController _controladorCity = TextEditingController();
  final TextEditingController _controladorURL = TextEditingController();
  final TextEditingController _controladorName = TextEditingController();
  final TextEditingController _controladorDescricao = TextEditingController();
  String stringImage;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Restaurant.loginCheck().then((isLogged) {
      if (isLogged) Navigator.of(context).pushReplacementNamed('/homescreen');
    });
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
            color: Colors.white,
            width: width,
            height: height,
            padding: EdgeInsets.symmetric(horizontal: width * 0.1),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextFormField(
                    controller: _controladorEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                    ),
                    validator: (value) => _validator(value),
                  ),
                  TextFormField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _controladorPassword,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                    ),
                    validator: (value) => _validator(value),
                  ),
                  TextFormField(
                    controller: _controladorCNPJ,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'CNPJ',
                    ),
                    validator: (value) => _validator(value),
                  ),
                  TextFormField(
                    controller: _controladorAdress,
                    keyboardType: TextInputType.streetAddress,
                    decoration: const InputDecoration(
                      labelText: 'Endereço',
                    ),
                    validator: (value) => _validator(value),
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          controller: _controladorNumber,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Número',
                          ),
                          validator: (value) => _validator(value),
                        ),
                      ),
                      Flexible(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: TextFormField(
                            controller: _controladorCity,
                            decoration: const InputDecoration(
                              labelText: 'Cidade',
                            ),
                            validator: (value) => _validator(value),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _controladorURL,
                    keyboardType: TextInputType.url,
                    decoration: const InputDecoration(
                      labelText: 'URL de imagem',
                    ),
                    validator: (value) => _validator(value),
                  ),
                  TextFormField(
                    controller: _controladorName,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: 'Nome do restaurante',
                    ),
                    validator: (value) => _validator(value),
                  ),
                  TextFormField(
                    controller: _controladorDescricao,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Descrição do restaurante',
                    ),
                    validator: (value) => _validator(value),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ButtonTheme(
                      minWidth: width * 0.4,
                      height: height * 0.055,
                      child: RaisedButton(
                        child: Text('CONTINUAR'),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Realizando cadastro...'),
                            ));
                            if (await Restaurant(
                              email: _controladorEmail.text,
                              password: sha256
                                  .convert(
                                      utf8.encode(_controladorPassword.text))
                                  .toString(),
                              cnpj: _controladorCNPJ.text,
                              adress: _controladorAdress.text,
                              number: _controladorNumber.text,
                              city: _controladorCity.text,
                              name: _controladorName.text,
                              descricao: _controladorDescricao.text,
                            ).register()) {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    Text('Cadastro realizado com sucesso!'),
                              ));
                              Navigator.of(context).pop('/register');
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Erro ao realizar cadastro'),
                              ));
                            }
                          }
                        },
                        color: apporange,
                        textColor: Colors.white,
                        elevation: 0,
                        hoverElevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
