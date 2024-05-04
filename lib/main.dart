import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(title: 'Практика 5'),
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
  int currentPageIndex = 0;
  List<String> genres = [];
  List<String> songs = [];
  List<String> artists = [];

  TextEditingController songsController = TextEditingController();
  TextEditingController genreTextController = TextEditingController();
  TextEditingController artistTextController = TextEditingController();

  Future<void> waitServerAns(){
    return Future.delayed(const Duration(seconds: 3));
  }
  
  void addArtist(){
    String artist = artistTextController.text;
    artistTextController.clear();

    Future<void> wait = waitServerAns();
    wait.then((value){

      if(artist.isNotEmpty && !artists.contains(artist)){
        setState(() {
          artists.add(artist);
        });

      }
    });
  }

  Future<void> removeArtist() async{
    String artist = artistTextController.text;
    artistTextController.clear();

    await waitServerAns();
    if(artist.isNotEmpty){
      setState(() {
        artists.remove(artist);
      });
    }
  }

  void addNote() {
    String note = songsController.text;
    if (note.isNotEmpty) {
      setState(() {
        songs.add(note);
        songsController.clear();
      });
    }
  }

  void removeSong(){
    String song = songsController.text;
    if (song.isNotEmpty && !songs.contains(song)) {
      setState(() {
        songs.remove(song);
        songsController.clear();
      });
    }
  }

  void addGenre(){
    String genre = genreTextController.text;
    if (genre.isNotEmpty && !genres.contains(genre)) {
      setState(() {
        genres.add(genre);
        genreTextController.clear();
      });
    }
  }

  void removeGenre(){
    String genre = genreTextController.text;
    if (genre.isNotEmpty) {
      setState(() {
        genres.remove(genre);
        genreTextController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      // navbar
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.deepPurple,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.people),
              label: 'Музыканты',
            ),
            NavigationDestination(
              icon: Icon(Icons.music_note),
              label: 'Песни',
            ),
            NavigationDestination(
                icon: Icon(Icons.grading),
                label: 'Жанры'),
          ],
        ),


        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(widget.title),
        ),
        body: <Widget>[

          // musicians
          Column(
            children: [
              Expanded(child:
              ListView.separated(
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                        padding: const EdgeInsets.symmetric(vertical:10),
                        child: Text(artists[index])
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                  itemCount: artists.length)
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: removeArtist,
                      icon: const Icon(Icons.remove_circle),
                      color: Colors.red
                  ),
                  Expanded(
                    child: TextField(
                      controller: artistTextController,
                      decoration: const InputDecoration(
                        hintText: 'Музыкант',
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: addArtist,
                      icon: const Icon(Icons.add_circle)
                  )
                ],
              )
            ],
          ),

          // chat
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      return Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            songs[index],
                            style: theme.textTheme.bodyLarge!
                                .copyWith(color: theme.colorScheme.onPrimary),
                          ),
                        ),
                      );
                    }
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: removeSong,
                      icon: const Icon(Icons.remove_circle),
                      color: Colors.red,
                    ),
                    Expanded(
                      child: TextField(
                        controller: songsController,
                        decoration: const InputDecoration(
                          hintText: 'Песня',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: addNote,
                      color: Colors.deepPurple,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: genres.map((item) => Text (item)).toList(),
                      )
                  ),
                ),
                Row(
                    children: [
                      IconButton(
                          onPressed: removeGenre,
                          icon: const Icon(Icons.remove_circle),
                          color: Colors.red
                      ),
                      Expanded(
                        child: TextField(
                          controller: genreTextController,
                          decoration: const InputDecoration(
                            hintText: 'Жанр',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle),
                        onPressed: addGenre,
                        color: Colors.deepPurple,
                      ),
                    ]
                )
              ]
          )

        ][currentPageIndex]

    );
  }
}