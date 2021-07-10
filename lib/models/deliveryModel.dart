class DeliveryModel {
  int id;
  List<int>? skills;
  String orderNo;
  String orderDesc;
  String orderWeight;
  int qty;
  String pickupDate;
  String pickupAddress1;
  String? pickupAddress2;
  int pickupPostalCode;
  String deliveryDate;
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
  List location;

  DeliveryModel({
    required this.id,
    this.skills,
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
    required this.location,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id'],
      skills: json[''],
      orderNo: json['orderNo'],
      orderDesc: json['orderDesc'],
      orderWeight: json['orderWeight'],
      qty: json['qty'],
      pickupDate: json['pickupDate'],
      pickupAddress1: json['pickupAddress1'],
      pickupAddress2: json['pickupAddress2'] ?? "",
      pickupPostalCode: json['pickupPostalCode'],
      deliveryDate: json['deliveryDate'],
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
      location: json['location'],
    );
  }

  toJSON() {
    return {
      "id": id,
      "skills": [1],
      "orderNo": orderNo,
      "orderDesc": orderDesc,
      "orderWeight": orderWeight,
      "qty": qty,
      "pickupDate": pickupDate,
      "pickupAddress1": pickupAddress1,
      "pickupAddress2": pickupAddress2,
      "pickupPostalCode": pickupPostalCode,
      "deliveryDate": deliveryDate,
      "deliveryAddress1": deliveryAddress1,
      "deliveryAddress2": deliveryAddress2,
      "deliveryPostalCode": deliveryPostalCode,
      "custFirstName": custFirstName,
      "custLastName": custLastName,
      "custEmail": custEmail,
      "custPhoneNo": custPhoneNo,
      "custCompany": custCompany,
      "merchantName": merchantName,
      "approvalStatus": approvalStatus,
      "location": location
    };
  }
}
