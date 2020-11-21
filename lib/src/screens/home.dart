import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  var data;

  var firesotre = FirebaseFirestore.instance.collection('product').snapshots();

  addData() {
    Map<String, dynamic> demoData = {"name": "soyhan"};

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('product');

    collectionReference.add(demoData);
  }

  getData() {
    FirebaseFirestore.instance
        .collection('product')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        data = snapshot.docs;
      });
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        FlatButton(
          child: Text("Ekle"),
          onPressed: () {
            addData();
          },
        ),
        FlatButton(
          child: Text("Getir"),
          onPressed: () {
            getData();
          },
        ),
        Text(data[2].data()['name']),
        Expanded(
          child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data[index].data()['name']),
                );
              }),
        )
      ],
    ));
    //     body: StreamBuilder() Center(
    //   child: FlatButton(
    //     child: Text("Logout"),
    //     onPressed: () {
    //       auth.signOut();
    //       Navigator.of(context).pushReplacement(
    //           MaterialPageRoute(builder: (context) => LoginScreen()));
    //     },
    //   ),
    // ));
  }
}
