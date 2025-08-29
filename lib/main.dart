import 'package:flutter/material.dart';
import 'package:lists/vehicle.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learning Lists',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Learning Lists on Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController licensePlateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController kmController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  List<Vehicle> vehicles = [];
  Vehicle? editing = null;

  void showVehicle(Vehicle nv) {
    licensePlateController.text = nv.licensePlate;
    descriptionController.text = nv.description;
    yearController.text = "${nv.year}";
    kmController.text = "${nv.km}";
    priceController.text = "${nv.price}";
  }

  void _showMessage(String msg, int time) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg),
            duration: Duration(seconds: time))
    );
  }

  void removeVehicle(Vehicle v) {
    if (editing != null) {
      _showMessage("Confirm or cancel actual editing", 4);
      return;
    }
    int position = vehicles.indexOf(v);
    if(position < 0){
      print("Vehicle not found!");
      return;
    }
    setState(() {
      vehicles.removeAt(position);
      vehicles = List<Vehicle>.from(vehicles);
    });
  }

  Widget generateView(Vehicle v) {
    return Row(
      children: [
        Flexible( child: Column(
          children: [
            Row(children: [Text(v.licensePlate), Spacer(flex:1), Text(v.description)],),
            Row(children: [Text("Year: ${v.year}"), Spacer(flex:1), Text("KM: ${v.km}"),
                Spacer(flex:1), Text("R\$ ${v.price}")],),
          ])),
          IconButton(onPressed: (){ editVehicle(v);}, icon: Icon(Icons.edit)),
          IconButton(onPressed: (){ removeVehicle(v);}, icon: Icon(Icons.delete_forever))
      ]
    );
  }

  Widget createVehicle(int idx) {
    Vehicle v = vehicles[idx];
    ListTile item = ListTile(title: generateView(v),
      onTap: () { showVehicle(v); },
      //onLongPress: () { removeItem(v); },
    );
    return item;
  }

  void editVehicle(Vehicle v) {
    if(editing != null) { return; }
    editing = v;
    showVehicle(editing!);
  }

  void _confirm() {
    if(editing == null) {
      _addItem();
    }else {
      _confirmEdit();
    }
  }

  void _confirmEdit() {
    try {
      editing?.licensePlate = licensePlateController.text;
      editing?.description = descriptionController.text;
      editing?.year = int.tryParse( yearController.text )!;
      editing?.price = double.tryParse( priceController.text )!;
      editing?.km = int.tryParse( kmController.text )!;
      editing = null;
      setState(() {
        vehicles = List.from(vehicles);
      });
      clearFields();
    } catch ( error ) {
      _showMessage("Fields should be filled correctly", 3);
    }
  }

  void _cancel() {
    editing = null;
    clearFields();
  }

  void _addItem() {
    try {
      Vehicle newVehicle = Vehicle(licensePlateController.text, descriptionController.text,
          int.tryParse(yearController.text)!, int.tryParse(kmController.text)!,
          double.tryParse(priceController.text)! );
      setState(() {
        vehicles = List<Vehicle>.from(vehicles);
        vehicles.add(newVehicle);
        clearFields();
      });
    } catch ( error ) {
      _showMessage("Fields should be filled correctly", 3);
    }
  }

  void clearFields() {
    setState(() {
      licensePlateController.text = "";
      descriptionController.text = "";
      yearController.text = "";
      kmController.text = "";
      priceController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField( controller: licensePlateController, decoration: const InputDecoration(
              hintText: "License Plate", label: Text("License Plate")
            )),
            TextField( controller: descriptionController, decoration: const InputDecoration(
                hintText: "Description", label: Text("Description")
            )),
            TextField( controller: yearController, decoration: const InputDecoration(
                hintText: "Fabrication Year", label: Text("Year")
            )),
            TextField( controller: kmController, decoration: const InputDecoration(
                hintText: "KM", label: Text("KM")
            )),
            TextField( controller: priceController, decoration: const InputDecoration(
                hintText: "Price", label: Text("Price")
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _confirm,
                    child: Row(children: [Icon(Icons.check), Text("Confirm")],)),
                SizedBox(width: 8,),
                ElevatedButton(onPressed: _cancel,
                    child: Row(children: [Icon(Icons.cancel_outlined), Text("Cancel")],))
              ]
            ),
            Expanded( child: ListView.builder(
                itemCount: vehicles.length,
                itemBuilder: (BuildContext ctx, int idx) {return createVehicle( idx ); },
            ))
          ]
        )
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
