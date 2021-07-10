import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:load_n_go/controllers/deliveryController.dart';
import 'package:load_n_go/controllers/ordersController.dart';
import 'package:load_n_go/models/deliveryModel.dart';
import 'package:load_n_go/models/orderModel.dart';

import 'orderDescriptionView.dart';

class MyDeliveriesView extends StatefulWidget {
  const MyDeliveriesView({Key? key}) : super(key: key);

  @override
  _MyDeliveriesViewState createState() => _MyDeliveriesViewState();
}

class _MyDeliveriesViewState extends State<MyDeliveriesView> {
  OrdersController _ordersController = Get.put(OrdersController());
  DeliveryController _deliveryController = Get.put(DeliveryController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveryController>(
        init: _deliveryController,
        builder: (snapshot) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "My Deliveries",
                style: TextStyle(color: Colors.black),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(color: Colors.black),
            ),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              label: Text("Route"),
              icon: snapshot.loading.isFalse
                  ? Icon(Icons.directions, size: 30)
                  : CircularProgressIndicator(),
              onPressed: () {
                if (snapshot.loading.isFalse) _deliveryController.fetchRoutes();
              },
            ),
            body: snapshot.routedDeliveries.value.length > 0
                ? Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemCount: snapshot.routedDeliveries.value.length,
                          separatorBuilder: (context, index) => Divider(),
                          itemBuilder: (context, index) {
                            DeliveryModel _delivery =
                                snapshot.routedDeliveries.value[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.green.withOpacity(0.2),
                                foregroundColor: Colors.black,
                                child: Container(
                                  child: _ordersController.selectedOrders
                                          .contains(_delivery)
                                      ? Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 30,
                                        )
                                      : Text(
                                          "${_delivery.custFirstName.split(" ")[0][0]}${_delivery.custFirstName.split(" ")[1]}",
                                        ),
                                ),
                              ),
                              title: Text(_delivery.custFirstName),
                              subtitle: Text(_delivery.orderNo),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${DateFormat.yMd().format(DateTime.parse(_delivery.deliveryDate))}",
                                  ),
                                  Text(
                                    "Delivery",
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                              selected: _ordersController.selectedOrders
                                      .contains(_delivery)
                                  ? true
                                  : false,
                              selectedTileColor: Colors.green.withOpacity(0.1),
                              onLongPress: () {
                                // if (_ordersController.selectedOrders
                                //     .contains(_delivery)) {
                                //   _ordersController.unSelect(_delivery);
                                // } else {
                                //   _ordersController.multiSelect(_delivery);
                                // }
                              },
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderDescriptionView(
                                      order: OrderModel.fromJson(
                                          _delivery.toJSON())),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 50),
                    ],
                  )
                : snapshot.loading.isFalse
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Route not optimized",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Press the button below to route",
                                style: Theme.of(context).textTheme.caption,
                              ),
                            )
                          ],
                        ),
                      )
                    : CircularProgressIndicator(),
          );
        });
  }
}
