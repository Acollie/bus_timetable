import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<Marker> markers = [];
  void fetch_stop_info(){
    http.get(Uri.parse('https://sojbuslivetimespublic.azurewebsites.net/api/Values/GetMin?secondsAgo=3600&lat=49.221284&lon=-2.128627&stopsWithinXMetres=10000&limitTo=10000')).then((value) => {
      setState(() {

        var item = jsonDecode(value.body);
        for (var bus_loc in item['stops']) {
          markers.add(Marker(
              width: 80,
              height: 80,
              point: LatLng(bus_loc['Latitude'], bus_loc['Longitude']),
              builder: (ctx) => Icon(Icons.map,color: Colors.blue[900],
              )
          ));

        }
        print('updating state');
      })

    });
    Future.delayed(Duration(milliseconds: 15000), () {
      // fetch_data();
    });
  }
  void fetch_bus_data(){

    http.get(Uri.parse('https://sojbuslivetimespublic.azurewebsites.net/api/Values/GetMin?secondsAgo=3600')).then((value) => {
      setState(() {
        // markers.add()
        markers.clear();
        var item = jsonDecode(value.body);
        for (var bus_loc in item['minimumInfoUpdates']) {
          if(bus_loc['direction'] == 'outbound'){
            markers.add(Marker(
                width: 80,
                height: 80,
                point: LatLng(bus_loc['lat'], bus_loc['lon']),
                builder: (ctx) => Icon(Icons.directions_bus_sharp,color: Colors.blue[900],
                )
            ));
          }else{
            markers.add(Marker(
              width: 80,
              height: 80,
              point: LatLng(bus_loc['lat'], bus_loc['lon']),
              builder: (ctx) => Icon(Icons.directions_bus_sharp,color: Colors.red[900],
              ),
            ));
          }

        }
        print('updating state');
      })

    });
    Future.delayed(Duration(milliseconds: 15000), () {
      fetch_bus_data();
    });
  }

  void initState() {
    fetch_bus_data();
    fetch_stop_info();
  }
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(49.221284, -2.128627),
        zoom: 11,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayerOptions(
          markers: markers,
        ),
      ],
      nonRotatedChildren: [
        AttributionWidget.defaultWidget(
          source: 'OpenStreetMap contributors',
          onSourceTapped: null,
        ),
      ],
    );
  }
}