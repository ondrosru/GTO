import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/card_padding.dart';
import 'package:gtoserviceapp/components/widgets/dialogs/error_dialog.dart';
import 'package:gtoserviceapp/screens/info/main_screen.dart';
import 'package:gtoserviceapp/screens/profile/common/profile.dart';
import 'package:gtoserviceapp/services/auth/auth.dart';
import 'package:gtoserviceapp/services/repo/user.dart';

class RegisterCompleteScreen extends StatefulWidget {
  final String _email;
  final String _token;

  RegisterCompleteScreen(this._email, this._token);

  @override
  _RegisterCompleteScreenState createState() => _RegisterCompleteScreenState();
}

class _RegisterCompleteScreenState extends State<RegisterCompleteScreen> {
  final _formKey = GlobalKey<FormState>();
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Завершение регистрации"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.close),
          onPressed: _onClosePressed,
        )
      ],
    );
  }

  void _onClosePressed() {
    var nav = Navigator.of(context);
    nav.popUntil((_) => !nav.canPop());
    nav.pushReplacement(MaterialPageRoute(builder: (_) {
      return MainScreen();
    }));
  }

  Widget _buildBody() {
    return CardPadding(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _buildEmailField(),
            _buildPasswordField(),
            _buildConfirmPasswordField(),
            SizedBox(height: 16),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      initialValue: widget._email,
      enabled: false,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        hintText: "Пароль",
      ),
      onChanged: (text) {
        _password = text;
      },
      validator: (text) {
        if (text.length < 6) {
          return "Пароль должен содержать по крайней мере 6 символов";
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        hintText: "Повторите пароль",
      ),
      validator: (text) {
        if (text != _password) {
          return "Пароли должны совпадать";
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return RaisedButton(
      onPressed: _onSubmitPressed,
      child: Text("Завершить регистрацию"),
    );
  }

  void _onSubmitPressed() async {
    var form = _formKey.currentState;
    if (!form.validate()) {
      return;
    }
    form.save();

    try {
      await Auth.I.setToken(widget._token);
      await UserRepo.I.register(_password);
      await Auth.I.login(widget._email, _password);
      var nav = Navigator.of(context);
      nav.popUntil((_) => !nav.canPop());
      nav.pushReplacement(MaterialPageRoute(builder: (_) => ProfileScreen()));
    } catch (e) {
      showDialog(context: context, child: ErrorDialog.fromError(e));
    }
  }
}
