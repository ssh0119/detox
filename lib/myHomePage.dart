import 'dart:convert';
import 'package:detox/pathImage.dart';
import 'package:detox/requestServer.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  final controllerSalutation = TextEditingController();
  final controllerName = TextEditingController();
  final controllerEmail = TextEditingController();

  FocusNode _focusNodeSalutation = FocusNode();
  FocusNode _focusNodeName = FocusNode();
  FocusNode _focusNodeEmail = FocusNode();

  String title = "Product";
  String textSalutation = "Salutation";
  String textEgSalutation = "e.g : Susan";
  String textName = "Name";
  String textEgName = "e.g : Wong Wee Wee";
  String textEmail = "Email";
  String textEgEmail = "e.g : abc@gmail.com";
  String textButton = "I am interested";
  String textValSalution = "Please enter your salutation.";
  String textValName = "Please enter your name.";
  String textValEmail = "Please enter your email.";
  String textValEmail2 = "PLease enter valid email";

  String salutation, name, email = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controllerSalutation.dispose();
    controllerName.dispose();
    controllerEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(),
      body: content(),
    );
  }

  header() {
    return AppBar(
      title: Row(
        children: <Widget>[
          logo(),
          Text(title),
        ],
      ),
    );
  }

  content() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            photoOfProduct(),
            form(),
          ],
        ),
      ),
    );
  }

  logo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      child: Image.asset(
        PathImage().pathLogo,
        fit: BoxFit.contain,
        height: 50,
        width: 50,
      ),
    );
  }

  Widget photoOfProduct() {
    return AspectRatio(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Image.asset(PathImage().pathPicture, fit: BoxFit.contain),
        // Image.network(
        //   "https://www.kinohimitsu.com/en/images/wellness_smooth_d_2/1.jpg",
        // ),
      ),
      aspectRatio: 2,
    );
  }

  Widget form() {
    return Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: Container(
        margin: EdgeInsets.fromLTRB(15, 8, 15, 8),
        child: Column(
          children: <Widget>[
            salutationField(),
            nameField(),
            emailField(),
            sizedBox(),
            interestButton(),
          ],
        ),
      ),
    );
  }

  Widget salutationField() {
    return TextFormField(
      focusNode: _focusNodeSalutation,
      autofocus: true,
      keyboardType: TextInputType.text,
      controller: controllerSalutation,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          labelText: textSalutation,
          hintText: textEgSalutation,
          contentPadding: EdgeInsets.all(8.0)),
      validator: (text) => validationSalutation(text),
      onSaved: (text) => salutation = text,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, _focusNodeSalutation, _focusNodeName);
      },
    );
  }

  Widget nameField() {
    return TextFormField(
      focusNode: _focusNodeName,
      autofocus: true,
      keyboardType: TextInputType.text,
      controller: controllerName,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          labelText: textName,
          hintText: textEgName,
          contentPadding: EdgeInsets.all(8.0)),
      validator: (text) => validationName(text),
      onSaved: (text) => name = text,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, _focusNodeName, _focusNodeEmail);
      },
    );
  }

  Widget emailField() {
    return TextFormField(
      focusNode: _focusNodeEmail,
      autofocus: true,
      keyboardType: TextInputType.emailAddress,
      controller: controllerEmail,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          labelText: textEmail,
          hintText: textEgEmail,
          contentPadding: EdgeInsets.all(8.0)),
      validator: (text) => validationEmail(text),
      onSaved: (text) => email = text,
    );
  }

  RaisedButton interestButton() {
    return RaisedButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          interestRequest(salutation, name, email, context);
        } else {
          setState(() {
            _autoValidate = true;
          });
        }
      },
      color: Colors.green,
      child: Text(
        textButton,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  SizedBox sizedBox() {
    return SizedBox(
      height: 10.0,
    );
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  validationSalutation(String text) {
    if (text.isEmpty) {
      return textValSalution;
    }
    return null;
  }

  validationName(String text) {
    if (text.isEmpty) {
      return textValName;
    }
    return null;
  }

  validationEmail(String text) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (text.isEmpty) {
      return textValEmail;
    } else if (!regex.hasMatch(text)) {
      return textValEmail2;
    }
    return null;
  }

  interestRequest(String salutation, String name, String email,
      BuildContext context) async {
    var result = await RequestServer().makeGetRequest(salutation, name, email);
    if (result.statusCode == 200) {
      Map<String, dynamic> resultDecode = jsonDecode(result.body);
      print(resultDecode);
      var flag = resultDecode["flag"];
      var message = resultDecode["message"];
      print(flag);
      print(message);
      if (flag == 1) {
        showResult(context, message);
      }
      // showToast(context, message);
    }
  }

  showResult(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(message),
          );
        });
  }
}
