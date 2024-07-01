import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:auth/repositories/user_repository.dart';
import 'package:auth/models/user_models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Firebase Setup'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _userService.createUser(UserModel(
                  id: '',
                  name: "Duwarahan",
                  email: "abc",
                  age: 10,
                  createdAt: DateTime.now().toIso8601String(),
                ));
              },
              child: const Text("Create Data"),
            ),
            Expanded(
              // child: FutureBuilder<List<User>>(
              child: StreamBuilder<List<UserModel>>(
                // future: UserService().readUsers(),
                stream:
                    UserService().getUsersStream(), // Replace with your stream

                // builder: (context, AsyncSnapshot<List<User>> snapshot) {
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No users found'));
                  } else {
                    // Display the list of users
                    final users = snapshot.data!;

                    // return ListView.builder(
                    //   itemCount: users.length,
                    //   itemBuilder: (context, index) {
                    //     User user = users[index];
                    //     return ListTile(
                    //       title: Text(user.name),
                    //       subtitle: Text(user.email),
                    //       trailing: Text('${user.age} years old'),
                    //     );
                    //   },
                    // );

                    return Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Column(
                          children: users.map((user) {
                            return ListTile(
                                title: Text(user.name),
                                subtitle: Text(user.email),
                                leading: GestureDetector(
                                  onTap: () async {
                                    await UserService().deleteUser(user.id!);
                                  },
                                  child: const Icon(Icons.delete),
                                ),
                                trailing: GestureDetector(
                                  onTap: () async {
                                    await UserService().updateUser(UserModel(
                                      id:user.id,
                                      name: "Sachi",
                                      email: "Modayek",
                                      age: 18,
                                      createdAt: user.createdAt,
                                    ));
                                  },
                                  child: const Icon(Icons.update),
                                )

                                // trailing: Text('${user.age} years old'),
                                );
                          }).toList(),
                        ));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
