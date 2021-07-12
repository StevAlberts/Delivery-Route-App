import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:implicitly_animated_list/implicitly_animated_list.dart';
import 'package:intl/intl.dart';
import 'package:load_n_go/controllers/ordersController.dart';
import 'package:load_n_go/models/orderModel.dart';
import 'package:load_n_go/views/orderDescriptionView.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class AllOrdersView extends StatefulWidget {
  const AllOrdersView({Key? key}) : super(key: key);

  @override
  _AllOrdersViewState createState() => _AllOrdersViewState();
}

class _AllOrdersViewState extends State<AllOrdersView> {
  OrdersController _ordersController =
      Get.put(OrdersController(), permanent: true);
  final _searchController = FloatingSearchBarController();
  bool selectAll = true;
  bool selectAreaCode = false;
  bool selectPickup = false;
  bool selectDelivery = false;
  bool selectMerchant = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetBuilder<OrdersController>(
          init: _ordersController,
          builder: (snapshot) {
            return FloatingSearchBar(
              automaticallyImplyBackButton: false,
              controller: _searchController,
              clearQueryOnClose: true,
              hint: 'Search all orders ...',
              transitionDuration: const Duration(milliseconds: 800),
              transitionCurve: Curves.easeInOutCubic,
              physics: const BouncingScrollPhysics(),
              progress: snapshot.loading.value,
              scrollPadding: EdgeInsets.zero,
              closeOnBackdropTap: true,
              transition: CircularFloatingSearchBarTransition(spacing: 16),
              leadingActions: [
                FloatingSearchBarAction(
                  showIfOpened: false,
                  child: Icon(
                    Icons.search,
                    size: 30,
                  ),
                ),
              ],
              actions: [
                FloatingSearchBarAction(
                  showIfOpened: false,
                  child: PopupMenuButton(
                    icon: Icon(
                      Icons.filter_list,
                      size: 30,
                    ),
                    offset: Offset(0, 50),
                    onSelected: (String value) {
                      print(value);
                      _ordersController.filterOrders(value);
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text("Area Code"),
                        value: 'areaCode',
                      ),
                      PopupMenuItem(
                        child: Text("Pickup Date"),
                        value: 'pickupDate',
                      ),
                      PopupMenuItem(
                        child: Text("Delivery Date"),
                        value: 'deliveryDate',
                      ),
                      PopupMenuItem(
                        child: Text("Merchant Name"),
                        value: 'merchantName',
                      ),
                    ],
                  ),
                ),
                FloatingSearchBarAction.searchToClear(showIfClosed: false),
              ],
              onQueryChanged: (query) {
                if (query.isEmpty) {
                  _ordersController.clearSearch();
                } else {
                  _ordersController.searchAllOrders(query);
                }
              },
              builder: (context, _) => _buildExpandableSearchBody(),
              body: _buildAllOrders(snapshot.allOrders),
            );
          }),
    );
  }

  // selected orders dialog
  void _buildSelectedOrderDialog() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: new Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                  title: new Text('Delete all selected'),
                  onTap: () {
                    _ordersController.deletedAllSelectedRows();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: new Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  title: new Text('Approval all selected (YES)'),
                  onTap: () {
                    _ordersController.approveAllSelectedRows();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: new Icon(
                    Icons.file_download,
                    color: Colors.blue,
                  ),
                  title: new Text('Export all selected'),
                  onTap: () {
                    _ordersController.exportToCSV();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.close),
                  title: new Text('Cancel'),
                  onTap: () {
                    _ordersController.clearSelectedOrders();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  // all orders body widget
  Widget _buildAllOrders(List<OrderModel> orders) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            height: 110,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _ordersController.selectedOrders.length > 0
                  ? ElevatedButton(
                      onPressed: _buildSelectedOrderDialog,
                      child: Text(
                        "Orders selected (${_ordersController.selectedOrders.length})",
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: ActionChip(
                              backgroundColor: selectAll ? Colors.green : null,
                              elevation: 2,
                              labelStyle: TextStyle(
                                  color: selectAll ? Colors.white : null),
                              label: Text("All"),
                              onPressed: () {
                                _ordersController.sortOrders('all');
                                setState(() {
                                  selectAll = true;
                                  selectAreaCode = false;
                                  selectPickup = false;
                                  selectDelivery = false;
                                  selectMerchant = false;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: ActionChip(
                              backgroundColor:
                                  selectAreaCode ? Colors.green : null,
                              elevation: 2,
                              labelStyle: TextStyle(
                                  color: selectAreaCode ? Colors.white : null),
                              label: Text("Area Code"),
                              onPressed: () {
                                _ordersController.sortOrders('areaCode');
                                setState(() {
                                  selectAll = false;
                                  selectAreaCode = true;
                                  selectPickup = false;
                                  selectDelivery = false;
                                  selectMerchant = false;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: ActionChip(
                                backgroundColor:
                                    selectPickup ? Colors.green : null,
                                elevation: 2,
                                labelStyle: TextStyle(
                                    color: selectPickup ? Colors.white : null),
                                label: Text("Pickup Date"),
                                onPressed: () {
                                  _ordersController.sortOrders('pickupDate');
                                  setState(() {
                                    selectAll = false;
                                    selectAreaCode = false;
                                    selectPickup = true;
                                    selectDelivery = false;
                                    selectMerchant = false;
                                  });
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: ActionChip(
                              backgroundColor:
                                  selectDelivery ? Colors.green : null,
                              elevation: 2,
                              labelStyle: TextStyle(
                                  color: selectDelivery ? Colors.white : null),
                              label: Text("Delivery Date"),
                              onPressed: () {
                                _ordersController.sortOrders('deliveryDate');
                                setState(() {
                                  selectAll = false;
                                  selectAreaCode = false;
                                  selectPickup = false;
                                  selectDelivery = true;
                                  selectMerchant = false;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: ActionChip(
                              backgroundColor:
                                  selectMerchant ? Colors.green : null,
                              elevation: 2,
                              labelStyle: TextStyle(
                                  color: selectMerchant ? Colors.white : null),
                              label: Text("Merchant Name"),
                              onPressed: () {
                                _ordersController.sortOrders('merchantName');
                                setState(() {
                                  selectAll = false;
                                  selectAreaCode = false;
                                  selectPickup = false;
                                  selectDelivery = false;
                                  selectMerchant = true;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          orders.length > 0
              ? Expanded(
                  child: ListView.separated(
                    itemCount: orders.length,
                    separatorBuilder: (context, index) => Divider(height: 1),
                    itemBuilder: (context, index) {
                      OrderModel order = orders[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green.withOpacity(0.2),
                          foregroundColor: Colors.black,
                          child: Container(
                            child:
                                _ordersController.selectedOrders.contains(order)
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 40,
                                      )
                                    : Text(
                                        "${order.custFirstName.split(" ")[0][0]}${order.custFirstName.split(" ")[1]}",
                                      ),
                          ),
                        ),
                        title: Text(order.custFirstName),
                        subtitle: Text(order.orderNo),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${DateFormat.yMd().format(order.deliveryDate)}",
                            ),
                            Text(
                              "Delivery",
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: order.approvalStatus!.isEmpty
                                      ? Colors.grey.withOpacity(0.2)
                                      : Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    order.approvalStatus!.isEmpty
                                        ? "PENDING"
                                        : "APPROVED",
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                            color:
                                                order.approvalStatus!.isNotEmpty
                                                    ? Colors.green
                                                    : null),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        selected:
                            _ordersController.selectedOrders.contains(order)
                                ? true
                                : false,
                        selectedTileColor: Colors.green.withOpacity(0.1),
                        onLongPress: () {
                          if (_ordersController.selectedOrders
                              .contains(order)) {
                            _ordersController.unSelect(order);
                          } else {
                            _ordersController.multiSelect(order);
                          }
                        },
                        onTap: _ordersController.selectedOrders.length > 0
                            ? () {
                                if (_ordersController.selectedOrders
                                    .contains(order)) {
                                  _ordersController.unSelect(order);
                                } else {
                                  _ordersController.multiSelect(order);
                                }
                              }
                            : () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OrderDescriptionView(order: order),
                                  ),
                                ),
                      );
                    },
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                    Text("No orders found."),
                    ElevatedButton(
                      onPressed: _ordersController.readCSVOrders,
                      child: Text('Reset'),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildExpandableSearchBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Material(
        elevation: 6.0,
        borderRadius: BorderRadius.circular(8),
        child: ImplicitlyAnimatedList(
          shrinkWrap: true,
          itemData: _ordersController.searchedOrders,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, OrderModel data) => _buildSearchItem(data),
        ),
      ),
    );
  }

  Widget _buildSearchItem(OrderModel order) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.withOpacity(0.5),
            foregroundColor: Colors.black,
            child: Container(
              child: Text(
                "${order.merchantName.split(" ")[0][0]}${order.merchantName.split(" ")[1]}",
              ),
            ),
          ),
          title: Text("${order.merchantName}"),
          subtitle: Text("${order.orderNo}"),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${DateFormat.yMd().format(order.deliveryDate)}",
              ),
              Text(
                "Pickup: ${DateFormat.yMd().format(order.pickupDate)}",
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
          onTap: () {
            // _searchCont.close();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDescriptionView(order: order),
              ),
            );
          },
        ),
        Divider(height: 1),
      ],
    );
  }
}
