import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xs_progress_hud/xs_progress_hud.dart';

class ProgressBloc extends BlocBase {
  void mostrarLoading(BuildContext contexto, bool ativar) {
    XsProgressHud hud = XsProgressHud();
    hud.progressColor = Colors.red;
    if (ativar) {
      XsProgressHud.show(contexto);
    } else {
      XsProgressHud.hide();
    }
  }
}
