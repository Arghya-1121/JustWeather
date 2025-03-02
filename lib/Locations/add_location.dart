import 'package:flutter/material.dart';
import 'package:weather03/Helper/location_manager.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key, required this.appName});
  final String appName;
  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  List<String> locations = [];
  final TextEditingController wantToAdd = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  void _loadLocations() async {
    final savedLocations = await LocationManager.getLocation();
    setState(() {
      locations = savedLocations;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(thickness: 2),
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  final location = locations[index];
                  return ListTile(
                    title: Text(location),
                    trailing: IconButton(
                      onPressed: () {
                        LocationManager.removeLocation(location);
                        _loadLocations();
                      },
                      icon: Icon(Icons.delete_outline),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}