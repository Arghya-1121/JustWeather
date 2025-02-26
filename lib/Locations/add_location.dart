import 'package:flutter/material.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key, required this.appName});

  final String appName;

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  @override
  Widget build(BuildContext context) {
    TextEditingController wantToAdd = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Location'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add_location_alt_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          spacing: 8,
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextField(
                autocorrect: true,
                autofocus: true,
                controller: wantToAdd,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 18, color: Colors.black),
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  hintText: 'Enter Location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  suffixIcon: Icon(Icons.add_location_outlined),
                  focusColor: Colors.cyan,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
