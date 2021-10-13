import 'package:agenda_contatos_v2/helpers/contact_helper.dart';
import 'package:agenda_contatos_v2/helpers/image_handle.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key, this.contact}) : super(key: key);

  final Contact? contact;

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final ImagePicker _picker = ImagePicker();
  final _nameFocus = FocusNode();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  Contact? _editedContact;
  bool _userEdited = false;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact!.toMap());
      _nameController.text = _editedContact?.name ?? "";
      _phoneController.text = _editedContact?.phone ?? "";
      _emailController.text = _editedContact?.email ?? "";
    }
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Descatar Alterações?"),
            content: const Text("Ao sair, todas as alterações serão perdidas."),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black87),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black26),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Sim",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        },
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _picker
                            .pickImage(
                          source: ImageSource.gallery,
                        )
                            .then((value) {
                          if (value != null) {
                            setState(() {
                              _userEdited = true;
                              _editedContact?.img = value.path;
                            });
                          }
                        });
                      },
                      child: const Text(
                        "Galeria",
                        style: TextStyle(color: Colors.red, fontSize: 20.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        _picker
                            .pickImage(
                          source: ImageSource.camera,
                        )
                            .then((value) {
                          if (value != null) {
                            setState(() {
                              _userEdited = true;
                              _editedContact?.img = value.path;
                            });
                          }
                        });
                      },
                      child: const Text(
                        "Camera",
                        style: TextStyle(color: Colors.red, fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            _editedContact?.name ?? "Novo Contato",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () {
            if (!_userEdited) {
              FocusScope.of(context).requestFocus(_nameFocus);
            } else if (_editedContact!.name == null) {
              FocusScope.of(context).requestFocus(_nameFocus);
            } else if (_editedContact!.name!.isEmpty) {
              FocusScope.of(context).requestFocus(_nameFocus);
            } else {
              Navigator.pop(context, _editedContact);
            }
          },
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.white60,
        body: Card(
          margin: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _showOptions(context);
                  },
                  child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: imageHandle(_editedContact!.img),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                ),
                TextField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  decoration: const InputDecoration(labelText: "Nome"),
                  onChanged: (value) {
                    _userEdited = true;
                    setState(() {
                      _editedContact?.name = value;
                    });
                  },
                ),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: "Telefone"),
                  onChanged: (value) {
                    _userEdited = true;
                    _editedContact?.phone = value;
                  },
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "E-mail"),
                  onChanged: (value) {
                    _userEdited = true;
                    _editedContact?.email = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
