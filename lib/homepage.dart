import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _dogs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDogs();
  }

  Future<void> _fetchDogs() async {
    final response =
        await http.get(Uri.parse('https://api.thedogapi.com/v1/breeds'));
    if (response.statusCode == 200) {
      setState(() {
        _dogs = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load dogs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _dogs.length,
              itemBuilder: (context, index) {
                final dog = _dogs[index];
                final imageUrl = dog['image'] != null
                    ? dog['image']['url']
                    : 'https://via.placeholder.com/150';

                return ListTile(
                  leading: Image.network(
                    imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(dog['name']),
                  subtitle: Text(dog['origin'] ?? 'Unknown'),
                );
              },
            ),
    );
  }
}
