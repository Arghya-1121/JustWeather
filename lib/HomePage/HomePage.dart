import 'package:flutter/material.dart';
import 'package:weather03/Locations/add_location.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.appName});

  final String appName;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appName),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddLocation(appName: widget.appName),
                  ),
                ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
