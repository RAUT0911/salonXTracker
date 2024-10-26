
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/database.dart';
import 'employee.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  Stream? EmployeeStream;

  getontheload() async {
    EmployeeStream = await DatabaseMethods().getEmployeeDetails();
    setState(() {

    });
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allEmployeeDetails() {
    return StreamBuilder(
      stream: EmployeeStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          var employeeDocs = snapshot.data.docs;

          if (employeeDocs.isEmpty) {
            return Center(
              child: Text(
                "No Employee Details",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: employeeDocs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = employeeDocs[index];

              // Cast ds.data() to Map<String, dynamic>
              var data = ds.data() as Map<String, dynamic>;

              String name = data.containsKey("Name") ? data["Name"] : "No Name";
              String age = data.containsKey("Age") ? data["Age"] : "No Age";
              String location = data.containsKey("Location") ? data["Location"] : "No Location";
              String id = data.containsKey("ID") ? data["ID"] : null;

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
                              "Name: $name",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                nameController.text = name;
                                ageController.text = age;
                                locationController.text = location;

                                if (id != null) {
                                  EditEmployeeDetail(id);
                                } else {
                                  print("No ID available for editing.");
                                }
                              },
                              child: Icon(Icons.edit, color: Colors.orange),
                            ),
                            SizedBox(width: 10.0),
                            GestureDetector(
                              onTap: () async {
                                if (id != null) {
                                  await DatabaseMethods().deleteEmployeeDetail(id);
                                } else {
                                  print("No ID available for deletion.");
                                }
                              },
                              child: Icon(Icons.delete, color: Colors.orange),
                            ),
                          ],
                        ),
                        Text(
                          "Age: $age",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Location: $location",
                          style: TextStyle(
                            color: Colors.blue,
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
              "No Employee Details",
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

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Employee()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Flutter",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Firebase",
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Expanded(child: allEmployeeDetails())
          ],
        ),
      ),
    );
  }


  Future EditEmployeeDetail(String id) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Container(
        // Wrap the Column in SingleChildScrollView to allow scrolling if content overflows
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // This will adapt the height of the dialog to its content
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.cancel),
                  ),
                  Text(
                    "Edit Details",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Name",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Age",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Location",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: locationController,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: () async {
                Map<String , dynamic> updateInfo = {
                  "Name":nameController.text,
                  "Age":ageController.text,
                  "Id":id,
                  "Location":locationController.text,
                };
                await DatabaseMethods().updateEmployeeDetail(id, updateInfo).then((value){
                  Navigator.pop(context);
                });
              }, child: Text("Update",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20),))
            ],
          ),
        ),
      ),
    ),
  );


}
