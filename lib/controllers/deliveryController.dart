import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:load_n_go/models/deliveryModel.dart';

import 'ordersController.dart';

class DeliveryController extends GetxController {
  OrdersController _ordersController =
      Get.put(OrdersController(), permanent: true);
  // dio http package
  Dio _dio = Dio();
  RxBool loading = false.obs;

  Rx<List<Map<String, dynamic>>> _deliveriesMap =
      Rx<List<Map<String, dynamic>>>([]);

  Rx<List<DeliveryModel>> routedDeliveries = Rx<List<DeliveryModel>>([]);

  List<Map<String, dynamic>> _vehicles = [
    {
      "id": 1,
      "profile": "driving-car",
      "start": [2.35044, 48.71764],
      "end": [2.35044, 48.71764],
    },
  ];

  // routedData
  List routes = [];

  @override
  void onInit() {
    super.onInit();
    _convertToCords();
  }

  // fetchRoutes
  void fetchRoutes()
      // => _convertToCords()
      //     .then((_)
      =>
      _optimizeRoutes(_deliveriesMap.value, _vehicles);

  // fetch data using optimization (OpenRoute Service API)
  Future<void> _optimizeRoutes(List<Map<String, dynamic>> jobs,
      List<Map<String, dynamic>> vehicles) async {
    loading.value = true;
    var header = {
      'Accept':
          'application/json,application/geo+json,application/gpx+xml,img/png;charset=utf-8',
      'Authorization':
          '5b3ce3597851110001cf6248ab578be051cc4340b08f463ccead05af',
      'Content-Type': 'application/json;charset=utf-8',
    };
    var body = json.encode({
      "jobs": jobs.toList(),
      "vehicles": [
        {
          "id": 1,
          "profile": "driving-car",
          "start": [103.8491255, 1.3236056],
          "end": [103.8491255, 1.3236056],
          "capacity": [4],
          "skills": [1, 14],
          "time_window": [28800, 43200]
        }
      ],
    });
    try {
      var url = Uri.parse('https://api.openrouteservice.org/optimization');
      var response = await http.post(url, headers: header, body: body);
      print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(data['routes']);
        List routes = data['routes'];
        print("Routes: ${routes.length}");
        routes.forEach((element) {
          List steps = element['steps'];
          print("Steps: ${steps.length}");
          steps.forEach((_steps) {
            if (_steps['type'] == 'job') {
              print("----------------------------------");
              print(_steps);
              print("----------------------------------");
              _deliveriesMap.value.forEach((_delivery) {
                if (_delivery['id'] == _steps['id']) {
                  print("hit");
                  routedDeliveries.value.add(DeliveryModel.fromJson(_delivery));
                }
                print(routedDeliveries.value.length);
              });
            }
          });
        });
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load routes');
      }
      // print(response);
    } catch (e) {
      print("Error:$e");
    }
    loading.value = false;
    update();
  }

  // convert Postalcodes to Cordinates
  // Future<List<Map<String, dynamic>>>
  _convertToCords() async {
    // iterate through all orders deliveryPostalCode
    int index = 0;
    _ordersController.allOrders.forEach((element) async {
      try {
        List<Location> locations =
            await locationFromAddress(element.deliveryPostalCode.toString());
        DeliveryModel _delivery = DeliveryModel(
          id: index++,
          orderNo: element.orderNo,
          orderDesc: element.orderDesc,
          orderWeight: element.orderDesc,
          qty: element.qty,
          pickupDate: element.pickupDate.toString(),
          pickupAddress1: element.pickupAddress1,
          pickupPostalCode: element.pickupPostalCode,
          deliveryDate: element.deliveryDate.toString(),
          deliveryAddress1: element.pickupAddress1,
          deliveryPostalCode: element.pickupPostalCode,
          custFirstName: element.custFirstName,
          custLastName: element.custLastName,
          custEmail: element.custEmail,
          custPhoneNo: element.custPhoneNo,
          merchantName: element.merchantName,
          location: [
            locations.first.longitude,
            locations.first.latitude
          ], // [long,lat]
        );
        _deliveriesMap.value.add(_delivery.toJSON());
      } catch (e) {
        print("Error: $e");
      }
    });
  }
}
