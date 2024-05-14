import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Resource Preloading Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PreloadResourcesScreen(),
    );
  }
}

class PreloadResourcesScreen extends StatefulWidget {
  @override
  _PreloadResourcesScreenState createState() => _PreloadResourcesScreenState();
}

class _PreloadResourcesScreenState extends State<PreloadResourcesScreen> {
  final List<String> imageUrls = [
    'https://fastly.picsum.photos/id/10/2500/1667.jpg?hmac=J04WWC_ebchx3WwzbM-Z4_KC_LeLBWr5LZMaAkWkF68',
    'https://fastly.picsum.photos/id/9/5000/3269.jpg?hmac=cZKbaLeduq7rNB8X-bigYO8bvPIWtT-mh8GRXtU3vPc',
    'https://fastly.picsum.photos/id/11/2500/1667.jpg?hmac=xxjFJtAPgshYkysU_aqx2sZir-kIOjNR9vx0te7GycQ',
    'https://fastly.picsum.photos/id/13/2500/1667.jpg?hmac=SoX9UoHhN8HyklRA4A3vcCWJMVtiBXUg0W4ljWTor7s',
    'https://fastly.picsum.photos/id/18/2500/1667.jpg?hmac=JR0Z_jRs9rssQHZJ4b7xKF82kOj8-4Ackq75D_9Wmz8'
  ];

  final List<String> iconUrls = [
    'https://img.icons8.com/search',
    'https://img.icons8.com/home',
    'https://img.icons8.com/arrow',
    'https://img.icons8.com/music',
    'https://img.icons8.com/user'
  ];

  Future<void> preloadResources() async {
    try {
      await _preloadUrls(imageUrls);
      await _preloadUrls(iconUrls);
    } catch (e) {
      print('Error loading resources: $e');
    }
  }

  Future<void> _preloadUrls(List<String> urls) async {
    for (String url in urls) {
      await http.get(Uri.parse(url));
    }
  }

  @override
  void initState() {
    super.initState();
    preloadResources();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 233, 226, 226),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 245, 212, 212),
          title: Text('MY_APP'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Images'),
              Tab(text: 'Icons'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ImageList(imageUrls: imageUrls),
            IconList(iconUrls: iconUrls),
          ],
        ),
      ),
    );
  }
}

class ImageList extends StatelessWidget {
  final List<String> imageUrls;

  const ImageList({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 60, right: 60, top: 20),
      child: ListView(
        children: imageUrls.map((url) {
          return Card(
            child: Column(
              children: [
                Image.network(
                  url,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class IconList extends StatelessWidget {
  final List<String> iconUrls;

  const IconList({required this.iconUrls});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: iconUrls.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Image.network(iconUrls[index]),
        );
      },
    );
  }
}
