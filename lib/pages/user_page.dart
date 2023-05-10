import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:optairconnect/controllers/account_controller.dart';
import 'package:optairconnect/models/account_model.dart';
import 'package:optairconnect/shared/optair_wrapper.dart';

class UserPage extends StatefulWidget {
  final AccountController _accountController = AccountController();

  UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  void _refreshList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return OptAirWrapper(
      title: 'Konto',
      body: _Form(widget._accountController, _refreshList),
    );
  }
}

class _Form extends StatefulWidget {
  final AccountController _accountController;
  final VoidCallback _refreshList;

  _Form(this._accountController, this._refreshList);

  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<_Form> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameFieldController = TextEditingController();
  final TextEditingController _emailFieldController = TextEditingController();
  final TextEditingController _passwordFieldController =
      TextEditingController();

  @override
  void dispose() {
    _nameFieldController.dispose();
    _emailFieldController.dispose();
    _passwordFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Account?>(
        future: widget._accountController.getCurrentUser(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text('Loading..'));
          } else {
            final account = snapshot.data!;
            return Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _nameFieldController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _nameFieldController,
                      decoration: const InputDecoration(
                        labelText: 'E-Mail',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'E-Mail';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _nameFieldController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Password';
                        }
                        return null;
                      },
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await widget._accountController.updateUser(
                                  Account(
                                      account.id,
                                      _nameFieldController.text,
                                      _emailFieldController.text,
                                      _passwordFieldController.text));
                              widget._refreshList();
                            }
                          },
                          child: const Text('Add Device'),
                        )),
                  ],
                ),
              ),
            );
          }
        });
  }
}
