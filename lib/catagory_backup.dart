// // Automatic FlutterFlow imports
// import '/backend/backend.dart';
// import '/backend/schema/structs/index.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/custom_code/widgets/index.dart'; // Imports other custom widgets
// import '/flutter_flow/custom_functions.dart'; // Imports custom functions
// import 'package:flutter/material.dart';
// // Begin custom widget code
// // DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// import 'package:cloud_firestore/cloud_firestore.dart';

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
//                         child: Text(category['name']),
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// class EditDropDownWidget extends StatefulWidget {
//    EditDropDownWidget({
//     super.key,
//     this.width,
//     this.height,
//     this.id,
//   });

//   final double? width;
//   final double? height;
//    String? id;

//   @override
//   State<EditDropDownWidget> createState() => _EditDropDownWidgetState();
// }

// class _EditDropDownWidgetState extends State<EditDropDownWidget> {
//   // String? selectedCategoryId; // 🔹 अब selection ID से होगी
//   DocumentReference? selectedCategoryRef;
//   late CollectionReference categoriesCollection;

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

//         // 🔹 Extract categories list
//         List<Map<String, dynamic>> categories = snapshot.data!.docs.map((doc) {
//           return {
//             'id': doc.id,
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
//           child: Row(
//             children: [
//               Expanded(
//                 child: DropdownButton<String>(
//                   value: widget.id, // 🔹 ID-based value
//                   hint: const Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text('Please select a category'),
//                   ),
//                   icon:  SizedBox(),
//                   onChanged: (String? newId) {
//                     setState(() {
//                      widget.id = newId;

//                       var selectedCategory = categories.firstWhere(
//                         (category) => category['id'] == newId,
//                         orElse: () => categories.first,
//                       );

//                       selectedCategoryRef = selectedCategory['reference'];
//                       // FFAppState().selectedCatagoryReference =
//                       //     selectedCategoryRef;

//                       print("selectedCategoryId: ${widget.id}");
//                       print("selectedCategoryRef: ${selectedCategoryRef?.path}");
//                     });
//                   },
//                   items: categories.map<DropdownMenuItem<String>>(
//                     (Map<String, dynamic> category) {
//                       return DropdownMenuItem<String>(
//                         value: category['id'], // 🔹 ID used as value
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(category['name']), // 🔹 Name displayed
//                         ),
//                       );
//                     },
//                   ).toList(),
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


class EditCatagoryDropDown extends StatefulWidget {
  EditCatagoryDropDown({
    super.key,
    this.width,
    this.height,
    this.selectedRef,
  });

  final double? width;
  final double? height;
  DocumentReference? selectedRef; // 🔹 change from id → reference

  @override
  State<EditCatagoryDropDown> createState() => _EditCatagoryDropDownState();
}

class _EditCatagoryDropDownState extends State<EditCatagoryDropDown> {
  DocumentReference? selectedCategoryRef;
  late CollectionReference categoriesCollection;

  Future<QuerySnapshot> getCategories() async {
    categoriesCollection = FirebaseFirestore.instance.collection('Catagories');
    return await categoriesCollection.get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: getCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No categories found'));
        }

        // 🔹 Extract categories list
        List<Map<String, dynamic>> categories = snapshot.data!.docs.map((doc) {
          return {
            'name': doc['catagoryName'],
            'reference': doc.reference, // 🔹 Use reference directly
          };
        }).toList();

        // 🔹 Set current value based on reference
        DocumentReference? dropdownValue;
        final categoryRefs = categories.map((c) => c['reference']).toList();

        if (categoryRefs.contains(widget.selectedRef)) {
          dropdownValue = widget.selectedRef;
        }

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xfffcf8ea),
            border: Border.all(color: const Color(0xfffc6e50)),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: DropdownButton<DocumentReference>(
            value: dropdownValue, // 🔹 reference-based value
            hint: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Please select a category'),
            ),
            isExpanded: true,
            icon: const SizedBox(),
            onChanged: (DocumentReference? newRef) {
              setState(() {
                widget.selectedRef = newRef;
                selectedCategoryRef = newRef;

                print("selectedCategoryRef: ${selectedCategoryRef?.path}");
              });
            },
            items: categories.map<DropdownMenuItem<DocumentReference>>(
              (Map<String, dynamic> category) {
                return DropdownMenuItem<DocumentReference>(
                  value: category['reference'], // 🔹 Use reference as value
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(category['name']),
                  ),
                );
              },
            ).toList(),
            underline: Container(),
          ),
        );
      },
    );
  }
}


