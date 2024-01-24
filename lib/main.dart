import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tornament_temp/firebase_options.dart';
import 'package:tornament_temp/modals/tornament.dart';
import 'package:tornament_temp/pesentations/add_tornament_screen.dart';
import 'package:tornament_temp/state/tournament_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TournamentProvider())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<TournamentProvider>(
      builder: (context, tournamentProvider, child) {
        tournamentProvider.fetchTournaments();
        final tournaments = tournamentProvider.tournaments;
        return Scaffold(
          appBar: AppBar(
            title: const Text("Tornament app"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                SizedBox(
                  height: size.height,
                  child: ListView.builder(
                    itemCount: tournaments.length,
                    itemBuilder: (context, index) {
                      final tournament = tournaments[index];
                      return ListTile(
                        title: Text(tournament.title),
                        subtitle:
                            Text('${tournament.type} - ${tournament.venue}'),
                        onTap: () {
                          Tournament currentTornament = tournament;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => AddTornamentScreen(
                                        tournamentToEdit: tournament,
                                      ))));
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const AddTornamentScreen())));
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
