
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterflow_custom_widget/catagory_backup.dart';
import 'package:flutterflow_custom_widget/listing_drop_down.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  
      if (subCategories.isEmpty) {
        selectedSubCategoryName = null;
      }
    });

    print("Subcategories for category ${categoryRef.path}: $subCategories");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Categories")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
EditCatagoryListing(
  selectedRef: FirebaseFirestore.instance.doc("Catagories/BOyfabcseFHal0Gq0xI5"), // "Men's Wear"
  selectedRefSub: FirebaseFirestore.instance.doc("SubCatagories/3G5EEYp0NtFcS4TZLrx8"), // "Shirts"
)
         
  // EditCatagoryDropDown(  selectedRef: FirebaseFirestore.instance
  //     .doc('Catagories/BOyfabcseFHal0Gq0xI5'),),
            // FutureBuilder<QuerySnapshot>(
            //   future: getCategories(),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Center(child: CircularProgressIndicator());
            //     }

            //     if (snapshot.hasError) {
            //       return Center(child: Text('Error: ${snapshot.error}'));
            //     }

            //     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            //       return Center(child: Text('No categories found'));
            //     }

            //     List<Map<String, dynamic>> categories = snapshot.data!.docs.map(
            //       (doc) {
            //         return {
            //           'id': doc.id,
            //           'name': doc['catagoryName'], 
            //           'reference': doc.reference,
            //         };
            //       },
            //     ).toList();

            //     return Container(
            //       decoration: BoxDecoration(
            //         color: Color(0xfffcf8ea),
            //         border: Border.all(color: Color(0xfffc6e50)),
            //         borderRadius: BorderRadius.circular(8.0),
            //       ),
            //       child: Row(
            //         children: [
            //           Expanded(
            //             child: DropdownButton<String>(
            //               value: selectedCategoryName,
            //               hint: Padding(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: Text('Please select a category'),
            //               ),
            //               icon: SizedBox(),
            //               onChanged: (String? newValue) async {
            //                 setState(() {
            //                   selectedCategoryName = newValue;

            //                   var selectedCategory = categories.firstWhere(
            //                     (category) => category['name'] == newValue,
            //                     orElse: () => categories.first,
            //                   );
            //                   selectedCategoryId = selectedCategory['id'];
            //                   selectedCategoryRef =
            //                       selectedCategory['reference'];

            //                   selectedSubCategoryName = null;
            //                 });
                   
            //                 if (selectedCategoryRef != null) {
            //                   getSubCategories(selectedCategoryRef!);
            //                 }
            //               },
            //               items: categories.map<DropdownMenuItem<String>>((
            //                 Map<String, dynamic> category,
            //               ) {
            //                 return DropdownMenuItem<String>(
            //                   value: category['name'],
            //                   child: Padding(
            //                     padding: const EdgeInsets.all(8.0),
            //                     child: Text(category['name']),
            //                   ),
            //                 );
            //               }).toList(),
            //               underline: Container(),
            //             ),
            //           ),
            //         ],
            //       ),
            //     );
            //   },
            // ),

            
            // if (subCategories.isNotEmpty)
            //   Padding(
            //     padding: const EdgeInsets.only(top: 20),
            //     child: Container(
            //       decoration: BoxDecoration(
            //         color: Color(0xfffcf8ea),
            //         border: Border.all(color: Color(0xfffc6e50)),
            //         borderRadius: BorderRadius.circular(8.0),
            //       ),
            //       child: Row(
            //         children: [
            //           Expanded(
            //             child: DropdownButton<String>(
            //               value: selectedSubCategoryName,
            //               hint: Padding(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: Text('Please select a sub-category'),
            //               ),
            //               icon: SizedBox(),
            //               onChanged: (String? newValue) {
            //                 setState(() {
            //                   selectedSubCategoryName = newValue;
            //                   var selectedSubCategory = subCategories.firstWhere(
            //         (subCategory) => subCategory['name'] == newValue,
            //         orElse: () => {'reference': null}
            //       );
            //       selectedSubCategoryRef = selectedSubCategory['reference'];
            //       print("Selected Sub-Category Reference: ${selectedSubCategoryRef?.path}");
            //                 });
            //               },
            //               items: subCategories.map<DropdownMenuItem<String>>(
            //                 (Map<String, dynamic> subCategory) {
            //                   return DropdownMenuItem<String>(
            //                     value: subCategory['name'],
            //                     child: Padding(
            //                       padding: const EdgeInsets.all(8.0),
            //                       child: Text(subCategory['name']),
            //                     ),
            //                   );
            //                 },
            //               ).toList(),
            //               underline: Container(),
            //             ),
                    
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // if (subCategories.isEmpty)
            //   Padding(
            //     padding: const EdgeInsets.only(top: 20),
            //     child: Text('No sub-categories available for this category.'),
            //   ),
         
          ],
        ),
    
      ),
    );
  }
}


