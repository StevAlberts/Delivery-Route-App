import 'package:intl/intl.dart';

class OrderModel {
  String orderNo;
  String orderDesc;
  String orderWeight;
  int qty;
  DateTime pickupDate;
  String pickupAddress1;
  String? pickupAddress2;
  int pickupPostalCode;
  DateTime deliveryDate;
  String deliveryAddress1;
  String? deliveryAddress2;
  int deliveryPostalCode;
  String custFirstName;
  String custLastName;
  String custEmail;
  int custPhoneNo;
  String? custCompany;
  String merchantName;
  String? approvalStatus;

  OrderModel({
    required this.orderNo,
    required this.orderDesc,
    required this.orderWeight,
    required this.qty,
    required this.pickupDate,
    required this.pickupAddress1,
    this.pickupAddress2,
    required this.pickupPostalCode,
    required this.deliveryDate,
    required this.deliveryAddress1,
    this.deliveryAddress2,
    required this.deliveryPostalCode,
    required this.custFirstName,
    required this.custLastName,
    required this.custEmail,
    required this.custPhoneNo,
    this.custCompany,
    required this.merchantName,
    this.approvalStatus,
  });

  factory OrderModel.fromCSV(List<dynamic> data) {
    return OrderModel(
      orderNo: data[0],
      orderDesc: data[1],
      orderWeight: data[2],
      qty: data[3],
      pickupDate: DateFormat.yMd('en_US').parse(data[4]),
      pickupAddress1: data[5],
      pickupAddress2: data[6],
      pickupPostalCode: data[7],
      deliveryDate: DateFormat.yMd('en_US').parse(data[8]),
      deliveryAddress1: data[9],
      deliveryAddress2: data[10],
      deliveryPostalCode: data[11],
      custFirstName: data[12],
      custLastName: data[13],
      custEmail: data[14],
      custPhoneNo: data[15],
      custCompany: data[16],
      merchantName: data[17],
      approvalStatus: data[18],
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderNo: json['orderNo'],
      orderDesc: json['orderDesc'],
      orderWeight: json['orderWeight'],
      qty: json['qty'],
      pickupDate: DateTime.parse(json['pickupDate']),
      pickupAddress1: json['pickupAddress1'],
      pickupAddress2: json['pickupAddress2'] ?? "",
      pickupPostalCode: json['pickupPostalCode'],
      deliveryDate: DateTime.parse(json['deliveryDate']),
      deliveryAddress1: json['deliveryAddress1'],
      deliveryAddress2: json['deliveryAddress2'] ?? "",
      deliveryPostalCode: json['deliveryPostalCode'],
      custFirstName: json['custFirstName'],
      custLastName: json['custLastName'],
      custEmail: json['custEmail'],
      custPhoneNo: json['custPhoneNo'],
      custCompany: json['custCompany'],
      merchantName: json['merchantName'],
      approvalStatus: json['approvalStatus'] ?? "",
    );
  }
}
