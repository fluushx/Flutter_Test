import 'package:flutter/material.dart';
import 'package:flutter_prueba/NewsDetails.dart';

import 'GetRss.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ' ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Ejercicio'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      GetRss.getRss();
    });
    return Scaffold(
      //titulo principal
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder(
          future: GetRss.getRss(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                // TODO: Handle this case.
                break;
              case ConnectionState.waiting:
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.cloud_download),
                      Text("Cargando Información...")
                    ],
                  ),
                );
                break;
              case ConnectionState.active:
                // TODO: Handle this case.
                break;
              case ConnectionState.done:
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    child: ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          // permite obtener cuando el usuario da clic a un elemento en
                          //este caso engloba a toda la fila y cuando se presione en cualquier parte de la
                          //fila manda a la siguiente pantalla,
                          return InkWell(
                            onTap: () {
                              // se presiona el boton y se envia al link principal
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewsDetails(
                                    title: "Noticia",
                                    url: snapshot.data[index].urlNoticia,
                                    key: null,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              //creacion de la fila con 4 elementos
                              children: [
                                Expanded(
                                  child: snapshot.data[index].imagen != null
                                      ? CircleAvatar(
                                          radius: 25.0,
                                          backgroundImage: NetworkImage(
                                              snapshot.data[index].imagen),
                                          backgroundColor: Colors.transparent,
                                        )
                                      : Image.asset('assets/error.png'),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data[index].titulo,
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                      Text(
                                        snapshot.data[index].descripcion,
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.grey),
                                      ),
                                      Text(
                                        snapshot.data[index].fecha,
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  flex: 4,
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(
                              color: Colors.grey,
                            ),
                        itemCount: snapshot.data.length),
                  ),
                );
                break;
            }
            return null;
          },
        ),
      ),
    );
  }
}
