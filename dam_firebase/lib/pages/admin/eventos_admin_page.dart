import 'package:dam_firebase/pages/admin/detalles_evento_page.dart';
import 'package:dam_firebase/pages/login_page.dart';
import 'package:dam_firebase/pages/admin/noticias_compra_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'noticia_admin_page.dart';

class eventosadminPage extends StatelessWidget {
  const eventosadminPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const BottomNav(),
    );
  }
}

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int indexSel = 0;
  final bool _admin = false;

  static List<Widget> paginas = [
    noticiaAdminPage(),
    noticiasCompraPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(children: [
            Text("USM Eventos"),
            Spacer(),
          ]),
          actions: [
            PopupMenuButton(
              icon: Icon(Icons.account_circle),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'tickets',
                  child: Text('Ver entradas compradas'),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Text('Cerrar Sesión'),
                ),
              ],
              onSelected: (opcionSeleccionada) {
                if (opcionSeleccionada == 'logout') {
                  logout(context);
                }
                if (opcionSeleccionada == 'tickets') {
                  MaterialPageRoute route = MaterialPageRoute(
                      builder: (context) => DetallesEventoPage());
                  Navigator.push(context, route);
                }
              },
            ),
          ],
          leading: Icon(MdiIcons.book),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.purple[300],
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                MdiIcons.newspaper,
                color: Colors.white,
              ),
              label: "Eventos",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                MdiIcons.ticket,
                color: Colors.white,
              ),
              label: "Tickets",
            ),
          ],
          currentIndex: indexSel,
          onTap: pagSel,
        ),
        body: paginas[indexSel]);
  }

  void pagSel(int index) {
    setState(() {
      indexSel = index;
    });
  }

  BottomNavigationBarItem agregarNoticia(bool admin) {
    if (_admin == true) {
      return BottomNavigationBarItem(
        icon: Icon(
          MdiIcons.book,
          color: Colors.white,
        ),
        label: "Agregar Noticia",
      );
    } else {
      return BottomNavigationBarItem(
        icon: Icon(MdiIcons.cancel),
        label: "Blocked",
      );
    }
  }
}

Future<String> getUser() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  return sp.getString('user') ?? '';
}

void logout(BuildContext context) async {
  //cerrar sesion en firebase
  await FirebaseAuth.instance.signOut();

  //borrar user email de shared preferences
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.remove('user');

  //redirigir al login
  MaterialPageRoute route =
      MaterialPageRoute(builder: ((context) => LoginPage()));
  Navigator.pushReplacement(context, route);
}
