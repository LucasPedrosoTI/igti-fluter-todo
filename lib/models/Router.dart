import 'package:flutter/material.dart';

class Router {
  BuildContext _context;

  Router();

  set context(BuildContext value) {
    _context = value;
  }

  to({Widget page, Function function}) {
    return Navigator.push(_context,
        MaterialPageRoute(builder: (context) => page)).then((value) => function.call());
  }
}