class CatagoryListingDropDown extends StatefulWidget {
  CatagoryListingDropDown({
    super.key,
    this.width,
    this.height,
    this.selectedRef,
  });

  final double? width;
  final double? height;
  DocumentReference? selectedRef; // 🔹 change from id → reference

  @override
  State<CatagoryListingDropDown> createState() => _CatagoryListingDropDownState();
}

class _CatagoryListingDropDownState extends State<CatagoryListingDropDown> {
  DocumentReference? selectedCategoryRef;
  late CollectionReference categoriesCollection;

  Future<QuerySnapshot> getCategories() async {
    categoriesCollection = FirebaseFirestore.instance.collection('Catagories');
    return await categoriesCollection.get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: getCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No categories found'));
        }

        // 🔹 Extract categories list
        List<Map<String, dynamic>> categories = snapshot.data!.docs.map((doc) {
          return {
            'name': doc['catagoryName'],
            'reference': doc.reference, // 🔹 Use reference directly
          };
        }).toList();

        // 🔹 Set current value based on reference
        DocumentReference? dropdownValue;
        final categoryRefs = categories.map((c) => c['reference']).toList();

        if (categoryRefs.contains(widget.selectedRef)) {
          dropdownValue = widget.selectedRef;
        }

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xfffcf8ea),
            border: Border.all(color: const Color(0xfffc6e50)),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: DropdownButton<DocumentReference>(
            value: dropdownValue, // 🔹 reference-based value
            hint: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Please select a category'),
            ),
            isExpanded: true,
            icon: const SizedBox(),
            onChanged: (DocumentReference? newRef) {
              setState(() {
                widget.selectedRef = newRef;
                selectedCategoryRef = newRef;

                print("selectedCategoryRef: ${selectedCategoryRef?.path}");
              });
            },
            items: categories.map<DropdownMenuItem<DocumentReference>>(
              (Map<String, dynamic> category) {
                return DropdownMenuItem<DocumentReference>(
                  value: category['reference'], // 🔹 Use reference as value
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(category['name']),
                  ),
                );
              },
            ).toList(),
            underline: Container(),
          ),
        );
      },
    );
  }
}


class SubCatagoryListing extends StatefulWidget {
  SubCatagoryListing({
    super.key,
    this.width,
    this.height,
    this.selectedRef,
  });

  final double? width;
  final double? height;
  DocumentReference? selectedRef; // 🔹 change from id → reference

  @override
  State<SubCatagoryListing> createState() => _SubCatagoryListingState();
}

class _SubCatagoryListingState extends State<SubCatagoryListing> {
  DocumentReference? selectedCategoryRef;
  late CollectionReference categoriesCollection;

  Future<QuerySnapshot> getCategories() async {
    categoriesCollection = FirebaseFirestore.instance.collection('SubCatagories');
    return await categoriesCollection.get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: getCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No categories found'));
        }

        // 🔹 Extract categories list
        List<Map<String, dynamic>> categories = snapshot.data!.docs.map((doc) {
          return {
            'name': doc['name'],
            'reference': doc.reference, // 🔹 Use reference directly
          };
        }).toList();

        // 🔹 Set current value based on reference
        DocumentReference? dropdownValue;
        final categoryRefs = categories.map((c) => c['reference']).toList();

        if (categoryRefs.contains(widget.selectedRef)) {
          dropdownValue = widget.selectedRef;
        }

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xfffcf8ea),
            border: Border.all(color: const Color(0xfffc6e50)),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: DropdownButton<DocumentReference>(
            value: dropdownValue, // 🔹 reference-based value
            hint: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Please select a category'),
            ),
            isExpanded: true,
            icon: const SizedBox(),
            onChanged: (DocumentReference? newRef) {
              setState(() {
                widget.selectedRef = newRef;
                selectedCategoryRef = newRef;

                print("selectedCategoryRef: ${selectedCategoryRef?.path}");
              });
            },
            items: categories.map<DropdownMenuItem<DocumentReference>>(
              (Map<String, dynamic> category) {
                return DropdownMenuItem<DocumentReference>(
                  value: category['reference'], // 🔹 Use reference as value
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(category['name']),
                  ),
                );
              },
            ).toList(),
            underline: Container(),
          ),
        );
      },
    );
  }
}


