import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

import '../../services/database.dart';

class Employee extends StatefulWidget {
  const Employee({super.key});

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Employee",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Form",
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24),),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                    border: InputBorder.none
                ),
              ),
            ),
            SizedBox(height: 10,),
            Text("Age",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24),),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: TextField(
                controller: ageController,
                keyboardType:TextInputType.number ,
                decoration: InputDecoration(
                    border: InputBorder.none
                ),
              ),
            ),
            SizedBox(height: 10,),
            Text("Location",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24),),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                    border: InputBorder.none
                ),
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: ElevatedButton(onPressed: () async {
                String Id = randomAlphaNumeric(10);
                Map<String,dynamic> employeeInfoMap = {
                  "Name" : nameController.text,
                  "Age" : ageController.text,
                  "Location" : locationController.text,
                };
                await DatabaseMethods().addEmployeeDetails(employeeInfoMap, Id).then((value)
                {
                  Fluttertoast.showToast(
                      msg: "Employee Details added Sucessfully.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }
                );

              }, child: Text("Add",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
            ),

          ],
        ),
      ),
    );
  }
}
