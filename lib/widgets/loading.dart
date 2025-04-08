import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColorDark;
    return CupertinoActivityIndicator(color: color);
  }
}
