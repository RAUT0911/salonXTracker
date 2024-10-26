
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

import '../../../services/database.dart';

class MakeEntry extends StatefulWidget {
  const MakeEntry({super.key});

  @override
  State<MakeEntry> createState() => _MakeEntryState();
}

class _MakeEntryState extends State<MakeEntry> {
  final List<String> _services = ['Haircut', 'Hair Color', 'Shave', 'Facial', 'Massage'];
  final List<String> _amounts = ['50', '100', '150', '180', '200'];

  String? _selectedService;
  String? _selectedAmount;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Track Progress"), centerTitle: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                hint: Text('Select a Service'),
                value: _selectedService,
                items: _services.map((String service) {
                  return DropdownMenuItem<String>(
                    value: service,
                    child: Text(service),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedService = newValue;
                  });
                },
              ),
              DropdownButton<String>(
                hint: Text('Select Amount'),
                value: _selectedAmount,
                items: _amounts.map((String amount) {
                  return DropdownMenuItem<String>(
                    value: amount,
                    child: Text(amount),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedAmount = newValue;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            _selectedService != null ? 'Selected Service: $_selectedService' : 'No Service Selected',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            _selectedAmount != null ? 'Selected Amount : $_selectedAmount' : 'No Amount Selected',
          ),
          SizedBox(height: 50),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                String paymentId = randomAlphaNumeric(10); // Generate a unique payment ID
                Map<String, dynamic> paymentInfoMap = {
                  "Service": _selectedService,
                  "Amount": _selectedAmount,
                  // Add other payment-related fields as necessary
                };

                await DatabaseMethods().addPaymentDetails(paymentInfoMap, paymentId).then((value) {
                  Fluttertoast.showToast(
                      msg: "Payment Details added Successfully.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green, // You can change the color if needed
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }).catchError((error) {
                  Fluttertoast.showToast(
                      msg: "Failed to add payment details: $error",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                });
              },
              child: Text(
                "Add Entries",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),)
        ],
      ),
    );
  }
}
