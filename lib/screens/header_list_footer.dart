import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: ApplicationAppBar(), body: const MyHomePageImpl());
  }
}

class MyHomePageImpl extends StatefulWidget {
  const MyHomePageImpl({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageImpl createState() => _MyHomePageImpl();
}

class _MyHomePageImpl extends State<MyHomePageImpl> {
  final Future<int> loadDataAsync = Future<int>.delayed(
    const Duration(seconds: 1),
    () async => processDataAsync(),
  );

  static Future<int> processDataAsync() async {
    return 20;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.fromLTRB(10, 10, 7, 10),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.red,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: const Text("Fixed Header"),
        ),
        Expanded(
          child: FutureBuilder(
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Error: ${snapshot.error}'),
                      )
                    ],
                  ),
                );
              }
              if (!snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      SizedBox(height: 20),
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      )
                    ],
                  ),
                );
              }
              return Column(
                children: [
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.red,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.lightGreen,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Center(
                              child: Text(
                                'Child $index',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 22),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ))
                ],
              );
            },
            future: loadDataAsync,
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.red,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: const Text("Fixed Footer"),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}

class ApplicationAppBar extends AppBar {
  ApplicationAppBar({Key? key})
      : super(
          key: key,
          title: const Text("Fixed Header & Footer"),
          actions: [
            IconButton(icon: const Icon(Icons.add), onPressed: () {}),
          ],
        );
}
