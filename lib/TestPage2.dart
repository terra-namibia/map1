// ignore_for_file: unnecessary_string_interpolations, avoid_print
import 'package:flutter/material.dart';

class TestPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Test2"),
        ),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
                onPressed: () => {
                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(builder: (context) {
                      //   return TestPage3();
                      // }))
                    },
                child: const Text("進む", style: TextStyle(fontSize: 30))),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
                onPressed: () => {Navigator.of(context).pop()},
                child: const Text("戻る", style: TextStyle(fontSize: 30))),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8),
            child: const Text('TextButton'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const TextButton(
                onPressed: null,
                child: Text('disabled'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('enabled'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.red,
                ),
                onPressed: () {},
                child: const Text('enabled'),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 8),
            child: const Text('OutlinedButton'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const OutlinedButton(
                onPressed: null,
                child: Text('disabled'),
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Text('enabled'),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  primary: Colors.red,
                ),
                child: const Text('enabled'),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 8),
            child: const Text('ElevatedButton'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const ElevatedButton(
                onPressed: null,
                child: Text('disabled'),
              ),
              ElevatedButton(
                onPressed: () => {print("ElevatedButtonがおされたよ")},
                child: const Text('enabled'),
              ),
              ElevatedButton(
                onPressed: () => {print("ElevatedButtonがおされたよ")},
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  elevation: 16,
                ),
                child: const Text('enabled'),
              ),
            ],
          ),
        ])));
  }
}
