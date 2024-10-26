import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/database.dart';
import 'menu/drivers_structure.dart';
import 'menu/track_entries.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stream? paymentStream;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double todayTotal = 0.0; // Variable to track today's total amount

  // Function to show a Snackbar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Fetch payment details and calculate today's total
  Future<void> getPaymentDetails() async {
    paymentStream = await DatabaseMethods().getPaymentDetails();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPaymentDetails();
  }

  // Function to calculate today's total from payment documents
  void calculateTodayTotal(List<DocumentSnapshot> paymentDocs) {
    todayTotal = 0.0; // Reset total for today
    for (var ds in paymentDocs) {
      var data = ds.data() as Map<String, dynamic>;
      double amount = double.tryParse(data["Amount"].toString()) ?? 0.0;
      todayTotal += amount; // Add amount to today's total
    }
  }

  Widget allPaymentsDetails() {
    return StreamBuilder(
      stream: paymentStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          var paymentDocs = snapshot.data.docs;

          if (paymentDocs.isEmpty) {
            todayTotal = 0.0; // Reset total for today
            return Center(
              child: Text(
                "0",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          // Calculate the total for today
          calculateTodayTotal(paymentDocs);

          return ListView.builder(
            itemCount: paymentDocs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = paymentDocs[index];
              var data = ds.data() as Map<String, dynamic>;

              // Safely handle missing fields with the null-aware operator
              String service = data["Service"] ?? "No Service";
              double amount = double.tryParse(data["Amount"].toString()) ?? 0.0;
              String? id = data["paymentId"] as String?;

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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Service: $service",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (id != null) {
                                  // Delete the payment detail
                                  await DatabaseMethods().deletePaymentsDetail(id);
                                  // Refresh payment details and update the total
                                  await getPaymentDetails();
                                  _showSnackBar("Entry deleted successfully!");
                                } else {
                                  _showSnackBar("Cannot delete entry without a valid ID.");
                                }
                              },
                              child: Icon(Icons.delete, color: Colors.black),
                            ),
                          ],
                        ),
                        Text(
                          "Amount: ₹${amount.toStringAsFixed(2)}", // Show amount formatted
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
              "Today Score: 0",
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
  Widget build(BuildContext context) {
    String quote = "“आजच्या छोट्या प्रयत्नांनी उद्याचे \nमोठे यश मिळवता येईल.”";
    String currentDate = DateFormat.yMMMMd().format(DateTime.now());

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("SalonxTracker"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(
              width: double.infinity,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    title: const Text('History'),
                    onTap: () {
                      Navigator.pop(context); // Close the drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DriverHistoryScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Profile'),
                    onTap: () {
                      Navigator.pop(context); // Close the drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Implement your logout logic here, like clearing user session
              },
            ),
          ],
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              quote,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 10),
            Text(
              currentDate,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 10),
            // Display the total for today at the center of the screen
            Text(
              "Today's Total: ₹${todayTotal.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 30),
            Expanded(
              child: allPaymentsDetails(), // Payments details widget
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to Track Entry screen
                Navigator.push(context, MaterialPageRoute(builder: (context) => MakeEntry()));
              },
              icon: Icon(Icons.track_changes),
              label: Text("Track Entry"),
            ),
            SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {
                // Show snackbar for upload functionality not yet set up
                _showSnackBar("Not set up yet!");
              },
              icon: Icon(Icons.photo_library),
              label: Text("Upload Photo from Gallery"),
            ),
          ],
        ),
      ),
    );
  }
}
