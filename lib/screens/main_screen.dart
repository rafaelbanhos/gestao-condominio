import 'dart:io';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_final/bloc/report_bloc.dart';
import 'package:projeto_final/bloc/user_bloc.dart';
import 'package:projeto_final/screens/new_report_screen.dart';
import 'package:projeto_final/screens/profile_screen.dart';
import 'package:projeto_final/screens/reports_screen.dart';
import 'meeting_screen.dart';
import 'infos_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 0;
  final List<Widget> screens = [
    ReportsScreen(),
    ChatScreen(),
    Infos(),
    Profile(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = ReportsScreen();
  var userBloc = BlocProvider.getBloc<UserBloc>();
  var promotionBloc = BlocProvider.getBloc<ReportBloc>();

  Future _redirectToCamera(ImageSource imageType) async {
    File image = await ImagePicker.pickImage(source: imageType);

    if (image == null) return;

    File newImage = await promotionBloc.imageSelected(image);

    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => NewReportScreen(newImage)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(8, 86, 151, 1),
        child: Icon(Icons.camera_alt),
        onPressed: () {
          {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext bc) {
                  return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                              Flexible(
                                child: Text(
                                  "Selecione de captura da imagem",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Opacity(
                                  opacity: 0.0,
                                  child: IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: null,
                                  )),
                            ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            FlatButton.icon(
                              icon: Icon(Icons.camera,
                                  color: Colors.blue, size: 20),
                              label: Text("Camera",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[850])),
                              onPressed: () async {
                                await _redirectToCamera(ImageSource.camera);
                              },
                            ),
                            FlatButton.icon(
                              icon: Icon(Icons.photo,
                                  color: Colors.blue, size: 20),
                              label: Text("Galeria",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[850])),
                              onPressed: () async {
                                await _redirectToCamera(ImageSource.gallery);
                              },
                            )
                          ],
                        )
                      ]);
                });
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = ReportsScreen();
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.home,
                          color: currentTab == 0 ? Color.fromRGBO(8, 86, 151, 1) : Colors.grey,
                        ),
                        Text(
                          'Denúncias',
                          style: TextStyle(
                            color: currentTab == 0 ? Color.fromRGBO(8, 86, 151, 1) : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = ChatScreen();
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.chat,
                          color: currentTab == 1 ? Color.fromRGBO(8, 86, 151, 1) : Colors.grey,
                        ),
                        Text(
                          'Atas',
                          style: TextStyle(
                            color: currentTab == 1 ? Color.fromRGBO(8, 86, 151, 1) : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = Infos();
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.info_outline,
                          color: currentTab == 2 ? Color.fromRGBO(8, 86, 151, 1) : Colors.grey,
                        ),
                        Text(
                          'Infos',
                          style: TextStyle(
                            color: currentTab == 2 ? Color.fromRGBO(8, 86, 151, 1) : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = Profile();
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          color: currentTab == 3 ? Color.fromRGBO(8, 86, 151, 1) : Colors.grey,
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(
                            color: currentTab == 3 ? Color.fromRGBO(8, 86, 151, 1) : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
