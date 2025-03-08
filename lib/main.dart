import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:store_screen/store.dart';
import 'package:store_screen/store_screen.dart';




void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => StoreProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StoreScreen(),
      ),
    ),
  );
}

