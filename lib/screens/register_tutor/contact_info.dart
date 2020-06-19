import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';
import 'package:petsaojoao/components/foundation_form/appbar_foundation.dart';
import 'package:petsaojoao/components/foundation_form/body_foundation.dart';
import 'package:petsaojoao/components/foundation_form/button_confirmForm.dart';
import 'package:petsaojoao/components/foundation_form/data_security_info.dart';
import 'package:petsaojoao/models/validators/email_validator.dart';
import 'package:petsaojoao/models/validators/phone_validator.dart';
import 'package:petsaojoao/models/validators/whatsapp_validator.dart';
import 'package:petsaojoao/screens/dashboard/dashboard.dart';
import 'package:petsaojoao/screens/reg_my_pet/my_pet_info_first.dart';
import 'package:petsaojoao/screens/register_tutor/personal_info.dart';
import 'package:petsaojoao/services/repo_reg_tutor/api_rest_tutor.dart';
import 'andress_info.dart';

TextEditingController _emailController = new TextEditingController();
var _phoneController = new MaskedTextController(mask: "(00) 0000-0000");
var _whatsappController = new MaskedTextController(mask: "(00) 0 0000-0000");
var controllerDrawer;

var email = FormContact().getEmail();
var name = FormPersonal().getName();
var rg = FormPersonal().getRg();
var cpf = FormPersonal().getCpf();
var phone = FormContact().getPhone();
var whatsapp = FormContact().getWhatsapp();
var cep = FormAndress().getCep();
var street = FormAndress().getStreet();
var number = FormAndress().getNumber();
var area = FormAndress().getArea();
var complement = FormAndress().getComplementAddress();
var id;

class ContactInfo extends StatefulWidget {
  void setControllerDrawer(value) {
    controllerDrawer = value;
    return controllerDrawer;
  }

  int setId(value) {
    id = value;
  }

  int getId() {
    return id;
  }

  String getEmail() {
    return email;
  }

  @override
  _ContactInfoState createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  String steps = "3 de 3";
  String questionTittle = "Como te contactamos?";
  var arrowBackIcon = Icons.arrow_back;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: AppBarFoundation(arrowBackIcon),
            preferredSize: Size.fromHeight(50.0)),
        body: ListView(children: <Widget>[
          BodyFoundation(steps, questionTittle),
          SizedBox(height: 10.0),
          DataSecurityInfo(),
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: FormContact(),
          ),
        ]));
  }
}

class FormContact extends StatefulWidget {
  String getEmail() {
    return _emailController.text;
  }

  String getPhone() {
    _phoneController.updateMask("00000000000");
    var phone = _phoneController.text;
    _phoneController.updateMask("(00) 0000-00000");
    return phone;
  }

  String getWhatsapp() {
    _whatsappController.updateMask("00000000000");
    var whatsapp = _whatsappController.text;
    _whatsappController.updateMask("(00) 0 0000-0000");
    return whatsapp;
  }

  @override
  _FormContactState createState() => _FormContactState();
}

class _FormContactState extends State<FormContact> {
  final _contactFormKey = GlobalKey<FormState>();

  final _labelEmail = "E-mail";
  final _labelPhone = "Telefone";
  final _labelWhatsapp = "Whatsapp";
  final _helperTextOptional = "Opcional";

  FocusNode focusEmailForPhone;
  FocusNode focusPhoneForWhatsapp;

  void initState() {
    super.initState();

    focusEmailForPhone = FocusNode();
    focusPhoneForWhatsapp = FocusNode();
  }

  void dispose() {
    super.dispose();

    focusEmailForPhone.dispose();
    focusPhoneForWhatsapp.dispose();
  }

  sendData() async {
    var result = await ApiRestTutor.post(email, name, rg, cpf, phone, whatsapp,
        cep, street, number, area, complement);

    if (result == null) {
      //Navigator.pop(context);
      DrawerBottonError().show(context);
    } else {
      //var tutorId = result.id;
      // var tutorEmail = result.email;
      setState(() {
        //  id = tutorId;
        //  email = tutorEmail;
      });
      // Navigator.pop(context);
      DrawerBottonPositive().show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _contactFormKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            onEditingComplete: focusEmailForPhone.requestFocus,
            validator: (value) {
              return EmailValidator().validate(value);
            },
            keyboardType: TextInputType.text,
            controller: _emailController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email),
              labelText: _labelEmail,
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            onEditingComplete: focusPhoneForWhatsapp.requestFocus,
            focusNode: focusEmailForPhone,
            validator: (value) {
              return PhoneValidator().validate(value);
            },
            onChanged: (value) {},
            keyboardType: TextInputType.number,
            controller: _phoneController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.phone),
              labelText: _labelPhone,
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            focusNode: focusPhoneForWhatsapp,
            validator: (value) {
              return WhatsappValidator().validate(value);
            },
            keyboardType: TextInputType.number,
            controller: _whatsappController,
            decoration: InputDecoration(
              helperText: _helperTextOptional,
              prefixIcon: Icon(FontAwesomeIcons.whatsapp),
              labelText: _labelWhatsapp,
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 30),
          ButtonConfirmForm(() async {
            if (_contactFormKey.currentState.validate()) {
              dataPost(context);
            }
          }),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

void dataPost(context) async {
  DrawerBottonSendData().show(context);
  var result = await ApiRestTutor.post(email, name, rg, cpf, phone, whatsapp,
      cep, street, number, area, complement);

  Navigator.pop(context);
  if (result == null) {
    DrawerBottonError().show(context);
  } else {
    DrawerBottonPositive().show(context);

    id = result.id;
  }
}

class DrawerBottonSendData {
  var _labelSend = "Enviando Dados";
  void show(context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
              color: Colors.blueAccent[200],
              child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                              Text(_labelSend,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24.0)),
                            ])
                      ])));
        });
  }
}

class DrawerBottonPositive {
  final _labelPositive = "Deseja cadastrar seu pet agora?";
  final buttonYes = "Sim";
  final buttonLater = "Mais tarde";

  void show(context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
              color: Colors.green,
              child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.checkCircle,
                          color: Colors.white,
                          size: 40,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(_labelPositive,
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 24.0)),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FlatButton(
                                color: Colors.green,
                                textColor: Colors.white,
                                padding: EdgeInsets.all(8.0),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyPetInfoFirst()),
                                  );
                                },
                                child: Text(
                                  buttonYes.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              FlatButton(
                                color: Colors.green,
                                textColor: Colors.brown[200],
                                padding: EdgeInsets.all(8.0),
                                onPressed: () {
                                  // Navigator.pushReplacement(
                                  //     context, _createRoute(Dashboard()));
                                },
                                child: Text(
                                  buttonLater.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ])
                      ])));
        });
  }
}

class DrawerBottonError {
  final _labelError = "Não foi possível enviar seus dados";
  final buttonTryAgain = "Tentar Novamente";
  final buttonCancel = "Cancelar";

  void show(context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
              color: Colors.redAccent,
              child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.timesCircle,
                          color: Colors.white,
                          size: 40,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(_labelError,
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 24.0)),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FlatButton(
                                color: Colors.redAccent,
                                textColor: Colors.white,
                                padding: EdgeInsets.all(8.0),
                                onPressed: () async {
                                  await dataPost(context);
                                },
                                child: Text(
                                  buttonTryAgain.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              FlatButton(
                                color: Colors.redAccent,
                                textColor: Colors.brown[200],
                                padding: EdgeInsets.all(8.0),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Dashboard()));
                                },
                                child: Text(
                                  buttonCancel.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ])
                      ])));
        });
  }
}
