import 'dart:convert';
import 'dart:io';

import 'package:CovidHotspots/mlResponse.dart';
import 'package:flutter/material.dart';
import 'dart:js' as js;

import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'COVID-19 Hotspot Predictor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'COVID-19 Hotspot Predictor'),
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
  double income,
      popDense,
      age,
      airports,
      masksMandatory,
      masksRec,
      popDenseState,
      pop20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
                Container(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Container(
                        child: Center(
                            child: SizedBox(
                      width: (MediaQuery.of(context).size.width * 4 / 9),
                      height: (MediaQuery.of(context).size.height * 15 / 18),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Please enter the human factors,\nto see whether your city\n will be a COVID-19 hotspot',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 15),),
                            textInput(
                                onChangedIncome, "Average yearly personal income (USD)"),
                            textInput(onChangedAirports, "# of airports within 50km"),
                            textInput(onChangedPop20, "Population of city"),
                            textInput(onChangedPopDense,
                                "Population density of city (people per km^2)"),
                            textInput(onChangedPopDenseState,
                                "Population density of state (people per km^2)"),
                            textInput(onChangedAge, "Median age (years) "),
                            textInput(onChangedMaskMandatory,
                                "# of days that masks were mandatory"),
                            textInput(onChangedMaskRec,
                                "# of days masks were recommended"),
                          ],
                        ),
                      ),
                    ))),
                  ),
                )
              ],
            ))),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color.fromARGB(255, 252, 61, 33),
          onPressed: fabMl,
          label: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(30),
              child: Text(
            "Calculate Using Machine Learning",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          )),
        ));
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

  void onChangedPopDenseState(String val) {
    setState(() {
      this.popDenseState = double.tryParse(val);
    });
  }

  void onChangedPop20(String val) {
    setState(() {
      this.pop20 = double.tryParse(val);
    });
  }

  void fabMl()  {
    var res = fetchData();
      Dialog present = Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width / 4,
            child: FutureBuilder<MLResponse>(
              future: res,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return
                      Center(
                        child: Text(
                          (snapshot.data.hotspot == 1.0)? "Your town will be a hotspot": "Your town will NOT be a hotspot",
                          //snapshot.data.hotspot.toString(),
                          textAlign: TextAlign.center,
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                  );
                } else if (snapshot.hasError) {

                  return Center(
                    child: Text(
                      "Unfortunately we were unable\nto connect to the server.\nPlease Try Again Later \n",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  );
                }
                // By default, show a loading spinner.
                return Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 6,
                      width: MediaQuery.of(context).size.height / 6,
                      child: CircularProgressIndicator(),
                    )
                );
              },
            )),
      );
      showDialog(context: context, builder: (BuildContext context) => present);



  }

  Future<MLResponse> fetchData() async {
//    js.context.callMethod("alert", <String>["Your debug message"]);
    final res = await http.get("http://127.0.0.1:8094/predict?values=" +
        masksRec.toString() + "," +
        masksMandatory.toString() + "," +
        income.toString() + "," +
        airports.toString() + "," +
        popDense.toString() + "," +
        popDenseState.toString() + "," +
        age.toString() + "," +
        pop20.toString()
    );

    if(res.statusCode == 200) {
      return MLResponse.fromJson(json.decode(res.body));
    } else {
      throw Exception("failed to learn json");
    }

  }
}
