import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:store_screen/store.dart';

class StoreScreen extends StatefulWidget {
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StoreProvider>(context, listen: false).fetchStores();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stores"),
        backgroundColor: Colors.orange,
      ),
      body: Consumer<StoreProvider>(
        builder: (context, storeProvider, child) {
          return Column(
            children: [
              Expanded(
                flex: 1,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(16.688653, 74.272591),
                    zoom: 12,
                  ),
                  markers: storeProvider.markers,
                  onMapCreated: (controller) => storeProvider.setMapController(controller),
                ),
              ),
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: storeProvider.stores.length,
                  itemBuilder: (context, index) {
                    final store = storeProvider.stores[index];
                    bool isSelected = store.code == storeProvider.selectedStoreCode;
                    return ListTile(
                      tileColor: isSelected ? Colors.orange.withOpacity(0.3) : Colors.white,
                      title: Text(store.name),
                      subtitle: Text("${store.address}\nDistance: ${store.distance} km"),
                      onTap: () => storeProvider.moveToStore(store),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orange,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Stores"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
        ],
      ),
    );
  }
}