import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class Store {
  final String code;
  final String name;
  final double latitude;
  final double longitude;
  final String address;
  final double distance;

  Store({
    required this.code,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.distance,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      code: json['code'] ?? 'N/A',
      name: json['storeLocation'] ?? 'Unknown',
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
      address: json['storeAddress'] ?? 'No Address',
      distance: double.tryParse(json['distance'].toString()) ?? 0.0,
    );
  }
}

class StoreProvider extends ChangeNotifier {
  List<Store> _stores = [];
  Set<Marker> _markers = {};
  GoogleMapController? _mapController;
  String? _selectedStoreCode;

  List<Store> get stores => _stores;
  Set<Marker> get markers => _markers;
  String? get selectedStoreCode => _selectedStoreCode;

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> fetchStores() async {
    try {
      final response = await http.get(Uri.parse('https://atomicbrain.neosao.online/nearest-store'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['msg'] == 'success' && responseData['data'] is List) {
          final List<dynamic> storeList = responseData['data'];
          _stores = storeList.map((json) => Store.fromJson(json)).toList();
          updateMarkers();
        }
      }
    } catch (e) {
      debugPrint('Error fetching stores: $e');
    }
  }

  void updateMarkers() {
    _markers = _stores.map((store) => Marker(
          markerId: MarkerId(store.code),
          position: LatLng(store.latitude, store.longitude),
          infoWindow: InfoWindow(title: store.name, snippet: store.address),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            store.code == _selectedStoreCode ? BitmapDescriptor.hueOrange : BitmapDescriptor.hueRed,
          ),
        )).toSet();
    notifyListeners();
  }

  void moveToStore(Store store) {
    _selectedStoreCode = store.code;
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(LatLng(store.latitude, store.longitude)),
    );
    updateMarkers();
  }
}