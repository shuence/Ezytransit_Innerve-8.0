import 'package:flutter/material.dart';

class BusStopAutoComplete extends StatefulWidget {
  final TextEditingController controller;
  final List<String> busStops;

  const BusStopAutoComplete({
    Key? key,
    required this.controller,
    required this.busStops,
  }) : super(key: key);

  @override
  _BusStopAutoCompleteState createState() => _BusStopAutoCompleteState();
}

class _BusStopAutoCompleteState extends State<BusStopAutoComplete> {
  late List<String> filteredBusStops;

  @override
  void initState() {
    super.initState();
    filteredBusStops = widget.busStops;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: (value) {
        setState(() {
          filteredBusStops = widget.busStops
              .where((stop) =>
                  stop.toLowerCase().contains(value.toLowerCase()))
              .toList();
        });
      },
      decoration: InputDecoration(
        hintText: 'Enter bus stop',
        suffixIcon: Icon(Icons.search),
      ),
      onTap: () {
        _showSearchResults(context);
      },
    );
  }

  void _showSearchResults(BuildContext context) {
    showSearch(
      context: context,
      delegate: _BusStopSearchDelegate(filteredBusStops),
    );
  }
}

class _BusStopSearchDelegate extends SearchDelegate<String> {
  final List<String> busStops;

  _BusStopSearchDelegate(this.busStops);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: busStops.length,
      itemBuilder: (context, index) {
        final stop = busStops[index];
        return ListTile(
          title: Text(stop),
          onTap: () {
            close(context, stop);
          },
        );
      },
    );
  }
}
