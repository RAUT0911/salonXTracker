
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../pages/bargraphrepresentation/services_bar.dart';
import '../../../services/database.dart';

class DriverHistoryScreen extends StatefulWidget {
  const DriverHistoryScreen({super.key});

  @override
  State<DriverHistoryScreen> createState() => _DriverHistoryScreenState();
}

class _DriverHistoryScreenState extends State<DriverHistoryScreen> {
  Stream? PaymentStream;

  getontheload() async {
    PaymentStream = await DatabaseMethods().getPaymentDetails();
    setState(() {

    });
  }

  Widget allPaymentsDetails(){
    return StreamBuilder(
      stream: PaymentStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          var paymentDocs = snapshot.data.docs;

          if (paymentDocs.isEmpty) {
            return Center(
              child: Text(
                " 0 ",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: paymentDocs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = paymentDocs[index];

              // Cast ds.data() to Map<String, dynamic>
              var data = ds.data() as Map<String, dynamic>;

              String service = data.containsKey("Service") ? data["Service"] : "No Service";
              String amount = data.containsKey("Amount") ? data["Amount"] : "No Amount";
              String id = data.containsKey("paymentId") ? data["paymentId"] : null;

              return Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Service: $service",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                          ],
                        ),
                        Text(
                          "Amount: $amount",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(
            child: Text(
              "No Payment History",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
      },
    );
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    String currentDate = DateFormat.yMMMMd().format(DateTime.now());

    return Scaffold(
      appBar: AppBar( title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Payments",
            style: TextStyle(
                color: Colors.blue,
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "History",
            style: TextStyle(
                color: Colors.orange,
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          )
        ],
      ),),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Expanded(child: allPaymentsDetails(),)
          ],
        ),
      ),
    );
  }
}



class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payments")),
      body: allPaymentsDetails(),
    );
  }

  Widget allPaymentsDetails() {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseMethods().getPaymentDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        var paymentDocs = snapshot.data?.docs ?? [];

        if (paymentDocs.isEmpty) {
          return Center(
            child: Text(
              "No Payments Found",
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          );
        }

        // Create a map to store aggregated service amounts
        Map<String, double> serviceAmounts = {};

        // Aggregate amounts by service
        for (var ds in paymentDocs) {
          var data = ds.data() as Map<String, dynamic>;
          String service = data["Service"] ?? "No Service";
          double amount = double.tryParse(data["Amount"].toString()) ?? 0.0;

          // Sum amounts for each service
          serviceAmounts[service] = (serviceAmounts[service] ?? 0.0) + amount;
        }

        // Pass the aggregated data to the ServiceBarChart
        return Column(
          children: [
            Expanded(
              child: ServiceBarChart(serviceAmounts: serviceAmounts),
            ),
            // Optionally, you can add more UI elements below the chart
          ],
        );
      },
    );
  }
}

