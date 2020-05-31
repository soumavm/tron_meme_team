import 'dart:convert';
import 'dart:io';

import 'package:CovidHotspots/mlResponse.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Breh',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Bruh Moment Predictor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double income, popDense, age, airports, masksMandatory, masksRec;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
//          decoration: new BoxDecoration(
//            borderRadius: BorderRadius.circular(15),
//          ),
          color: Color.fromARGB(255, 11, 61, 145),
          child: Center(
              child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Center(
                  child: Image(
                    image: AssetImage("assets/nasa_logo_3.png"),
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Container(
                    child: Center(
                        child: SizedBox(
                  width: (MediaQuery.of(context).size.width * 4 / 9),
                  height: (MediaQuery.of(context).size.height * 5 / 9),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Welcome To The End,\nPredict Your Fate',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        textInput(onChangedIncome, "Average Personal Income"),
                        textInput(onChangedAirports, "Airports nearby"),
                        textInput(onChangedPopDense, "Population Density"),
                        textInput(onChangedAge, "Median Age"),
                        textInput(onChangedMaskMandatory,
                            "# of Days that Masks were Mandatory"),
                        textInput(onChangedMaskRec,
                            "# of Days Masks were required OR mandatory from today"),
                      ],
                    ),
                  ),
                ))),
              ),
            ],
          ))),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color.fromARGB(255, 252, 61, 33),
          onPressed: fabMl,
          label: Text(
            "Predict My Fate",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
    );
  }

  Widget textInput(Function onChanged, String label) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: TextFormField(
            onChanged: onChanged,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(fontWeight: FontWeight.bold),
            decoration: new InputDecoration(
                labelText: label,
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide())),
          ),
        ));
  }

  void onChangedPopDense(String val) {
    setState(() {
      this.popDense = double.tryParse(val);
    });
  }
  void onChangedAge(String val) {
    setState(() {
      this.age = double.tryParse(val);
    });
  }
  void onChangedIncome(String val) {
    setState(() {
      this.income = double.tryParse(val);
    });
  }
  void onChangedAirports(String val) {
    setState(() {
      this.airports = double.tryParse(val);
    });
  }
  void onChangedMaskMandatory(String val) {
    setState(() {
      this.masksMandatory = double.tryParse(val);
    });
  }
  void onChangedMaskRec(String val) {
    setState(() {
      this.masksRec = double.tryParse(val);
    });
  }

  void fabMl() {
      final res = fetchData();

          Dialog present = Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: MediaQuery.of(context).size.height/3,
              width: MediaQuery.of(context).size.width/4,
              child: FutureBuilder<MLResponse>(
                future: res,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Text(
                             "Percentage Value: " + snapshot.data.percentageCases.toString() + "\nMean Squared Error: " + snapshot.data.meanSqrErr.toString() + "\nStandard Deviation: " + snapshot.data.stanDev.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                          "Ruh Roh We did a bad,\nBlame the tron meme team",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30
                        ),
                      ),
                    );
                  }
                  // By default, show a loading spinner.
                  return CircularProgressIndicator();
                },
              )
            ),
          );
          showDialog(context: context, builder: (BuildContext context) => present);
      }


  Future<MLResponse> fetchData() async {
    http.Response res = await http.get("http://localhost:8000?" +
        "income=" + income.toString() +
        "&popdense=" + popDense.toString() +
        "&age=" + age.toString() +
        "&airport=" + airports.toString() +
        "&masksmandatory=" + masksMandatory.toString() +
        "&masksrec=" + masksRec.toString()
    );
    
    if(res.statusCode == 200) {
      return MLResponse.fromJson(jsonDecode(res.body));
    } else {
      return null;
    }

  }


}
