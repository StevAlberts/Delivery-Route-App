import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:load_n_go/controllers/ordersController.dart';
import 'package:load_n_go/main.dart';
import 'package:load_n_go/models/orderModel.dart';

class EditOrderView extends StatefulWidget {
  final OrderModel order;
  const EditOrderView({Key? key, required this.order}) : super(key: key);

  @override
  _EditOrderViewState createState() => _EditOrderViewState();
}

class _EditOrderViewState extends State<EditOrderView> {
  final _formKey = GlobalKey<FormState>();
  OrdersController _ordersController =
      Get.put(OrdersController(), permanent: true);

  Future<void> _selectPickupDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000, 1),
        lastDate: DateTime(2101));
    if (picked != null) setState(() => widget.order.pickupDate = picked);
  }

  Future<void> _selectDeliveryDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000, 1),
        lastDate: DateTime(2101));
    if (picked != null) setState(() => widget.order.deliveryDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit order",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                OrderModel _newOrder = OrderModel(
                  orderNo: widget.order.orderNo,
                  orderDesc: widget.order.orderDesc,
                  orderWeight: widget.order.orderWeight,
                  qty: widget.order.qty,
                  pickupDate: widget.order.pickupDate,
                  pickupAddress1: widget.order.pickupAddress1,
                  pickupPostalCode: widget.order.pickupPostalCode,
                  deliveryDate: widget.order.deliveryDate,
                  deliveryAddress1: widget.order.deliveryAddress1,
                  deliveryPostalCode: widget.order.deliveryPostalCode,
                  custFirstName: widget.order.custFirstName,
                  custLastName: widget.order.custLastName,
                  custEmail: widget.order.custEmail,
                  custPhoneNo: widget.order.custPhoneNo,
                  merchantName: widget.order.merchantName,
                  approvalStatus: widget.order.approvalStatus,
                  custCompany: widget.order.custCompany,
                  deliveryAddress2: widget.order.deliveryAddress2,
                  pickupAddress2: widget.order.pickupAddress2,
                );
                _ordersController.updateSingleOrder(_newOrder);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Order updated.")));
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: Text('SAVE'),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              TextFormField(
                initialValue: widget.order.merchantName,
                decoration: InputDecoration(labelText: 'Merchant Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid input';
                  }
                  return null;
                },
                onChanged: (value) {
                  widget.order.merchantName = value;
                  print(widget.order.merchantName);
                },
              ),
              TextFormField(
                initialValue: widget.order.approvalStatus,
                decoration: InputDecoration(labelText: 'Approval Status'),
                validator: (value) {
                  return null;
                },
                onChanged: (value) {
                  widget.order.approvalStatus = value;
                },
              ),
              TextFormField(
                initialValue: widget.order.orderNo,
                decoration: InputDecoration(labelText: 'Order Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid input';
                  }
                  return null;
                },
                onChanged: (value) {
                  widget.order.orderNo = value;
                },
              ),
              TextFormField(
                initialValue: widget.order.orderWeight,
                decoration: InputDecoration(labelText: 'Weight(g/Kg)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid input';
                  }
                  return null;
                },
                onChanged: (value) {
                  widget.order.orderWeight = value;
                },
              ),
              TextFormField(
                initialValue: widget.order.qty.toString(),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Quantity'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid input';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (GetUtils.isNumericOnly(value))
                    widget.order.qty = int.parse(value);
                },
              ),
              TextFormField(
                initialValue: widget.order.orderDesc,
                decoration: InputDecoration(labelText: 'Order Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid input';
                  }
                  return null;
                },
                onChanged: (value) {
                  widget.order.orderDesc = value;
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  "Pickup Date",
                  style: Theme.of(context).textTheme.caption,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.order.pickupDate}",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Divider(
                      height: 8,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
                onTap: _selectPickupDate,
              ),
              TextFormField(
                initialValue: widget.order.pickupAddress1,
                decoration: InputDecoration(labelText: 'Pickup Address 1'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid input';
                  }
                  return null;
                },
                onChanged: (value) {
                  widget.order.pickupAddress1 = value;
                },
              ),
              TextFormField(
                initialValue: widget.order.pickupAddress2,
                decoration: InputDecoration(labelText: 'Pickup Address 2'),
                validator: (value) {
                  return null;
                },
                onChanged: (value) {
                  widget.order.pickupAddress2 = value;
                },
              ),
              TextFormField(
                initialValue: widget.order.pickupPostalCode.toString(),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Pickup Postal Code'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid input';
                  }
                  return null;
                },
                onChanged: (value) {
                  widget.order.pickupPostalCode = int.parse(value);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  "Pickup Date",
                  style: Theme.of(context).textTheme.caption,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.order.pickupDate}",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Divider(
                      height: 8,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
                onTap: _selectDeliveryDate,
              ),
              TextFormField(
                initialValue: widget.order.deliveryAddress1,
                decoration: InputDecoration(labelText: 'Delivery Address 1'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid input';
                  }
                  return null;
                },
                onChanged: (value) {
                  widget.order.deliveryAddress1 = value;
                },
              ),
              TextFormField(
                initialValue: widget.order.deliveryAddress2,
                decoration: InputDecoration(labelText: 'Delivery Address 2'),
                validator: (value) {
                  return null;
                },
                onChanged: (value) {
                  widget.order.deliveryAddress2 = value;
                },
              ),
              TextFormField(
                initialValue: widget.order.deliveryPostalCode.toString(),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Delivery Postal Code'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid input';
                  }
                  return null;
                },
                onChanged: (value) {
                  widget.order.deliveryPostalCode = int.parse(value);
                },
              ),
              TextFormField(
                initialValue: widget.order.custFirstName,
                decoration: InputDecoration(labelText: 'Customer First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid input';
                  }
                  return null;
                },
                onChanged: (value) {
                  widget.order.custFirstName = value;
                },
              ),
              TextFormField(
                initialValue: widget.order.custLastName,
                decoration: InputDecoration(labelText: 'Customer Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid input';
                  }
                  return null;
                },
                onChanged: (value) {
                  widget.order.custLastName = value;
                },
              ),
              TextFormField(
                initialValue: widget.order.custEmail,
                decoration: InputDecoration(labelText: 'Customer Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid input';
                  }
                  return null;
                },
                onChanged: (value) {
                  widget.order.custEmail = value;
                },
              ),
              TextFormField(
                initialValue: widget.order.orderNo,
                decoration: InputDecoration(labelText: 'Customer Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid input';
                  }
                  return null;
                },
                onChanged: (value) {
                  widget.order.custPhoneNo = int.parse(value);
                },
              ),
              TextFormField(
                initialValue: widget.order.custCompany,
                decoration: InputDecoration(labelText: 'Customer Company'),
                validator: (value) {
                  return null;
                },
                onChanged: (value) {
                  widget.order.custCompany = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  onPressed: () {
                    _ordersController
                        .deletedSingleOrder(widget.order)
                        .then((value) => Get.offAll(() => AppView()));
                  },
                  child: Text('Delete'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
