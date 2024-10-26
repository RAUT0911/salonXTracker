import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  // Adding employee details to Firestore
  Future<void> addEmployeeDetails(
      Map<String, dynamic> employeeInfoMap, String Id) async {
    employeeInfoMap['ID'] = Id;
    await FirebaseFirestore.instance
        .collection("Employee")
        .doc(Id)
        .set(employeeInfoMap);
  }

  // Reading employee details from Firestore
  Stream<QuerySnapshot> getEmployeeDetails() {
    return FirebaseFirestore.instance.collection("Employee").snapshots();
  }

  //Updating
  Future updateEmployeeDetail(String Id, Map< String , dynamic> updateInfo) async {
    return await FirebaseFirestore.instance.collection("Employee").doc(Id).update(updateInfo);
  }

  //Delete Details
  Future deleteEmployeeDetail(String Id) async {
    return await FirebaseFirestore.instance.collection("Employee").doc(Id).delete();
  }




  Future<void> addPaymentDetails(
      Map<String, dynamic> paymentInfoMap, String paymentId) async {
    paymentInfoMap['paymentId'] = paymentId;  // Add a unique ID for the payment
    await FirebaseFirestore.instance
        .collection("Payments")
        .doc(paymentId)
        .set(paymentInfoMap);
  }

  // Reading payment details from Firestore
  Stream<QuerySnapshot> getPaymentDetails() {
    return FirebaseFirestore.instance.collection("Payments").snapshots();
  }

  Future deletePaymentsDetail(String paymentId) async {
    return await FirebaseFirestore.instance.collection("Payments").doc(paymentId).delete();
  }




}