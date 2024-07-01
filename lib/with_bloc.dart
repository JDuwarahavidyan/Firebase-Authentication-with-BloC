import 'package:auth/bloc/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => UserBloc()
            ..add(
                UserReadEvent()), // when the app first initialized load from the database.
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Firebase Setup'),
      ),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                BlocProvider.of<UserBloc>(context)
                    .add( UserCreateEvent(UserModel(
                  name: "Duwarahan",
                  email: "duwa2323@gmail.com",
                  age: 10,
                  createdAt: DateTime.now().toIso8601String(),
                )));
              },
              child: const Text("Create Data"),
            ),
            const SizedBox(height: 20),
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is UserFailure) {
                  return const Center(
                    child: Text("Something went wrong"),
                  );
                }

                if (state is UserLoaded) {
                  final users = state.users;

                  return users.isEmpty
                  ? const Center(child: Text("No Users Found"))
                  : Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Column(
                        children: users.map((user) {
                          return ListTile(
                              title: Text(user.name),
                              subtitle: Text(user.email),
                              leading: GestureDetector(
                                onTap: () {
                                  BlocProvider.of<UserBloc>(context)
                                      .add(UserDeleteEvent(user.id!));
                                },
                                child: const Icon(Icons.delete),
                              ),
                              trailing: GestureDetector(
                                onTap: () async {
                                  BlocProvider.of<UserBloc>(context)
                                      .add(UserUpdateEvent(UserModel(
                                    id: user.id,
                                    name: "Sachinthana",
                                    email: "sachi@gmail.com",
                                    age: 18,
                                    createdAt: user.createdAt,
                                  )));
                                },
                                child: const Icon(Icons.update),
                              )

                              // trailing: Text('${user.age} years old'),
                              );
                        }).toList(),
                      ),
                    );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
