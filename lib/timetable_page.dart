import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

//Easy https://sojbuslivetimespublic.azurewebsites.net//api/Values/BusStop/3987
//Last part is the id of the stop

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key? key, required int stop_id}) : super(key: key);

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  List<TableRow> items = [];
  void fetch_bus_information(int bus_stop) {
    print('bust informatiopn');
    http.get(Uri.parse(
        'https://sojbuslivetimespublic.azurewebsites.net//api/Values/BusStop/'+bus_stop.toString()))
        .then((value) => {
      setState(() {
        XmlDocument document = XmlDocument.parse(value.body);
        var list_items = document.findAllElements("BusETA");

        items.add(TableRow(children:[
          Column(children:[Text('Desintation', style: TextStyle(fontSize: 20.0))]),
          Column(children:[Text('Arrival time', style: TextStyle(fontSize: 20.0))]),
          Column(children:[Text('Line', style: TextStyle(fontSize: 20.0))]),
        ]));
        for (var x in list_items) {
          print(x);
          print(x.children[0].text);
          items.add(TableRow(children:[
            Column(children:[Text(x.children[0].text)]),
            Column(children:[Text(x.children[1].text)]),
            Column(children:[Text(x.children[3].text)]),
          ]));

        }

      })
    });
  }
  void initState(){
    fetch_bus_information(3306);
  }
  @override
  Widget build(BuildContext context) {



    return Scaffold(      appBar: AppBar(title:Text("Bus Timeable")),body: Container(child: Table(children:items)),);
  }
}

