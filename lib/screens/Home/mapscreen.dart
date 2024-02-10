import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

@override
Widget build(BuildContext context) {
  return FlutterMap(
    options: MapOptions(
      initialCenter: LatLng(51.509364, -0.128928),
      initialZoom: 9.2,
    ),
    children: [
      TileLayer(
           urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}@2x?access_token={accessToken}',
          additionalOptions: {
            'accessToken': '<YOUR_MAPBOX_ACCESS_TOKEN>',
            'id': 'mapbox/streets-v11', // Mapbox style ID (you can use other styles)
          },
      ),

    ],
  );
}