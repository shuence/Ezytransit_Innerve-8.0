import 'package:ezytransit_innerve/screens/Home/search_results.dart';
import 'package:ezytransit_innerve/widgets/custom_widget.dart';
import 'package:ezytransit_innerve/widgets/drawer_widget.dart'; // Import the drawer widget
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // GlobalKey for the Scaffold

  final TextEditingController sourceController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  List<String> busStops = [];
  List<String> filteredSourceBusStops = [];
  List<String> filteredDestinationBusStops = [];

  void retrieveBusStopNames() async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection('buses').get();
    var stops = <String>[];
    for (var document in querySnapshot.docs) {
      var route = document['route'];
      if (route != null) {
        var routeStops = route['stops'];
        if (routeStops != null) {
          routeStops.forEach((stop) {
            var stopName = stop['name'];
            if (stopName != null) {
              stops.add(stopName);
            }
          });
        }
      }
    }
    setState(() {
      busStops = stops;
    });
  }

  @override
  void initState() {
    super.initState();
    retrieveBusStopNames();
  }

  void updateFilteredBusStops(
      String pattern, TextEditingController controller) {
    setState(() {
      if (controller == sourceController) {
        filteredSourceBusStops = busStops
            .where((stop) => stop
                .replaceAll(' ', '')
                .toLowerCase()
                .contains(pattern.replaceAll(' ', '').toLowerCase()))
            .toList();
        filteredDestinationBusStops.clear();
      } else if (controller == destinationController) {
        filteredDestinationBusStops = busStops
            .where((stop) => stop
                .replaceAll(' ', '')
                .toLowerCase()
                .contains(pattern.replaceAll(' ', '').toLowerCase()))
            .toList();
        filteredSourceBusStops.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the GlobalKey to the Scaffold
      appBar: AppBar(
        elevation: 4,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Open the drawer when the menu icon is clicked
            _scaffoldKey.currentState?.openDrawer();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
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
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green),
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 18),
            const Text(
              'Search Buses',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0x9903A932),
                fontSize: 20,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w900,
                letterSpacing: 1.20,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              height: 1,
              width: 100,
              color: Colors.black,
            ),
            const Text(
              'Enter your destination where you want to go.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 284,
              height: 46,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: const Color(0x6604AA32)),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.location_on_outlined),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: sourceController,
                      onChanged: (value) {
                        updateFilteredBusStops(value, sourceController);
                      },
                      decoration: const InputDecoration(
                        hintText: 'From (Source Place)',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (sourceController.text.isNotEmpty)
              Container(
                width: 284,
                height: filteredSourceBusStops.isNotEmpty ? 100 : 0,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  itemCount: filteredSourceBusStops.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            sourceController.text =
                                filteredSourceBusStops[index];
                            filteredSourceBusStops.clear();
                          });
                        },
                        child: ListTile(
                          title: Text(
                            filteredSourceBusStops[index],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.10,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            Center(
                child: IconButton(
              icon: const Icon(Icons.swap_vert),
              onPressed: () {
                var temp = sourceController.text;
                sourceController.text = destinationController.text;
                destinationController.text = temp;
              },
            )),
            Container(
              width: 284,
              height: 46,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: const Color(0x6604AA32)),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.location_on_outlined),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: destinationController,
                      onChanged: (value) {
                        updateFilteredBusStops(value, destinationController);
                      },
                      decoration: const InputDecoration(
                        hintText: 'To (Destination Place)',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (destinationController.text.isNotEmpty)
              Container(
                width: 284,
                height: filteredDestinationBusStops.isNotEmpty ? 100 : 0,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  itemCount: filteredDestinationBusStops.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            destinationController.text =
                                filteredDestinationBusStops[index];
                            filteredDestinationBusStops.clear();
                          });
                        },
                        child: ListTile(
                          title: Text(filteredDestinationBusStops[index]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            Container(
              width: 96,
              height: 33,
              margin: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF08BD62),
                borderRadius: BorderRadius.circular(50),
              ),
              child: TextButton(
                onPressed: () {
                  if (sourceController.text.isEmpty ||
                      destinationController.text.isEmpty) {
                    CustomSnackbar.showError(
                        context, "Please enter both source and destination");
                  } else if (!busStops.contains(sourceController.text) ||
                      !busStops.contains(destinationController.text)) {
                    CustomSnackbar.showError(context,
                        "Source or destination not found in bus stops");
                  } else if (sourceController.text ==
                      destinationController.text) {
                    CustomSnackbar.showError(
                        context, "Source and destination cannot be the same");
                  } else {
                    CustomSnackbar.showSuccess(
                        context, "message: Searching...");
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SearchResultScreen(
                        source: sourceController.text,
                        destination: destinationController.text,
                      ),
                    ));
                  }
                },
                child: const Text(
                  'Search',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'USEFUL FEATURE',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0x9903A932),
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w900,
                letterSpacing: 1.20,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate to search nearby bus stops screen
                    },
                    child: _buildIconWithText(
                        Icons.search_rounded, "Search Near By Bus Stops"),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to track live location of bus screen
                    },
                    child: _buildIconWithText(Icons.location_searching_sharp,
                        'Track Live Location of Bus'),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to bus pass reservation screen
                    },
                    child: _buildIconWithText(
                        Icons.text_fields, 'Bus Pass Reservation'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate to special for tourists screen
                    },
                    child: _buildSpecialFeatureImageWithText(),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to help & support screen
                    },
                    child: _buildIconWithText(
                        Icons.help_center, 'Help & Support 24/7'),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to feedback screen
                    },
                    child: _buildIconWithText(Icons.feedback, 'Feedback'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 36,
              decoration: const BoxDecoration(color: Color(0xFF08BD62)),
              child: const Center(
                child: Text(
                  'MADE BY INNOVISION SQUAD - DIEMS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.60,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconWithText(IconData icon, String text) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: Color(0xD808BD62),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x2D000000),
                blurRadius: 6,
                offset: Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 32,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 84,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialFeatureImageWithText() {
    return Column(
      children: [
        Container(
          width: 96,
          height: 16,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: const BoxDecoration(
            color: Color(0xFFFEB73F),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          child: const Text(
            'Special for Tourists',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 8,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x2D000000),
                    blurRadius: 6,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/bus.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const SizedBox(
          width: 84,
          child: Text(
            'Pune Darshan Bus',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFFEB73F),
              fontSize: 10,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
