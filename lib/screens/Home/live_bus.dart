import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveBusTracking extends StatefulWidget {
  final String busId;
  final String source;
  final String destination;

  const LiveBusTracking({
    Key? key,
    required this.busId,
    required this.source,
    required this.destination,
  }) : super(key: key);

  @override
  _LiveBusTrackingState createState() => _LiveBusTrackingState();
}

class _LiveBusTrackingState extends State<LiveBusTracking> {
  late LatLng _busLocation;
  late LatLng _sourceLocation;
  late LatLng _destinationLocation;
  late List<LatLng> _routeCoordinates = [];
  late GoogleMapController _googleMapController;

  @override
  void initState() {
    super.initState();
    _busLocation = LatLng(18.5034, 73.8595); // Default location
    _sourceLocation = LatLng(0, 0); // Default location
    _destinationLocation = LatLng(0, 0); // Default location
    _getSourceAndDestinationLocations();
    _getBusLocation();
  }

  void _getSourceAndDestinationLocations() {
    FirebaseFirestore.instance
        .collection('buses')
        .doc(widget.busId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map<String, dynamic>;
        var route = data['route'] as Map<String, dynamic>;
        var stops = route['stops'] as List<dynamic>;
        if (stops.isNotEmpty) {
          var firstStop = stops.first;
          var lastStop = stops.last;
          // Check if the stop location is a specific latitude and longitude
          if (firstStop['location'] is List<dynamic> &&
              firstStop['location'].length == 2 &&
              lastStop['location'] is List<dynamic> &&
              lastStop['location'].length == 2) {
            _sourceLocation =
                LatLng(firstStop['location'][0], firstStop['location'][1]);
            _destinationLocation =
                LatLng(lastStop['location'][0], lastStop['location'][1]);
          } else {
            _sourceLocation =
                _busLocation; // Example: Set source location to current bus location
            _destinationLocation =
                _busLocation; // Example: Set destination location to current bus location
          }
        }
      }
    }).catchError((error) {
      print("Failed to get source and destination locations: $error");
    });
  }

  void _getBusLocation() {
    FirebaseFirestore.instance
        .collection('buses')
        .doc(widget.busId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map<String, dynamic>;
        var location = data['currentLocation'] as GeoPoint?;
        if (location != null) {
          setState(() {
            _busLocation = LatLng(location.latitude, location.longitude);
          });
          // Zoom to the bus location when it's not (0,0)
          if (_busLocation.latitude != 0 && _busLocation.longitude != 0) {
            _zoomToBusLocation();
          }
        }
      }
    }).catchError((error) {
      print("Failed to get bus location: $error");
    });
  }

  void _zoomToBusLocation() {
    _googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(_busLocation, 15.0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Bus Tracking - Bus ID: ${widget.busId}'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _busLocation,
          zoom: 15.0,
        ),
        onMapCreated: (controller) {
          _googleMapController = controller;
        },
        markers: {
          Marker(
            markerId: const MarkerId('busMarker'),
            position: _busLocation,
            infoWindow: InfoWindow(
              title: 'Bus ${widget.busId}, ${widget.source} to ${widget.destination}, Occupancy: ${_getBusOccupancy()}',
              snippet: 'Current Speed: ${_getBusCurrentSpeed()}',

            ),
          ),
        },
        polylines: {
          Polyline(
            polylineId: const PolylineId('route'),
            color: Colors.blue,
            width: 3,
            points: _routeCoordinates,
          ),
        },
      ),
    );
  }

  String _getBusCurrentSpeed() {
    return '50 km/h'; // Example value, replace with actual data
  }
  String _getBusOccupancy() {
    return '30%'; // Example value, replace with actual data
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }
}