class ListingDropDownWidget extends StatefulWidget {
  const ListingDropDownWidget({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<ListingDropDownWidget> createState() => _ListingDropDownWidgetState();
}

class _ListingDropDownWidgetState extends State<ListingDropDownWidget> {
  String? selectedCategoryName;
  String? selectedCategoryId;
  DocumentReference? selectedCategoryRef;
  DocumentReference? selectedSubCategoryRef;
  List<Map<String, dynamic>> subCategories = [];
  late CollectionReference categoriesCollection;
  String? selectedSubCategoryName;

  Future<QuerySnapshot> getCategories() async {
    categoriesCollection = FirebaseFirestore.instance.collection('Catagories');
    return await categoriesCollection.get();
  }

  getSubCategories(DocumentReference categoryRef) async {
    QuerySnapshot subCategorySnapshot = await FirebaseFirestore.instance
        .collection('SubCatagories')
        .where('catagoriesRef', isEqualTo: categoryRef)
        .get();

    setState(() {
      subCategories = subCategorySnapshot.docs.map((doc) {
        return {'id': doc.id, 'name': doc['name'], 'reference': doc.reference};
      }).toList();

      // Reset the sub-category selection if no sub-categories are found
      if (subCategories.isEmpty) {
        selectedSubCategoryName = null;
      }
    });

    print("Subcategories for category ${categoryRef.path}: $subCategories");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Category Dropdown
        FutureBuilder<QuerySnapshot>(
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

            List<Map<String, dynamic>> categories = snapshot.data!.docs.map(
              (doc) {
                return {
                  'id': doc.id,
                  'name': doc['catagoryName'], // Corrected category name field
                  'reference': doc.reference,
                };
              },
            ).toList();

            return Container(
              decoration: BoxDecoration(
                color: Color(0xfffcf8ea),
                border: Border.all(color: Color(0xfffc6e50)),
                borderRadius: BorderRadius.circular(8.0),
                
              ),
              height: 42,
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
                      onChanged: (String? newValue) async {
                        setState(() {
                          selectedCategoryName = newValue;

                          var selectedCategory = categories.firstWhere(
                            (category) => category['name'] == newValue,
                            orElse: () => categories.first,
                          );
                          selectedCategoryId = selectedCategory['id'];
                          selectedCategoryRef = selectedCategory['reference'];
                          // FFAppState().selectedListingCatagoryRef =
                          //     selectedCategoryRef;

                          // Reset sub-category selection when category changes
                          selectedSubCategoryName = null;
                        });
                        // Fetch subcategories when a category is selected
                        if (selectedCategoryRef != null) {
                          getSubCategories(selectedCategoryRef!);
                        }

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
        ),

        // Sub-Category Dropdown (only show if subCategories are available)
        if (selectedCategoryRef != null && subCategories.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xfffcf8ea),
                border: Border.all(color: Color(0xfffc6e50)),
                borderRadius: BorderRadius.circular(8.0),
              ),
              height: 42,
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: selectedSubCategoryName,
                      hint: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Please select a sub-category'),
                      ),
                      icon: SizedBox(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSubCategoryName = newValue;
                          var selectedSubCategory = subCategories.firstWhere(
                              (subCategory) => subCategory['name'] == newValue,
                              orElse: () => {'reference': null});

                          // Retrieve the reference
                          selectedSubCategoryRef =
                              selectedSubCategory['reference'];
                          // FFAppState().selectedSubCatagoryRef =
                          //     selectedSubCategoryRef;

                          // Optionally print or use the reference
                          print(
                              "Selected Sub-Category Reference: ${selectedSubCategoryRef?.path}");
                        });
                      },
                      items: subCategories.map<DropdownMenuItem<String>>(
                        (Map<String, dynamic> subCategory) {
                          return DropdownMenuItem<String>(
                            value: subCategory['name'],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                subCategory['name'],
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffFC6E50),
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      underline: Container(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (selectedCategoryRef != null && subCategories.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text('No sub-categories available for this category.'),
          ),
      
      ],
    );
  }
}