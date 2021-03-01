/*class _HomeState extends State<Home> {
  final PageController ctrl = PageController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: PageView(
              scrollDirection: Axis.vertical,
              controller: ctrl,
              children: [
            Text('Hello, ${widget.credentials.email} !'),
            // ignore: deprecated_member_use
            RaisedButton(
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              },
              child: Text('Sign out'),
            ),
            Container(color: Colors.green),
            Container(color: Colors.blue),
            Container(color: Colors.orange),
          ])),
    );
    Scaffold(
        */ /*body: Center(
          child: Column(
        children: [
          Text('Hello, ${widget.credentials.email} !'),
          RaisedButton(
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
            child: Text('Sign out'),
          ),
        ],
      )),*/ /*
        );
  }
}*/