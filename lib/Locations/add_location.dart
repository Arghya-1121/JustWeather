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
  bool _currentLocationEnable = true;
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
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(),
              child: ListTile(
                autofocus: false,
                title: Text('Current Location', style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w700)),
                trailing: Switch(
                  autofocus: true,
                  value: _currentLocationEnable,
                  activeColor: Colors.blue,
                  inactiveTrackColor: Colors.blueGrey,
                  trackOutlineColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.blue.shade500;
                    } else {
                      return Colors.black;
                    }
                  }),
                  thumbColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.blue;
                    } else {
                      return Colors.black;
                    }
                  }),
                  onChanged: (bool value) {
                    setState(() {
                      _currentLocationEnable = value;
                    });
                  },
                ),
              ),
            ),
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