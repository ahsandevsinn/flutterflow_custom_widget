import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  String? selectedCategoryName;
  String? selectedCategoryId;
  DocumentReference? selectedCategoryRef;
  late CollectionReference categoriesCollection;

  // Modified to return a Future that fetches categories
  Future<QuerySnapshot> getCategories() async {
    categoriesCollection = FirebaseFirestore.instance.collection('Catagories');
    return await categoriesCollection
        .get(); // Fetch categories and return the result
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: getCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No categories found'));
        }

        // Extract category names and IDs from Firestore documents
        List<Map<String, dynamic>> categories = snapshot.data!.docs.map((
          doc,
        ) {
          return {
            'id': doc.id,
            'name': doc['catagoryName'],
            'reference': doc.reference,
          };
        }).toList();

        return Container(
          decoration: BoxDecoration(
            color: Color(0xfffcf8ea),
            border: Border.all(color: Color(0xfffc6e50)),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: selectedCategoryName,
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Please select a category'),
                  ),
                  icon: SizedBox(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategoryName = newValue;

                      var selectedCategory = categories.firstWhere(
                        (category) => category['name'] == newValue,
                        orElse: () => categories.first,
                      );
                      selectedCategoryId = selectedCategory['id'];
                      selectedCategoryRef = selectedCategory['reference'];
                      // FFAppState().selectedCatagoryReference =
                      //     selectedCategoryRef;
                      print("selectedCategoryId ${selectedCategoryId}");
                      print(
                        "selectedCategoryRef ${selectedCategoryRef?.path}",
                      );
                    });
                  },
                  items: categories.map<DropdownMenuItem<String>>((
                    Map<String, dynamic> category,
                  ) {
                    return DropdownMenuItem<String>(
                      value: category['name'],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          category['name'],
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffFC6E50),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  underline: Container(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


// class DropDownWidget extends StatefulWidget {
//   const DropDownWidget({
//     super.key,
//     this.width,
//     this.height,
//   });

//   final double? width;
//   final double? height;

//   @override
//   State<DropDownWidget> createState() => _DropDownWidgetState();
// }

// class _DropDownWidgetState extends State<DropDownWidget> {
//   String? selectedCategoryName;
//   String? selectedCategoryId;
//   DocumentReference? selectedCategoryRef;
//   late CollectionReference categoriesCollection;

//   // Modified to return a Future that fetches categories
//   Future<QuerySnapshot> getCategories() async {
//     categoriesCollection = FirebaseFirestore.instance.collection('Catagories');
//     return await categoriesCollection
//         .get(); // Fetch categories and return the result
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<QuerySnapshot>(
//       future: getCategories(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }

//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return Center(child: Text('No categories found'));
//         }

//         // Extract category names and IDs from Firestore documents
//         List<Map<String, dynamic>> categories = snapshot.data!.docs.map((
//           doc,
//         ) {
//           return {
//             'id': doc.id,
//             'name': doc['catagoryName'],
//             'reference': doc.reference,
//           };
//         }).toList();

//         return Container(
//           decoration: BoxDecoration(
//             color: Color(0xfffcf8ea),
//             border: Border.all(color: Color(0xfffc6e50)),
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: DropdownButton<String>(
//                   value: selectedCategoryName,
//                   hint: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text('Please select a category'),
//                   ),
//                   icon: SizedBox(),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       selectedCategoryName = newValue;

//                       var selectedCategory = categories.firstWhere(
//                         (category) => category['name'] == newValue,
//                         orElse: () => categories.first,
//                       );
//                       selectedCategoryId = selectedCategory['id'];
//                       selectedCategoryRef = selectedCategory['reference'];
//                       FFAppState().selectedCatagoryReference =
//                           selectedCategoryRef;
//                       print("selectedCategoryId ${selectedCategoryId}");
//                       print(
//                         "selectedCategoryRef ${selectedCategoryRef?.path}",
//                       );
//                     });
//                   },
//                   items: categories.map<DropdownMenuItem<String>>((
//                     Map<String, dynamic> category,
//                   ) {
//                     return DropdownMenuItem<String>(
//                       value: category['name'],
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           category['name'],
//                           style: TextStyle(
//                             fontSize: 16.0,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xffFC6E50),
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                   underline: Container(),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }


// class EditCatagoryDropDown extends StatefulWidget {
//   EditCatagoryDropDown({
//     super.key,
//     this.width,
//     this.height,
//     this.selectedRef,
//   });

//   final double? width;
//   final double? height;
//   final DocumentReference? selectedRef; // Keep this final
//   @override
//   State<EditCatagoryDropDown> createState() => _EditCatagoryDropDownState();
// }

// class _EditCatagoryDropDownState extends State<EditCatagoryDropDown> {
//   DocumentReference? selectedCategoryRef;
//   late CollectionReference categoriesCollection;

//   @override
//   void initState() {
//     super.initState();
//     // initialize with passed reference
//     selectedCategoryRef = widget.selectedRef;
//   }

//   Future<QuerySnapshot> getCategories() async {
//     categoriesCollection = FirebaseFirestore.instance.collection('Catagories');
//     return await categoriesCollection.get();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<QuerySnapshot>(
//       future: getCategories(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }

//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return const Center(child: Text('No categories found'));
//         }

//         List<Map<String, dynamic>> categories = snapshot.data!.docs.map((doc) {
//           return {
//             'name': doc['catagoryName'],
//             'reference': doc.reference,
//           };
//         }).toList();

//         return Container(
//           decoration: BoxDecoration(
//             color: const Color(0xfffcf8ea),
//             border: Border.all(color: const Color(0xfffc6e50)),
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           child: DropdownButton<DocumentReference>(
//             value: selectedCategoryRef, // ✅ use local state value
//             hint: const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text('Please select a category'),
//             ),
//             isExpanded: true,
//             icon: const SizedBox(),
//             onChanged: (DocumentReference? newRef) {
//               setState(() {
//                 selectedCategoryRef = newRef;
//                 print("selectedCategoryRef: ${selectedCategoryRef?.path}");
//                 FFAppState().selectedCatagoryReference = selectedCategoryRef;
//               });
//             },
//             items: categories.map<DropdownMenuItem<DocumentReference>>(
//               (Map<String, dynamic> category) {
//                 return DropdownMenuItem<DocumentReference>(
//                   value: category['reference'],
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       category['name'],
//                       style: TextStyle(
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xffFC6E50),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ).toList(),
//             underline: Container(),
//           ),
//         );
//       },
//     );
  
//   }
// }