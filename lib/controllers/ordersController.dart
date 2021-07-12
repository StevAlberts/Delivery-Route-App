import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:load_n_go/models/orderModel.dart';
import 'package:path_provider/path_provider.dart';

class OrdersController extends GetxController {
  List<OrderModel> allOrders = [];
  List<OrderModel> searchData = [];
  List<OrderModel> searchedOrders = [];
  List<OrderModel> selectedOrders = [];
  List<dynamic> csvHeaders = [];
  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    readCSVOrders();
  }

  // read CSV file from assets/lng_data.csv
  void readCSVOrders() async {
    loading.value = true;
    update();
    final lngData = await rootBundle.loadString("assets/lng_data.csv");
    List<List<dynamic>> _listData = const CsvToListConverter().convert(lngData);
    allOrders =
        _listData.skip(2).map((data) => OrderModel.fromCSV(data)).toList();
    searchData = allOrders;
    csvHeaders.add(_listData
        .take(2)
        .last
        .toString()
        .replaceAll('[', "")
        .replaceAll(']', ""));
    loading.value = false;
    update();
  }

  // search through all orders based on orderNo. merchantName. pickupDate. deliveryDate.
  void searchAllOrders(String value) {
    loading.value = true;
    bool condition1 = searchData
            .where((element) =>
                element.orderNo.toLowerCase().contains(value.toLowerCase()))
            .toList()
            .length >
        0;
    bool condition2 = searchData
            .where((element) => element.merchantName
                .toLowerCase()
                .contains(value.toLowerCase()))
            .toList()
            .length >
        0;
    bool condition3 = searchData
            .where((element) =>
                DateFormat.yMd().format(element.pickupDate).toLowerCase() ==
                value.toLowerCase())
            .toList()
            .length >
        0;
    bool condition4 = searchData
            .where((element) =>
                DateFormat.yMd().format(element.deliveryDate).toLowerCase() ==
                value.toLowerCase())
            .toList()
            .length >
        0;

    if (condition1) {
      searchedOrders = searchData
          .where((element) =>
              element.orderNo.toLowerCase().contains(value.toLowerCase()))
          .take(6)
          .toList();
      update();
    } else if (condition2) {
      searchedOrders = searchData
          .where((element) =>
              element.merchantName.toLowerCase().contains(value.toLowerCase()))
          .take(6)
          .toList();
      update();
    } else if (condition3) {
      searchedOrders = searchData
          .where((element) =>
              DateFormat.yMd().format(element.pickupDate).toLowerCase() ==
              value.toLowerCase())
          .take(6)
          .toList();
      update();
    } else if (condition4) {
      searchedOrders = searchData
          .where((element) =>
              DateFormat.yMd().format(element.deliveryDate).toLowerCase() ==
              value.toLowerCase())
          .take(6)
          .toList();
      update();
    } else {
      print("No result");
      clearSearch();
    }
    loading.value = false;
    update();
  }

  // clear search list
  void clearSearch() {
    searchedOrders.clear();
    searchedOrders = [];
    update();
  }

  // Sorting orders based on areaCode, pickupDate, deliveryDate, merchantName
  void sortOrders(String criteria) {
    switch (criteria) {
      case "areaCode":
        allOrders.sort((a, b) => a.deliveryPostalCode
            .toString()
            .substring(0, 2)
            .compareTo(b.deliveryPostalCode.toString().substring(0, 2)));
        break;
      case "pickupDate":
        allOrders.sort((a, b) => a.pickupDate.compareTo(b.pickupDate));
        break;
      case "deliveryDate":
        allOrders.sort((a, b) => a.deliveryDate.compareTo(b.deliveryDate));
        break;
      case "merchantName":
        allOrders.sort((a, b) => a.merchantName.compareTo(b.merchantName));
        break;
      default:
        readCSVOrders();
        break;
    }
    update();
  }

  // filtering orders based on areaCode, pickupDate, deliveryDate, merchantName
  void filterOrders(String condition) {
    switch (condition) {
      case "areaCode":
        allOrders = allOrders
            .where((element) =>
                element.pickupPostalCode.toString().substring(0, 2) == '02')
            .toList();
        break;
      case "pickupDate":
        allOrders = allOrders
            .where((element) =>
                element.pickupDate == DateFormat.yMd('en_US').parse('1/1/2021'))
            .toList();
        break;
      case "deliveryDate":
        allOrders = allOrders
            .where((element) =>
                element.deliveryDate ==
                DateFormat.yMd('en_US').parse('1/1/2021'))
            .toList();
        break;
      case "merchantName":
        allOrders = allOrders
            .where((element) => element.merchantName == 'Merchant 1')
            .toList();
        break;
      default:
        readCSVOrders();
        break;
    }
    update();
  }

  // select multiple rows of all orders and update the order to selectedOrders list
  void multiSelect(OrderModel _order) {
    selectedOrders.add(_order);
    update();
  }

  // remove order from selectedOrders list
  void unSelect(OrderModel _order) {
    selectedOrders.remove(_order);
    update();
  }

  // clear selected orders
  void clearSelectedOrders() {
    selectedOrders.clear();
    update();
  }

  // delete all selected
  void deletedAllSelectedRows() {
    loading.value = true;
    selectedOrders.forEach((_order) {
      allOrders.removeWhere((element) => element.orderNo == _order.orderNo);
    });
    selectedOrders.clear();
    loading.value = false;
    update();
  }

  // approved all selected
  void approveAllSelectedRows() {
    loading.value = true;
    selectedOrders.forEach((_order) {
      allOrders[allOrders
              .indexWhere((element) => element.orderNo == _order.orderNo)]
          .approvalStatus = 'YES';
    });
    selectedOrders.clear();
    loading.value = false;
    update();
  }

  // update single order info
  Future<void> updateSingleOrder(OrderModel _order) async {
    loading.value = true;
    selectedOrders.forEach((_order) {
      allOrders[allOrders
          .indexWhere((element) => element.orderNo == _order.orderNo)] = _order;
    });
    selectedOrders.clear();
    loading.value = false;
    update();
  }

  // delete single order
  Future<void> deletedSingleOrder(OrderModel _order) async {
    loading.value = true;
    allOrders.removeWhere((element) => element.orderNo == _order.orderNo);
    loading.value = false;
    update();
  }

  // export selected orders to csv
  Future<void> exportToCSV() async {
    List<List<dynamic>?>? rows = [];
    print(selectedOrders.length);
    rows.add(csvHeaders);
    selectedOrders.forEach((element) {
      print([element.toCSVString()][0]);
      rows.add(element.toCSVString());
    });
    String csv = '${const ListToCsvConverter().convert(rows)}';
    print(csv);
    final directory = await getApplicationDocumentsDirectory();
    final pathOfTheFileToWrite = directory.path + "/myCsvFile.csv";
    File file = File(pathOfTheFileToWrite);
    print(file.path);
    file.writeAsString(
        csv.replaceAll('"', "").replaceAll('[', "").replaceAll(']', ""));
    selectedOrders.clear();
    update();
    Get.showSnackbar(GetBar(
      title: "Exported to",
      message: "${file.path}",
      mainButton: TextButton(onPressed: () => Get.back(), child: Text("OK")),
      duration: Duration(seconds: 3),
    ));
  }
}