class EditCatagoryListing extends StatefulWidget {
   EditCatagoryListing({
    super.key,
    this.width,
    this.height,
    this.selectedRef,
    this.selectedRefSub,
  });

  final double? width;
  final double? height;
   DocumentReference? selectedRef;
  final DocumentReference? selectedRefSub;

  @override
  State<EditCatagoryListing> createState() => _EditCatagoryListingState();
}

class _EditCatagoryListingState extends State<EditCatagoryListing> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
CatagoryListingDropDown(
          selectedRef: widget.selectedRef,
          onCategoryChanged: (newRef) {
            setState(() {
              widget.selectedRef = newRef;
            });
          },
        ),
        SizedBox(
          height: 10.0,
        ),
        SubCatagoryListing(selectedRef: widget.selectedRefSub,parentCategoryRef: widget.selectedRef,),
      ],
    );
  }
}

class CatagoryListingDropDown extends StatefulWidget {
  CatagoryListingDropDown({
    super.key,
    this.width,
    this.height,
    this.selectedRef,
        required this.onCategoryChanged,
  });

  final double? width;
  final double? height;
  DocumentReference? selectedRef;
    final ValueChanged<DocumentReference?> onCategoryChanged;
   // 🔹 change from id → reference

  @override
  State<CatagoryListingDropDown> createState() =>
      _CatagoryListingDropDownState();
}

class _CatagoryListingDropDownState extends State<CatagoryListingDropDown> {
  DocumentReference? selectedCategoryRef;
  late CollectionReference categoriesCollection;

  @override
  void initState() {
    super.initState();
    // initialize with passed reference
    selectedCategoryRef = widget.selectedRef;
  }

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

        List<Map<String, dynamic>> categories = snapshot.data!.docs.map((doc) {
          return {
            'name': doc['catagoryName'],
            'reference': doc.reference,
          };
        }).toList();

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xfffcf8ea),
            border: Border.all(color: const Color(0xfffc6e50)),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: DropdownButton<DocumentReference>(
            value: selectedCategoryRef, // ✅ use local state value
            hint: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Please select a category'),
            ),
            isExpanded: true,
            icon: const SizedBox(),
            onChanged: (DocumentReference? newRef) {
              setState(() {
                selectedCategoryRef = newRef;
                print("selectedCategoryRef: ${selectedCategoryRef?.path}");
                // FFAppState().selectedListingCatagoryRef = selectedCategoryRef;
              });
            },
            items: categories.map<DropdownMenuItem<DocumentReference>>(
              (Map<String, dynamic> category) {
                return DropdownMenuItem<DocumentReference>(
                  value: category['reference'],
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
        this.parentCategoryRef,
  });

  final double? width;
  final double? height;
  DocumentReference? selectedRef; 
  DocumentReference? parentCategoryRef;
  // 🔹 change from id → reference

  @override
  State<SubCatagoryListing> createState() => _SubCatagoryListingState();
}

class _SubCatagoryListingState extends State<SubCatagoryListing> {
  DocumentReference? selectedSubCategoryRef;
  late CollectionReference categoriesCollection;

  @override
  void initState() {
    super.initState();
    // initialize with passed reference
    selectedSubCategoryRef = widget.selectedRef;
  }

Future<QuerySnapshot> getSubCategories() async {
  final collection = FirebaseFirestore.instance.collection('SubCatagories');

  if (widget.parentCategoryRef != null) {
    // ✅ Filter only subcategories belonging to selected category
    return await collection
        .where('catagoriesRef', isEqualTo: widget.parentCategoryRef)
        .get();
  } else {
    // No category selected yet
    return await collection.get();
  }
}
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: getSubCategories(),
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

        List<Map<String, dynamic>> categories = snapshot.data!.docs.map((doc) {
          return {
            'name': doc['name'],
            'reference': doc.reference,
          };
        }).toList();

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xfffcf8ea),
            border: Border.all(color: const Color(0xfffc6e50)),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: DropdownButton<DocumentReference>(
            value: selectedSubCategoryRef, // ✅ use local state value
            hint: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Please select a category'),
            ),
            isExpanded: true,
            icon: const SizedBox(),
            onChanged: (DocumentReference? newRef) {
              setState(() {
                selectedSubCategoryRef = newRef;
                print(
                    "selectedSubCategoryRef: ${selectedSubCategoryRef?.path}");
                // FFAppState().selectedistingSubCatagoryRef = selectedSubCategoryRef;
                // FFAppState().selectedSubCatagoryRef = selectedSubCategoryRef;
              });
            },
            items: categories.map<DropdownMenuItem<DocumentReference>>(
              (Map<String, dynamic> category) {
                return DropdownMenuItem<DocumentReference>(
                  value: category['reference'],
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