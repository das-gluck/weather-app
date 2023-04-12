import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../util/utils.dart' as util;
import 'package:http/http.dart' as http;

class climate extends StatefulWidget {
  @override
  State<climate> createState() => _climateState();
}

class _climateState extends State<climate> {

  String _cityEnterd = util.defaultCity;

  Future _goToNextScreen(BuildContext context)async
  {
    Map results = await Navigator.push(context, MaterialPageRoute(builder: (context)=> ChangeCity()));

    if( results != null && results.containsKey('enter'))
    {
      setState(() {
        _cityEnterd = results['enter'];
      });
       // _cityEnterd = results['enter'];
      // print(results['enter'].toString());
    }

  }





  void showStuff() async
  {
    Map correctData = await acurrateWeatherData( util.apiId , util.defaultCity );
      print("Temperature = ${correctData['main']['temp']}");
      print("Pressure = ${correctData['main']['pressure']}");
      print("Humidity = ${correctData['main']['humidity']}");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather"),
        centerTitle: true,
        backgroundColor: Colors.black45,
        actions: [
              IconButton(onPressed: (){ _goToNextScreen(context);} , icon: Icon(Icons.menu)),
        ],
      ),

      body: Stack(
        children: [

          Center(
              child: Image.asset('images/umbrella.png',
                width: 490.0,
                height: 1000.0,
                fit: BoxFit.fill,
              ),
            ),


          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: Text(
                "${_cityEnterd == null ? util.defaultCity : _cityEnterd}",
                style: cityStyle(),),
          ),

          // Container(
          //   alignment: Alignment.center,
          //   child: Image.asset('images/light_rain.png'),
          // ),

          updateTempWidget(util.apiId , _cityEnterd) ,

          // this container will have a weather data
          // Container(
          //   margin: EdgeInsets.fromLTRB(30.0, 480.0, 0.0, 0.0),
          //   child: updateTempWidget(util.apiId , _cityEnterd) ,
          // ),


        ],
      ),
      
      
    );
  }

  // this funtion will return the longitude and latitude of the city
  Future Weather(String appId, String city) async
  {
    String url = 'http://api.openweathermap.org/geo/1.0/direct?q=$city&appid=$appId&units=metric';
    http.Response response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
   }

   // this will return the data of the city
  Future acurrateWeatherData(String apiId , String city ) async
  {
    List data = await Weather(apiId, city);
    double longitude = data[0]['lon'] ;
    double latitude = data[0]['lat'] ;

    String url = 'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiId&units=metric';
    http.Response response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }


  Widget updateTempWidget(String apiId , String city)
  {
    return FutureBuilder (
        future: acurrateWeatherData( apiId , city == null ? util.defaultCity : city),
        builder: (context , snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return Container(
              margin: EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    title: Text(content['main']['temp'].toString() +" ℃",
                     style: TextStyle(
                       color: Colors.white,
                       fontSize: 49.9,
                       fontWeight: FontWeight.w500,
                       fontStyle: FontStyle.normal,
                     ),),

                    subtitle: ListTile(
                      title: Text(
                            "Humidity: ${content['main']['humidity'].toString()}\n"
                                "Pressure: ${content['main']['pressure'].toString()}\n"
                            "Min:  ${content['main']['temp_min'].toString()} ℃\n"
                            "Max:  ${content['main']['temp_max'].toString()} ℃\n",
                        style: extraStyle(),
                    ) ,

                   ),
                  )
                ],
              ),
            );
          }
          else
            {
              return Container();
            }
        }
    );
  }



}

class ChangeCity extends StatelessWidget {

  var _cityFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change city'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),

      body: Stack(
        children: [
            Center(
              child: Image.asset('images/white_snow.png', width: 490.0, height: 1200, fit: BoxFit.fill,)
            ),

           ListView(
             children: [
               ListTile(
                 title: TextField(
                   decoration: InputDecoration(hintText: 'Enter City'),
                   controller: _cityFieldController,
                   keyboardType: TextInputType.text,
                 ),
               ),

               ListTile(
                 title: ElevatedButton(
                     onPressed: (){
                       Navigator.pop(context ,{ 'enter': _cityFieldController.text});
                       },
                     child: Text("search")
                 ),
               ),


             ],
           ),
        ],
      )



    );
  }
}





TextStyle cityStyle()
{
  return TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w800);
}

TextStyle tempStyle()
{
  return TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 49.9, );
}

TextStyle extraStyle()
{
  return TextStyle(
    color: Colors.white70,
    fontSize: 17.0,
    fontStyle: FontStyle.italic
  );
}


