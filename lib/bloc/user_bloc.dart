import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:projeto_final/bloc/progress_bloc.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends BlocBase {
  FirebaseUser firebaseUser;

  final _googleSignInController = BehaviorSubject<bool>();
  final _ehSindicoController = BehaviorSubject<bool>();

  Stream<bool> get outEhSindicoLogado => _ehSindicoController.stream;

  Stream<bool> get outGoogleSignIn => _googleSignInController.stream;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _fireStore = Firestore.instance;

  var progressBloc = BlocProvider.getBloc<ProgressBloc>();

  UserBloc() {
    _loadCurrentUser();
  }

  Future<FirebaseUser> ensureLoggedInWithGoogle(
      String email, String senha, BuildContext contexto) async {
    progressBloc.mostrarLoading(contexto, true);

    firebaseUser = await _auth
        .signInWithEmailAndPassword(email: email, password: senha)
        .catchError((error) {
      return null;
    });

    if (firebaseUser == null) {
      progressBloc.mostrarLoading(contexto, false);
      return null;
    }

    isLoggedIn();
    await _saveUserData();

    progressBloc.mostrarLoading(contexto, false);
    await verificarSeEhSindico();
    return firebaseUser;
  }

  Future _saveUserData() async {
    if (firebaseUser == null) {
      signOut();
    }

    Map<String, dynamic> userData = {
      "id": firebaseUser.uid,
      "email": firebaseUser.email
    };

    DocumentSnapshot userModel = await userInformationsById();

    if (userModel == null) {
      await _fireStore
          .collection('usuarios')
          .document(firebaseUser.uid)
          .setData(userData);
    } else {
      await _fireStore
          .collection('usuarios')
          .document(firebaseUser.uid)
          .updateData(userData);
    }
  }

  Future<DocumentSnapshot> userInformationsById() async {
    DocumentSnapshot documentSnapshot = await Firestore.instance
        .collection("usuarios")
        .document(firebaseUser.uid)
        .get();

    return documentSnapshot.exists ? documentSnapshot : null;
  }

  Future signOut() async {
    await _auth.signOut();
    firebaseUser = null;
    isLoggedIn();
  }

  FirebaseUser userConnected() {
    return firebaseUser;
  }

  bool isLoggedIn() {
    bool isLogged = firebaseUser != null;
    _googleSignInController.add(isLogged);
    return isLogged;
  }

  Future<Null> _loadCurrentUser() async {
    firebaseUser = await _auth.currentUser();
  }

  Future verificarSeEhSindico() async {
    DocumentSnapshot documentReference = await Firestore.instance
        .collection("sindicos")
        .document(firebaseUser.uid)
        .get();

    bool ehSindico = documentReference.exists;

    _ehSindicoController.add(ehSindico);

    return ehSindico;
  }

  @override
  void dispose() {
    _googleSignInController.close();
    _ehSindicoController.close();
  }
}
