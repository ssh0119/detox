import 'dart:convert';
import 'package:detox/pathImage.dart';
import 'package:detox/requestServer.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title})
      : super(key: key); // Key를 nullable로 변경
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
  String textValEmail2 = "Please enter valid email";

  String salutation = "", name = "", email = "";

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

  AppBar header() {
    return AppBar(
      title: Row(
        children: <Widget>[
          logo(),
          Text(title),
        ],
      ),
    );
  }

  Widget content() {
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

  Widget logo() {
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
      aspectRatio: 2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Image.asset(PathImage().pathPicture, fit: BoxFit.contain),
      ),
    );
  }

  Widget form() {
    return Form(
      key: _formKey,
      autovalidateMode: _autoValidate
          ? AutovalidateMode.always
          : AutovalidateMode.disabled, // autovalidateMode로 변경
      child: Container(
        margin: const EdgeInsets.fromLTRB(15, 8, 15, 8),
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
          contentPadding: const EdgeInsets.all(8.0)),
      validator: (text) => validationSalutation(text),
      onSaved: (text) => salutation = text ?? "",
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
          contentPadding: const EdgeInsets.all(8.0)),
      validator: (text) => validationName(text),
      onSaved: (text) => name = text ?? "",
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
          contentPadding: const EdgeInsets.all(8.0)),
      validator: (text) => validationEmail(text),
      onSaved: (text) => email = text ?? "",
    );
  }

  Widget interestButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          interestRequest(salutation, name, email, context);
        } else {
          setState(() {
            _autoValidate = true;
          });
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
      ),
      child: Text(
        textButton,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget sizedBox() {
    return const SizedBox(
      height: 10.0,
    );
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  String? validationSalutation(String? text) {
    if (text == null || text.isEmpty) {
      return textValSalution;
    }
    return null;
  }

  String? validationName(String? text) {
    if (text == null || text.isEmpty) {
      return textValName;
    }
    return null;
  }

  String? validationEmail(String? text) {
    final pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final regex = RegExp(pattern);
    if (text == null || text.isEmpty) {
      return textValEmail;
    } else if (!regex.hasMatch(text)) {
      return textValEmail2;
    }
    return null;
  }

  void interestRequest(String salutation, String name, String email,
      BuildContext context) async {
    final result =
        await RequestServer().makeGetRequest(salutation, name, email);

    if (result != null && result.statusCode == 200) {
      final Map<String, dynamic> resultDecode = jsonDecode(result.body);
      final flag = resultDecode["flag"];
      final message = resultDecode["message"];
      if (flag == 1) {
        showResult(context, message);
      }
    } else {
      // 요청 실패 처리
      showResult(context, "Failed to connect to the server. Please try again.");
    }
  }

  void showResult(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
        );
      },
    );
  }
}
