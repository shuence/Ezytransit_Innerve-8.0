import 'package:ezytransit_innerve/screens/Home/live_bus.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezytransit_innerve/widgets/drawer_widget.dart';

class Bus {
  final String busId;
  final String name;
  final List<Map<String, dynamic>> route;
  final int occupancy;

  Bus({
    required this.busId,
    required this.name,
    required this.route,
    required this.occupancy,
  });
}

class SearchResultScreen extends StatelessWidget {
  final String source;
  final String destination;

  const SearchResultScreen({
    Key? key,
    required this.source,
    required this.destination,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        centerTitle: true,
        title: Image.asset(
          'assets/images/ezytranzit.png',
          width: 150,
          height: 200,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 22),
            const Text(
              'SEARCH RESULTS\nFOR',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0x9903A932),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w900,
                letterSpacing: 1.20,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 309,
              height: 49,
              decoration: BoxDecoration(
                border: Border.all(width: 1.25, color: const Color(0x3F08BD62)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        source,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                    size: 24,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        destination,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            FutureBuilder<List<Bus>>(
              future: fetchBusData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  final List<Bus> buses = snapshot.data!;
                  return Column(
                    children: [
                      _buildSearchResults(context, buses),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Bus>> fetchBusData() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('buses').get();

    return snapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data();
      return Bus(
        busId: data['busId'],
        name: data['name'],
        route: List<Map<String, dynamic>>.from(data['route']['stops']),
        occupancy: data['occupancy'],
      );
    }).toList();
  }

  Widget _buildSearchResults(BuildContext context, List<Bus> buses) {
    final List<Bus> matchingBuses = buses.where((bus) {
      bool hasSource = false;
      bool hasDestination = false;

      bus.route.forEach((stop) {
        if (stop['name'] == source) {
          hasSource = true;
        }
        if (stop['name'] == destination) {
          hasDestination = true;
        }
      });

      return hasSource && hasDestination;
    }).toList();

    return Column(
      children:
          matchingBuses.map((bus) => _buildBusCard(context, bus)).toList(),
    );
  }

Widget _buildBusCard(BuildContext context, Bus bus) {
  return Container(
    width: 360, // Adjusted width
    padding: const EdgeInsets.all(20),
    margin:  const EdgeInsets.only(left: 20),
    decoration: BoxDecoration(
      border: Border.all(width: 1, color: const Color(0x3308BD62)),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bus.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BUS NO',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    bus.busId,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/crowd.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CROWD',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${bus.occupancy}%',
                    style: const TextStyle(
                      color: Color(0xFFE30606),
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        _buildSourceDestinationContainer(bus.route),
        const SizedBox(height: 20, width: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 140,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ROUTES',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    bus.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LiveBusTracking(
                    source: source,
                    destination: destination,
                    busId: bus.busId,
                  ),
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE30606),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'TRACK LIVE LOCATION',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    ),
  );
}

  Widget _buildSourceDestinationContainer(List<Map<String, dynamic>> route) {
    return Container(
      width: 360,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BUS SOURCE',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                source,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          const Icon(Icons.arrow_forward, size: 24, color: Colors.black),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DESTINATION',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                destination,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
