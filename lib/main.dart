import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts_arabic/fonts.dart';
// http اضافة باكيج
import 'package:http/http.dart' as http;

//الاتصال بالسيرفر و ارسال الداتا
Future<Album> createAlbum(String title) async {
  final response = await http.post(
    Uri.https('jsonplaceholder.typicode.com', 'albums'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      <String, String>{
        'title': title,
      },
    ),
  );

  if (response.statusCode == 201) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

//اضافة كلاس الالبوم
class Album {
  final int id;
  final String title;

  Album({this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();
  Future<Album> _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نموذج ادخال المعلومات بواسطة الاي بي اي',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'نموذج استخدام الاي بي اي ',
            style: new TextStyle(
                fontFamily: ArabicFonts.Cairo, package: 'google_fonts_arabic'),
          ),
          centerTitle: true,
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (_futureAlbum == null)
              ?
              //ادخال المعلومة بواسطة المستخدم
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'ادخال',
                      ),
                    ),
                    ElevatedButton(
                      child: Text(
                        'ادخل المعلومة',
                        style: new TextStyle(
                            fontFamily: ArabicFonts.Cairo,
                            package: 'google_fonts_arabic'),
                      ),
                      onPressed: () {
                        setState(() {
                          _futureAlbum = createAlbum(_controller.text);
                        });
                      },
                    ),
                  ],
                )
              //اضهار المعلومة على الشاشة
              : FutureBuilder<Album>(
                  future: _futureAlbum,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data.title);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return CircularProgressIndicator();
                  },
                ),
        ),
      ),
    );
  }
}
//                 style: new TextStyle(
//                 fontFamily: ArabicFonts.Cairo,
//                 package: 'google_fonts_arabic',
