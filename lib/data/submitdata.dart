import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package

class SubmitDataScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Dummy bus data with route, stops, and time for each stop
  final List<Map<String, dynamic>> dummyBusData = [
    {
      "busId": "101",
      "name": "Pune Express",
      "route": {
        "name": "Route A",
        "stops": [
          {
            "stopId": "STOP001",
            "name": "Swargate, Pune",
            "location": {"latitude": 18.5034, "longitude": 73.8595},
            "time": "08:00 AM"
          },
          {
            "stopId": "STOP002",
            "name": "Shivaji Nagar, Pune",
            "location": {"latitude": 18.5314, "longitude": 73.8444},
            "time": "08:20 AM"
          },
          {
            "stopId": "STOP003",
            "name": "Kothrud, Pune",
            "location": {"latitude": 18.5089, "longitude": 73.8077},
            "time": "08:40 AM"
          },
          {
            "stopId": "STOP004",
            "name": "Hinjewadi, Pune",
            "location": {"latitude": 18.5917, "longitude": 73.7388},
            "time": "09:00 AM"
          }
        ]
      },
      "capacity": 60,
      "occupancy": 30,
      "current_location": {"latitude": 18.5034, "longitude": 73.8595},
      "current_speed": "50 km/h"
    },
    {
      "busId": "102",
      "name": "Smart City Shuttle",
      "route": {
        "name": "Route B",
        "stops": [
          {
            "stopId": "STOP005",
            "name": "Hadapsar, Pune",
            "location": {"latitude": 18.5025, "longitude": 73.9271},
            "time": "08:10 AM"
          },
          {
            "stopId": "STOP006",
            "name": "Magarpatta City, Pune",
            "location": {"latitude": 18.5221, "longitude": 73.9339},
            "time": "08:30 AM"
          },
          {
            "stopId": "STOP007",
            "name": "Kharadi, Pune",
            "location": {"latitude": 18.5542, "longitude": 73.9439},
            "time": "08:50 AM"
          },
          {
            "stopId": "STOP008",
            "name": "Viman Nagar, Pune",
            "location": {"latitude": 18.5663, "longitude": 73.9147},
            "time": "09:10 AM"
          }
        ]
      },
      "capacity": 40,
      "occupancy": 20,
      "current_location": {"latitude": 18.5025, "longitude": 73.9271},
      "current_speed": "45 km/h"
    },
    {
      "busId": "103",
      "name": "Metro Link",
      "route": {
        "name": "Route E",
        "stops": [
          {
            "stopId": "STOP017",
            "name": "Vishrantwadi, Pune",
            "location": {"latitude": 18.5787, "longitude": 73.8903},
            "time": "08:15 AM"
          },
          {
            "stopId": "STOP018",
            "name": "Dighi, Pune",
            "location": {"latitude": 18.5975, "longitude": 73.8824},
            "time": "08:30 AM"
          },
          {
            "stopId": "STOP019",
            "name": "Dapodi, Pune",
            "location": {"latitude": 18.5852, "longitude": 73.8275},
            "time": "08:45 AM"
          },
          {
            "stopId": "STOP020",
            "name": "Pimpri, Pune",
            "location": {"latitude": 18.6271, "longitude": 73.8131},
            "time": "09:00 AM"
          }
        ]
      },
      "capacity": 50,
      "occupancy": 25,
      "current_location": {"latitude": 18.5787, "longitude": 73.8903},
      "current_speed": "40 km/h"
    },
    {
      "busId": "104",
      "name": "City Transit",
      "route": {
        "name": "Route F",
        "stops": [
          {
            "stopId": "STOP021",
            "name": "Camp, Pune",
            "location": {"latitude": 18.5204, "longitude": 73.8558},
            "time": "08:10 AM"
          },
          {
            "stopId": "STOP022",
            "name": "Swargate, Pune",
            "location": {"latitude": 18.5034, "longitude": 73.8595},
            "time": "08:25 AM"
          },
          {
            "stopId": "STOP023",
            "name": "Kondhwa, Pune",
            "location": {"latitude": 18.4684, "longitude": 73.9014},
            "time": "08:40 AM"
          },
          {
            "stopId": "STOP024",
            "name": "Bibvewadi, Pune",
            "location": {"latitude": 18.4695, "longitude": 73.8662},
            "time": "08:55 AM"
          }
        ]
      },
      "capacity": 45,
      "occupancy": 20,
      "current_location": {"latitude": 18.5204, "longitude": 73.8558},
      "current_speed": "35 km/h"
    },
    {
      "busId": "105",
      "name": "Tech Connect",
      "route": {
        "name": "Route G",
        "stops": [
          {
            "stopId": "STOP025",
            "name": "Hinjewadi Phase 1, Pune",
            "location": {"latitude": 18.5853, "longitude": 73.7290},
            "time": "08:20 AM"
          },
          {
            "stopId": "STOP026",
            "name": "Hinjewadi Phase 2, Pune",
            "location": {"latitude": 18.5855, "longitude": 73.7185},
            "time": "08:35 AM"
          },
          {
            "stopId": "STOP027",
            "name": "Hinjewadi Phase 3, Pune",
            "location": {"latitude": 18.5978, "longitude": 73.7106},
            "time": "08:50 AM"
          },
          {
            "stopId": "STOP028",
            "name": "Maan, Pune",
            "location": {"latitude": 18.5965, "longitude": 73.7387},
            "time": "09:05 AM"
          }
        ]
      },
      "capacity": 55,
      "occupancy": 30,
      "current_location": {"latitude": 18.5853, "longitude": 73.7290},
      "current_speed": "45 km/h"
    },
    {
      "busId": "106",
      "name": "City Express",
      "route": {
        "name": "Route H",
        "stops": [
          {
            "stopId": "STOP029",
            "name": "Kalyani Nagar, Pune",
            "location": {"latitude": 18.5483, "longitude": 73.9023},
            "time": "08:25 AM"
          },
          {
            "stopId": "STOP030",
            "name": "Yerwada, Pune",
            "location": {"latitude": 18.5513, "longitude": 73.8789},
            "time": "08:40 AM"
          },
          {
            "stopId": "STOP031",
            "name": "Nagar Road, Pune",
            "location": {"latitude": 18.5629, "longitude": 73.9155},
            "time": "08:55 AM"
          },
          {
            "stopId": "STOP032",
            "name": "Kharadi, Pune",
            "location": {"latitude": 18.5542, "longitude": 73.9439},
            "time": "09:10 AM"
          }
        ]
      },
      "capacity": 40,
      "occupancy": 15,
      "current_location": {"latitude": 18.5483, "longitude": 73.9023},
      "current_speed": "38 km/h"
    },
    {
      "busId": "107",
      "name": "Metro City Link",
      "route": {
        "name": "Route I",
        "stops": [
          {
            "stopId": "STOP033",
            "name": "Wadgaon Sheri, Pune",
            "location": {"latitude": 18.5494, "longitude": 73.9325},
            "time": "08:30 AM"
          },
          {
            "stopId": "STOP034",
            "name": "Vadgaon Budruk, Pune",
            "location": {"latitude": 18.4735, "longitude": 73.8268},
            "time": "08:45 AM"
          },
          {
            "stopId": "STOP035",
            "name": "Dhayari, Pune",
            "location": {"latitude": 18.4463, "longitude": 73.8073},
            "time": "09:00 AM"
          },
          {
            "stopId": "STOP036",
            "name": "Ambegaon Budruk, Pune",
            "location": {"latitude": 18.4495, "longitude": 73.8374},
            "time": "09:15 AM"
          }
        ]
      },
      "capacity": 35,
      "occupancy": 10,
      "current_location": {"latitude": 18.5494, "longitude": 73.9325},
      "current_speed": "42 km/h"
    }
  ];

  void submitDataToFirestore() {
    // Loop through each bus data
    for (var busData in dummyBusData) {
      // Extract bus details
      String busId = busData['busId'];
      String name = busData['name'];
      Map<String, dynamic> route = busData['route'];
      int capacity = busData['capacity'];
      int occupancy = busData['occupancy'];
      Map<String, dynamic> currentLocation = busData['current_location'];
      String currentSpeed = busData['current_speed'];

      // Extract route details
      String routeName = route['name'];
      List<Map<String, dynamic>> stops =
          List<Map<String, dynamic>>.from(route['stops']);

      // Convert current location to GeoPoint
      GeoPoint currentGeoPoint =
          GeoPoint(currentLocation['latitude'], currentLocation['longitude']);

      // Prepare data to be added to Firestore
      Map<String, dynamic> busDoc = {
        'busId': busId,
        'name': name,
        'capacity': capacity,
        'occupancy': occupancy,
        'currentSpeed': currentSpeed,
        'route': {
          'name': routeName,
          'stops': stops.map((stop) {
            return {
              'stopId': stop['stopId'],
              'name': stop['name'],
              'time': stop['time'], // Include time for each stop
              'location': GeoPoint(
                  stop['location']['latitude'], stop['location']['longitude']),
            };
          }).toList(),
        },
        'currentLocation': currentGeoPoint,
      };

      // Add bus document to Firestore
      _firestore.collection('buses').doc(busId).set(busDoc).then((value) {
        print('Data for bus $busId submitted successfully');
      }).catchError((error) {
        print('Error submitting data for bus $busId: $error');
      });
    }
  }

  void retrieveBusStopsFromFirestore() {
    _firestore.collection('buses').get().then((querySnapshot) {
      for (var document in querySnapshot.docs) {
        print('Bus ID: ${document.id}');
        var busData = document.data()!;
        var route = busData['route'];
        if (route != null) {
          var stops = route['stops'];
          if (stops != null) {
            print('Stops:');
            for (var stop in stops) {
              print('- ${stop['stopId']} ${stop['name']} - ${stop['time']}');
            }
          }
        }
        print('---');
      }
    }).catchError((error) {
      print('Error retrieving bus stops: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Data to Firestore'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: submitDataToFirestore,
              child: const Text('Submit Data to Firestore'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: retrieveBusStopsFromFirestore,
              child: const Text('Retrieve Bus Stops'),
            ),
          ],
        ),
      ),
    );
  }
}
