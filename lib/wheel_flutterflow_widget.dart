// // import 'dart:async';
// // import 'dart:math';
// // import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutterflow_custom_widget/demo_screen.dart';

// // import 'dart:async';
// // import 'dart:math';

// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/services.dart';

// // class WheelWidget extends StatefulWidget {
// //   const WheelWidget({
// //     super.key,
// //     this.width,
// //     this.height,
// //     this.selectedDoc,
// //     this.action,
// //   });

// //   final double? width;
// //   final double? height;
// //   final selectedDoc;
// //   final Future Function()? action;

// //   @override
// //   State<WheelWidget> createState() => _WheelWidgetState();
// // }

// // class _WheelWidgetState extends State<WheelWidget> {
// //   StreamController<int> controller = StreamController<int>.broadcast();

// //   late CollectionReference productsCollection;
// //   String? selectedValue;

// //   bool isLoadingProducts = true;

// //   var value;
// //   List<String> options = [];
// //   List<String> allProducts = [];
// //   List<String> selectedProduct =
// //       [];
// //   Map<String, bool> productCheckboxes = {};

// //   final List<Color> segmentColors = [
// //     Colors.cyan,
// //     Colors.pink,
// //     Colors.orange,
// //     Colors.deepPurple,
// //     Colors.red,
// //     Colors.green,
// //     Colors.amber,
// //     Colors.blue,
// //     Colors.teal,
// //     Colors.indigo,
// //     Colors.lime,
// //     Colors.deepOrange,
// //     Colors.lightBlue,
// //     Colors.lightGreen,
// //     Colors.purple,
// //     Colors.yellow,
// //     Colors.brown,
// //     Colors.blueGrey,
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadCategoriesOnce();
// //   }

// //   @override
// //   void dispose() {
// //     controller.close();
// //     super.dispose();
// //   }

// //   Future<void> _loadCategoriesOnce() async {
// //     productsCollection = FirebaseFirestore.instance.collection('Products');
// //     QuerySnapshot snapshot = await productsCollection.get();

// //     setState(() {
// //       options = snapshot.docs
// //           .map((doc) => doc['productName'].toString())
// //           .toList();
// //       isLoadingProducts = false;

// //       selectedProduct = options.take(10).toList();

// //       productCheckboxes = Map.fromIterable(
// //         selectedProduct,
// //         value: (v) => true,
// //       );
// //     });
// //   }

// //   Future<void> showCategorySelectionDialog() async {
// //     Map<String, bool> tempCheckboxes = Map.from(productCheckboxes);

// //     await showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return StatefulBuilder(
// //           builder: (context, setDialogState) {
// //             int selectedCount = tempCheckboxes.values
// //                 .where((v) => v == true)
// //                 .length;

// //             return AlertDialog(
// //               title: Text('Choose Products (${selectedCount}/10)'),
// //               content: Container(
// //                 height: 500,
// //                 width: double.maxFinite,
// //                 child: allProducts.isEmpty
// //                     ? const Center(child: CircularProgressIndicator())
// //                     : ListView.builder(
// //                         shrinkWrap: true,
// //                         itemCount: allProducts.length,
// //                         itemBuilder: (context, index) {
// //                           String category = allProducts[index];
// //                           bool isChecked = tempCheckboxes[category] ?? false;

// //                           return CheckboxListTile(
// //                             title: Text(category),
// //                             value: isChecked,
// //                             onChanged: (bool? value) {

// //                               if (value == true && selectedCount >= 10) {
// //                                 ScaffoldMessenger.of(context).showSnackBar(
// //                                   const SnackBar(
// //                                     content: Text(
// //                                       'You can select a maximum of 10 categories.',
// //                                     ),
// //                                     duration: Duration(seconds: 2),
// //                                   ),
// //                                 );
// //                                 return;
// //                               }
// //                               if (value == false && selectedCount <= 8) {
// //                                 ScaffoldMessenger.of(context).showSnackBar(
// //                                   const SnackBar(
// //                                     content: Text(
// //                                       'You must select at least 8 categories.',
// //                                     ),
// //                                     duration: Duration(seconds: 2),
// //                                   ),
// //                                 );
// //                                 return;
// //                               }

// //                               setDialogState(() {
// //                                 tempCheckboxes[category] = value ?? false;
// //                               });
// //                             },
// //                           );
// //                         },
// //                       ),
// //               ),
// //               actions: [
// //                 TextButton(
// //                   onPressed: () {
// //                     Navigator.of(context).pop();
// //                   },
// //                   child: const Text('Cancel'),
// //                 ),
// //                 ElevatedButton(
// //                   onPressed: () {
// //                     setState(() {
// //                       productCheckboxes = tempCheckboxes;
// //                       selectedProduct = productCheckboxes.entries
// //                           .where((entry) => entry.value == true)
// //                           .map((entry) => entry.key)
// //                           .toList();
// //                     });

// //                     print('Selected Products: $selectedProduct');
// //                     Navigator.of(context).pop();
// //                   },
// //                   child: const Text('Update'),
// //                 ),
// //               ],
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }

// //   int? selectedIndex;
// //   DocumentReference? selectedCategoryRef;

// //   Future<void> fetchSelectedCategoryDocument(String categoryName) async {
// //     try {
// //       print("Fetching document for category: $categoryName");

// //       QuerySnapshot categorySnapshot = await FirebaseFirestore.instance
// //           .collection('Products')
// //           .where('productName', isEqualTo: categoryName)
// //           .limit(1)
// //           .get();

// //       if (categorySnapshot.docs.isNotEmpty) {
// //         DocumentSnapshot doc = categorySnapshot.docs.first;

// //         // selectedCategoryRecord = CatagoriesRecord.fromSnapshot(doc);
// //         selectedCategoryRef = doc.reference;

// //         print("✅ Category Document Found!");
// //         print("Document ID: ${doc.id}");
// //         print("Document Reference: ${selectedCategoryRef!.path}");
// //         // print("Category Name: ${selectedCategoryRecord!.catagoryName}");

// //         // await widget.selectedDoc?.call(selectedCategoryRecord);

// //         // context.pushNamed(
// //         //   "EventsEntertainmentScreenCopy",
// //         //   extra: <String, dynamic>{
// //         //     "catagories": selectedCategoryRecord,
// //         //   },
// //         // );
// //       } else {
// //         print("❌ Category document not found: $categoryName");
// //         // selectedCategoryRecord = null;
// //         selectedCategoryRef = null;
// //       }
// //     } catch (e) {
// //       print("❌ Error fetching category document: $e");
// //       // selectedCategoryRecord = null;
// //       selectedCategoryRef = null;
// //     }
// //   }

// //   bool isSpinning = false;

// //   @override
// //   Widget build(BuildContext context) {
// //     List<String> wheelCategories = selectedProduct.isEmpty
// //         ? options
// //         : selectedProduct;

// //     return Column(
// //       children: [
// //         Expanded(
// //           child: Center(
// //             child: isLoadingProducts
// //                 ? const CircularProgressIndicator()
// //                 : options.isEmpty
// //                 ? const Text(
// //                     'No products found.',
// //                     style: TextStyle(color: Colors.white),
// //                   )
// //                 : Stack(
// //                     alignment: Alignment.center,
// //                     children: [
// //                       Container(
// //                         height: 1000,
// //                         width: 900,
// //                         decoration: BoxDecoration(
// //                           color: Colors.amber,
// //                           shape: BoxShape.circle,
// //                         ),
// //                         child: Container(
// //                           decoration: const BoxDecoration(
// //                             shape: BoxShape.circle,
// //                             color: Color(0xFF101F3C),
// //                           ),
// //                           child: Padding(
// //                             padding: const EdgeInsets.all(20),
// //                             child: FortuneWheel(
// //                               onAnimationEnd: () async {
// //                                 print(
// //                                   "Wheel stopped. Selected value: $selectedValue",
// //                                 );
// //                                 if (selectedValue != null && !isSpinning) {
// //                                   return;
// //                                 }

// //                                 if (selectedValue != null) {
// //                                   await fetchSelectedCategoryDocument(
// //                                     selectedValue!,
// //                                   );
// //                                 }

// //                                 setState(() {
// //                                   isSpinning = false;
// //                                 });
// //                               },
// //                               selected: controller.stream,
// //                               hapticImpact: HapticImpact.heavy,
// //                               indicators: const <FortuneIndicator>[
// //                                 FortuneIndicator(
// //                                   alignment: Alignment.topCenter,
// //                                   child: TriangleIndicator(
// //                                     color: Colors.yellow,
// //                                   ),
// //                                 ),
// //                               ],
// //                               items: [
// //                                 for (
// //                                   int i = 0;
// //                                   i < wheelCategories.length && i < 10;
// //                                   i++
// //                                 )
// //                                   FortuneItem(
// //                                     child: Text(
// //                                       wheelCategories[i],
// //                                       style: const TextStyle(
// //                                         color: Colors.white,
// //                                       ),
// //                                     ),
// //                                     style: FortuneItemStyle(
// //                                       color:
// //                                           segmentColors[i %
// //                                               segmentColors.length],
// //                                       borderColor: Colors.white,
// //                                       borderWidth: 1,
// //                                     ),
// //                                   ),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                       Positioned(
// //                         child: GestureDetector(
// //                           onTap: () async {
// //                             if (isSpinning || wheelCategories.isEmpty) return;

// //                             setState(() {
// //                               isSpinning = true;
// //                             });

// //                             final selected = Random().nextInt(
// //                               wheelCategories.length,
// //                             );
// //                             selectedValue = wheelCategories[selected];
// //                             controller.add(selected);

// //                             print("Wheel spinning to: $selectedValue");
// //                           },
// //                           child: Container(
// //                             height: 80,
// //                             width: 80,
// //                             decoration: const BoxDecoration(
// //                               shape: BoxShape.circle,
// //                               color: Colors.blueAccent,
// //                               boxShadow: [
// //                                 BoxShadow(
// //                                   color: Colors.black38,
// //                                   blurRadius: 10,
// //                                   offset: Offset(0, 4),
// //                                 ),
// //                               ],
// //                             ),
// //                             child: Center(
// //                               child: Text(
// //                                 'SPIN',
// //                                 style: const TextStyle(
// //                                   color: Colors.white,
// //                                   fontWeight: FontWeight.bold,
// //                                   fontSize: 16,
// //                                   letterSpacing: 1.2,
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //           ),
// //         ),
// //         Padding(
// //           padding: const EdgeInsets.all(20.0),
// //           child: Column(
// //             children: [
// //               if (selectedProduct.isNotEmpty)
// //                 Text(
// //                   'Showing ${selectedProduct.length} selected catagories',
// //                   style: const TextStyle(color: Colors.white, fontSize: 16),
// //                 ),
// //               const SizedBox(height: 10),
// //               ElevatedButton(
// //                 onPressed: () {
// //                   if (allProducts.isEmpty) {
// //                     loadCategories().then((_) {
// //                       showCategorySelectionDialog();
// //                     });
// //                   } else {
// //                     showCategorySelectionDialog();
// //                   }
// //                 },
// //                 child: Text(
// //                   selectedProduct.isEmpty
// //                       ? 'Choose Catagories'
// //                       : 'Edit Catagories',
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Future<void> loadCategories() async {

// //     QuerySnapshot snapshot = await FirebaseFirestore.instance
// //         .collection('Catagories')
// //         .get();
// //     allProducts = snapshot.docs
// //         .map((doc) => doc['catagoryName'].toString())
// //         .toList();
// //   }
// // }
// import 'dart:async';
// import 'dart:math';
// import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class WheelWidget extends StatefulWidget {
//   const WheelWidget({
//     super.key,
//     this.width,
//     this.height,
//     this.selectedDoc,
//     this.action,
//   });

//   final double? width;
//   final double? height;
//   final selectedDoc;
//   final Future Function()? action;

//   @override
//   State<WheelWidget> createState() => _WheelWidgetState();
// }

// class _WheelWidgetState extends State<WheelWidget> {
//   StreamController<int> controller = StreamController<int>.broadcast();

//   // Categories data
//   List<String> allCategories = [];
//   List<String> selectedCategories = [];
//   Map<String, bool> categoryCheckboxes = {};
//   Map<String, DocumentReference> categoryRefs = {}; // Store category references

//   // Subcategories data
//   List<String> allSubcategories = [];
//   List<String> selectedSubcategories = [];
//   Map<String, bool> subcategoryCheckboxes = {};
//   Map<String, DocumentReference> subcategoryRefs = {}; // Store subcategory references

//   // Products data
//   List<String> allProducts = [];
//   List<String> wheelProducts = [];

//   bool isLoadingProducts = true;
//   bool isSpinning = false;
//   String? selectedValue;

//   final List<Color> segmentColors = [
//     Colors.cyan,
//     Colors.pink,
//     Colors.orange,
//     Colors.deepPurple,
//     Colors.red,
//     Colors.green,
//     Colors.amber,
//     Colors.blue,
//     Colors.teal,
//     Colors.indigo,
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadInitialData();
//   }

//   @override
//   void dispose() {
//     controller.close();
//     super.dispose();
//   }

//   // Initial data load
//   Future<void> _loadInitialData() async {
//     setState(() {
//       isLoadingProducts = true;
//     });

//     // Load all products by default
//     QuerySnapshot productsSnapshot = await FirebaseFirestore.instance
//         .collection('Products')
//         .limit(10)
//         .get();

//     setState(() {
//       wheelProducts = productsSnapshot.docs
//           .map((doc) => doc['productName'].toString())
//           .toList();
//       isLoadingProducts = false;
//     });
//   }

//   // Load categories from Firestore
//   Future<void> loadCategories() async {
//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('Catagories')
//         .get();

//     setState(() {
//       allCategories = snapshot.docs
//           .map((doc) => doc['catagoryName'].toString())
//           .toList();

//       // Store category references
//       for (var doc in snapshot.docs) {
//         categoryRefs[doc['catagoryName'].toString()] = doc.reference;
//       }

//       categoryCheckboxes = Map.fromIterable(
//         allCategories,
//         value: (v) => selectedCategories.contains(v),
//       );
//     });
//   }

//   // Load subcategories based on selected categories
//   Future<void> loadSubcategories() async {
//     if (selectedCategories.isEmpty) {
//       setState(() {
//         allSubcategories = [];
//         subcategoryCheckboxes = {};
//       });
//       return;
//     }

//     // Get references of selected categories
//     List<DocumentReference> selectedCategoryRefs = selectedCategories
//         .map((categoryName) => categoryRefs[categoryName])
//         .whereType<DocumentReference>()
//         .toList();

//     if (selectedCategoryRefs.isEmpty) {
//       setState(() {
//         allSubcategories = [];
//         subcategoryCheckboxes = {};
//       });
//       return;
//     }

//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('SubCatagories')
//         .where('catagoriesRef', whereIn: selectedCategoryRefs)
//         .get();

//     setState(() {
//       allSubcategories = snapshot.docs
//           .map((doc) => doc['name'].toString())
//           .toList();

//       // Store subcategory references
//       for (var doc in snapshot.docs) {
//         subcategoryRefs[doc['name'].toString()] = doc.reference;
//       }

//       subcategoryCheckboxes = Map.fromIterable(
//         allSubcategories,
//         value: (v) => selectedSubcategories.contains(v),
//       );
//     });
//   }

//   // Load products based on selected subcategories
//   Future<void> loadProducts() async {
//     if (selectedSubcategories.isEmpty && selectedCategories.isEmpty) {
//       // If no filters selected, load default products
//       await _loadInitialData();
//       return;
//     }

//     Query query = FirebaseFirestore.instance.collection('Products');

//     // If subcategories are selected, filter by subcategory references
//     if (selectedSubcategories.isNotEmpty) {
//       List<DocumentReference> selectedSubcategoryRefs = selectedSubcategories
//           .map((subcategoryName) => subcategoryRefs[subcategoryName])
//           .whereType<DocumentReference>()
//           .toList();

//       if (selectedSubcategoryRefs.isNotEmpty) {
//         query = query.where('subCatagoryRef', whereIn: selectedSubcategoryRefs);
//       }
//     }
//     // If only categories are selected (no subcategories), filter by category references
//     else if (selectedCategories.isNotEmpty) {
//       List<DocumentReference> selectedCategoryRefs = selectedCategories
//           .map((categoryName) => categoryRefs[categoryName])
//           .whereType<DocumentReference>()
//           .toList();

//       if (selectedCategoryRefs.isNotEmpty) {
//         query = query.where('catagoryRef', whereIn: selectedCategoryRefs);
//       }
//     }

//     QuerySnapshot snapshot = await query.limit(10).get();

//     setState(() {
//       wheelProducts = snapshot.docs
//           .map((doc) => doc['productName'].toString())
//           .toList();
//     });
//   }

//   // Category Selection Dialog
//   Future<void> showCategorySelectionDialog() async {
//     if (allCategories.isEmpty) {
//       await loadCategories();
//     }

//     Map<String, bool> tempCheckboxes = Map.from(categoryCheckboxes);

//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             int selectedCount = tempCheckboxes.values.where((v) => v == true).length;

//             return AlertDialog(
//               title: Text('Choose Categories ($selectedCount)'),
//               content: Container(
//                 height: 500,
//                 width: double.maxFinite,
//                 child: allCategories.isEmpty
//                     ? const Center(child: CircularProgressIndicator())
//                     : ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: allCategories.length,
//                         itemBuilder: (context, index) {
//                           String category = allCategories[index];
//                           bool isChecked = tempCheckboxes[category] ?? false;

//                           return CheckboxListTile(
//                             title: Text(category),
//                             value: isChecked,
//                             onChanged: (bool? value) {
//                               setDialogState(() {
//                                 tempCheckboxes[category] = value ?? false;
//                               });
//                             },
//                           );
//                         },
//                       ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('Cancel'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     setState(() {
//                       categoryCheckboxes = tempCheckboxes;
//                       selectedCategories = categoryCheckboxes.entries
//                           .where((entry) => entry.value == true)
//                           .map((entry) => entry.key)
//                           .toList();

//                       // Reset subcategories when categories change
//                       selectedSubcategories = [];
//                       allSubcategories = [];
//                     });

//                     Navigator.of(context).pop();

//                     // Load subcategories for selected categories
//                     if (selectedCategories.isNotEmpty) {
//                       await loadSubcategories();
//                       await showSubcategorySelectionDialog();
//                     } else {
//                       await _loadInitialData();
//                     }
//                   },
//                   child: const Text('Next'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   // Subcategory Selection Dialog
//   Future<void> showSubcategorySelectionDialog() async {
//     if (allSubcategories.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('No subcategories found for selected categories.'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//       return;
//     }

//     Map<String, bool> tempCheckboxes = Map.from(subcategoryCheckboxes);

//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             int selectedCount = tempCheckboxes.values.where((v) => v == true).length;

//             return AlertDialog(
//               title: Text('Choose Subcategories ($selectedCount/10)'),
//               content: Container(
//                 height: 500,
//                 width: double.maxFinite,
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: allSubcategories.length,
//                   itemBuilder: (context, index) {
//                     String subcategory = allSubcategories[index];
//                     bool isChecked = tempCheckboxes[subcategory] ?? false;

//                     return CheckboxListTile(
//                       title: Text(subcategory),
//                       value: isChecked,
//                       onChanged: (bool? value) {
//                         if (value == true && selectedCount >= 10) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('You can select maximum 10 subcategories.'),
//                               duration: Duration(seconds: 2),
//                             ),
//                           );
//                           return;
//                         }

//                         setDialogState(() {
//                           tempCheckboxes[subcategory] = value ?? false;
//                         });
//                       },
//                     );
//                   },
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('Back'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     setState(() {
//                       subcategoryCheckboxes = tempCheckboxes;
//                       selectedSubcategories = subcategoryCheckboxes.entries
//                           .where((entry) => entry.value == true)
//                           .map((entry) => entry.key)
//                           .toList();
//                     });

//                     Navigator.of(context).pop();

//                     // Load products based on selected subcategories
//                     await loadProducts();
//                   },
//                   child: const Text('Update Wheel'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   Future<void> fetchSelectedProductDocument(String productName) async {
//     try {
//       print("Fetching document for product: $productName");

//       QuerySnapshot productSnapshot = await FirebaseFirestore.instance
//           .collection('Products')
//           .where('productName', isEqualTo: productName)
//           .limit(1)
//           .get();

//       if (productSnapshot.docs.isNotEmpty) {
//         DocumentSnapshot doc = productSnapshot.docs.first;
//         print("✅ Product Document Found!");
//         print("Document ID: ${doc.id}");

//         // Call your action here
//         // await widget.action?.call();
//       } else {
//         print("❌ Product document not found: $productName");
//       }
//     } catch (e) {
//       print("❌ Error fetching product document: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: Center(
//             child: isLoadingProducts
//                 ? const CircularProgressIndicator()
//                 : wheelProducts.isEmpty
//                     ? const Text(
//                         'No products found.',
//                         style: TextStyle(color: Colors.white),
//                       )
//                     : Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           Container(
//                             height: 1000,
//                             width: 900,
//                             decoration: BoxDecoration(
//                               color: Colors.amber,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Container(
//                               decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Color(0xFF101F3C),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(20),
//                                 child: FortuneWheel(
//                                   onAnimationEnd: () async {
//                                     print("Wheel stopped. Selected value: $selectedValue");

//                                     if (selectedValue != null) {
//                                       await fetchSelectedProductDocument(selectedValue!);
//                                     }

//                                     setState(() {
//                                       isSpinning = false;
//                                     });
//                                   },
//                                   selected: controller.stream,
//                                   hapticImpact: HapticImpact.heavy,
//                                   indicators: const <FortuneIndicator>[
//                                     FortuneIndicator(
//                                       alignment: Alignment.topCenter,
//                                       child: TriangleIndicator(
//                                         color: Colors.yellow,
//                                       ),
//                                     ),
//                                   ],
//                                   items: [
//                                     for (int i = 0; i < wheelProducts.length && i < 10; i++)
//                                       FortuneItem(
//                                         child: Text(
//                                           wheelProducts[i],
//                                           style: const TextStyle(
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                         style: FortuneItemStyle(
//                                           color: segmentColors[i % segmentColors.length],
//                                           borderColor: Colors.white,
//                                           borderWidth: 1,
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             child: GestureDetector(
//                               onTap: () async {
//                                 if (isSpinning || wheelProducts.isEmpty) return;

//                                 setState(() {
//                                   isSpinning = true;
//                                 });

//                                 final selected = Random().nextInt(wheelProducts.length);
//                                 selectedValue = wheelProducts[selected];
//                                 controller.add(selected);

//                                 print("Wheel spinning to: $selectedValue");
//                               },
//                               child: Container(
//                                 height: 80,
//                                 width: 80,
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Colors.blueAccent,
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black38,
//                                       blurRadius: 10,
//                                       offset: Offset(0, 4),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     'SPIN',
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                       letterSpacing: 1.2,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               if (selectedCategories.isNotEmpty)
//                 Text(
//                   'Categories: ${selectedCategories.length} selected',
//                   style: const TextStyle(color: Colors.white, fontSize: 14),
//                 ),
//               if (selectedSubcategories.isNotEmpty)
//                 Text(
//                   'Subcategories: ${selectedSubcategories.length} selected',
//                   style: const TextStyle(color: Colors.white, fontSize: 14),
//                 ),
//               if (wheelProducts.isNotEmpty)
//                 Text(
//                   'Showing ${wheelProducts.length} products on wheel',
//                   style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () async {
//                   await showCategorySelectionDialog();
//                 },
//                 child: Text(
//                   selectedCategories.isEmpty
//                       ? 'Select Categories & Subcategories'
//                       : 'Edit Filters',
//                 ),
//               ),
//               if (selectedCategories.isNotEmpty || selectedSubcategories.isNotEmpty)
//                 TextButton(
//                   onPressed: () async {
//                     setState(() {
//                       selectedCategories = [];
//                       selectedSubcategories = [];
//                       categoryCheckboxes = {};
//                       subcategoryCheckboxes = {};
//                     });
//                     await _loadInitialData();
//                   },
//                   child: const Text('Clear All Filters'),
//                 ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// import 'dart:async';
// import 'dart:math';
// import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class WheelWidget extends StatefulWidget {
//   const WheelWidget({
//     super.key,
//     this.width,
//     this.height,
//     this.selectedDoc,
//     this.action,
//   });

//   final double? width;
//   final double? height;
//   final selectedDoc;
//   final Future Function()? action;

//   @override
//   State<WheelWidget> createState() => _WheelWidgetState();
// }

// class _WheelWidgetState extends State<WheelWidget> {
//   StreamController<int> controller = StreamController<int>.broadcast();

//   // Categories data
//   List<String> allCategories = [];
//   List<String> selectedCategories = [];
//   Map<String, bool> categoryCheckboxes = {};
//   Map<String, DocumentReference> categoryRefs = {}; // Store category references

//   // Subcategories data
//   List<String> allSubcategories = [];
//   List<String> selectedSubcategories = [];
//   Map<String, bool> subcategoryCheckboxes = {};
//   Map<String, DocumentReference> subcategoryRefs = {}; // Store subcategory references

//   // Products data
//   List<String> allProducts = [];
//   List<String> wheelProducts = [];

//   bool isLoadingProducts = true;
//   bool isSpinning = false;
//   String? selectedValue;

//   final List<Color> segmentColors = [
//     Colors.cyan,
//     Colors.pink,
//     Colors.orange,
//     Colors.deepPurple,
//     Colors.red,
//     Colors.green,
//     Colors.amber,
//     Colors.blue,
//     Colors.teal,
//     Colors.indigo,
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadInitialData();
//   }

//   @override
//   void dispose() {
//     controller.close();
//     super.dispose();
//   }

//   // Initial data load
//   Future<void> _loadInitialData() async {
//     setState(() {
//       isLoadingProducts = true;
//     });

//     // Load all products by default
//     QuerySnapshot productsSnapshot = await FirebaseFirestore.instance
//         .collection('Products')
//         .limit(10)
//         .get();

//     setState(() {
//       wheelProducts = productsSnapshot.docs
//           .map((doc) => doc['productName'].toString())
//           .toList();
//       isLoadingProducts = false;
//     });
//   }

//   // Load categories from Firestore
//   Future<void> loadCategories() async {
//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('Catagories')
//         .get();

//     setState(() {
//       allCategories = snapshot.docs
//           .map((doc) => doc['catagoryName'].toString())
//           .toList();

//       // Store category references
//       for (var doc in snapshot.docs) {
//         categoryRefs[doc['catagoryName'].toString()] = doc.reference;
//       }

//       categoryCheckboxes = Map.fromIterable(
//         allCategories,
//         value: (v) => selectedCategories.contains(v),
//       );
//     });
//   }

//   // Load subcategories based on selected categories
//   Future<void> loadSubcategories() async {
//     if (selectedCategories.isEmpty) {
//       setState(() {
//         allSubcategories = [];
//         subcategoryCheckboxes = {};
//       });
//       return;
//     }

//     // Get references of selected categories
//     List<DocumentReference> selectedCategoryRefs = selectedCategories
//         .map((categoryName) => categoryRefs[categoryName])
//         .whereType<DocumentReference>()
//         .toList();

//     if (selectedCategoryRefs.isEmpty) {
//       setState(() {
//         allSubcategories = [];
//         subcategoryCheckboxes = {};
//       });
//       return;
//     }

//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('SubCatagories')
//         .where('catagoriesRef', whereIn: selectedCategoryRefs)
//         .get();

//     setState(() {
//       allSubcategories = snapshot.docs
//           .map((doc) => doc['name'].toString())
//           .toList();

//       // Store subcategory references
//       for (var doc in snapshot.docs) {
//         subcategoryRefs[doc['name'].toString()] = doc.reference;
//       }

//       subcategoryCheckboxes = Map.fromIterable(
//         allSubcategories,
//         value: (v) => selectedSubcategories.contains(v),
//       );
//     });
//   }

//   // Load products based on selected subcategories
//   Future<void> loadProducts() async {
//     if (selectedSubcategories.isEmpty && selectedCategories.isEmpty) {
//       // If no filters selected, load default products
//       await _loadInitialData();
//       return;
//     }

//     Query query = FirebaseFirestore.instance.collection('Products');

//     // If subcategories are selected, filter by subcategory references
//     if (selectedSubcategories.isNotEmpty) {
//       List<DocumentReference> selectedSubcategoryRefs = selectedSubcategories
//           .map((subcategoryName) => subcategoryRefs[subcategoryName])
//           .whereType<DocumentReference>()
//           .toList();

//       if (selectedSubcategoryRefs.isNotEmpty) {
//         query = query.where('subCatagoryRef', whereIn: selectedSubcategoryRefs);
//       }
//     }
//     // If only categories are selected (no subcategories), filter by category references
//     else if (selectedCategories.isNotEmpty) {
//       List<DocumentReference> selectedCategoryRefs = selectedCategories
//           .map((categoryName) => categoryRefs[categoryName])
//           .whereType<DocumentReference>()
//           .toList();

//       if (selectedCategoryRefs.isNotEmpty) {
//         query = query.where('catagoryRef', whereIn: selectedCategoryRefs);
//       }
//     }

//     QuerySnapshot snapshot = await query.limit(10).get();

//     setState(() {
//       wheelProducts = snapshot.docs
//           .map((doc) => doc['productName'].toString())
//           .toList();
//     });
//   }

//   // Category Selection Dialog
//   Future<void> showCategorySelectionDialog() async {
//     if (allCategories.isEmpty) {
//       await loadCategories();
//     }

//     // Update checkboxes to reflect currently selected categories
//     for (var category in allCategories) {
//       if (!categoryCheckboxes.containsKey(category)) {
//         categoryCheckboxes[category] = selectedCategories.contains(category);
//       }
//     }

//     Map<String, bool> tempCheckboxes = Map.from(categoryCheckboxes);

//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             int selectedCount = tempCheckboxes.values.where((v) => v == true).length;

//             return AlertDialog(
//               title: Text('Choose Categories ($selectedCount)'),
//               content: Container(
//                 height: 500,
//                 width: double.maxFinite,
//                 child: allCategories.isEmpty
//                     ? const Center(child: CircularProgressIndicator())
//                     : ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: allCategories.length,
//                         itemBuilder: (context, index) {
//                           String category = allCategories[index];
//                           bool isChecked = tempCheckboxes[category] ?? false;

//                           return CheckboxListTile(
//                             title: Text(category),
//                             value: isChecked,
//                             onChanged: (bool? value) {
//                               setDialogState(() {
//                                 tempCheckboxes[category] = value ?? false;
//                               });
//                             },
//                           );
//                         },
//                       ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('Cancel'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     int selectedCount = tempCheckboxes.values.where((v) => v == true).length;

//                     if (selectedCount == 0) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Please select at least one category.'),
//                           duration: Duration(seconds: 2),
//                         ),
//                       );
//                       return;
//                     }

//                     setState(() {
//                       categoryCheckboxes = tempCheckboxes;
//                       selectedCategories = categoryCheckboxes.entries
//                           .where((entry) => entry.value == true)
//                           .map((entry) => entry.key)
//                           .toList();

//                       // Don't reset subcategories, just reload them
//                       allSubcategories = [];
//                     });

//                     Navigator.of(context).pop();

//                     // Load subcategories for selected categories
//                     await loadSubcategories();

//                     if (allSubcategories.isNotEmpty) {
//                       await showSubcategorySelectionDialog();
//                     } else {
//                       // If no subcategories, load products by categories
//                       await loadProducts();
//                     }
//                   },
//                   child: const Text('Next'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   // Subcategory Selection Dialog
//   Future<void> showSubcategorySelectionDialog() async {
//     if (allSubcategories.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('No subcategories found for selected categories.'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//       return;
//     }

//     // Update checkboxes to reflect currently selected subcategories
//     for (var subcategory in allSubcategories) {
//       if (!subcategoryCheckboxes.containsKey(subcategory)) {
//         subcategoryCheckboxes[subcategory] = selectedSubcategories.contains(subcategory);
//       }
//     }

//     Map<String, bool> tempCheckboxes = Map.from(subcategoryCheckboxes);

//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             int selectedCount = tempCheckboxes.values.where((v) => v == true).length;

//             return AlertDialog(
//               title: Text('Choose Subcategories ($selectedCount/10)'),
//               content: Container(
//                 height: 500,
//                 width: double.maxFinite,
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: allSubcategories.length,
//                   itemBuilder: (context, index) {
//                     String subcategory = allSubcategories[index];
//                     bool isChecked = tempCheckboxes[subcategory] ?? false;

//                     return CheckboxListTile(
//                       title: Text(subcategory),
//                       value: isChecked,
//                       onChanged: (bool? value) {
//                         if (value == true && selectedCount >= 10) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('You can select maximum 10 subcategories.'),
//                               duration: Duration(seconds: 2),
//                             ),
//                           );
//                           return;
//                         }

//                         setDialogState(() {
//                           tempCheckboxes[subcategory] = value ?? false;
//                         });
//                       },
//                     );
//                   },
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     // Go back to category selection
//                     showCategorySelectionDialog();
//                   },
//                   child: const Text('Back'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     int selectedCount = tempCheckboxes.values.where((v) => v == true).length;

//                     if (selectedCount == 0) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Please select at least one subcategory.'),
//                           duration: Duration(seconds: 2),
//                         ),
//                       );
//                       return;
//                     }

//                     setState(() {
//                       subcategoryCheckboxes = tempCheckboxes;
//                       selectedSubcategories = subcategoryCheckboxes.entries
//                           .where((entry) => entry.value == true)
//                           .map((entry) => entry.key)
//                           .toList();
//                     });

//                     Navigator.of(context).pop();

//                     // Load products based on selected subcategories
//                     await loadProducts();
//                   },
//                   child: const Text('Update Wheel'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   Future<void> fetchSelectedProductDocument(String productName) async {
//     try {
//       print("Fetching document for product: $productName");

//       QuerySnapshot productSnapshot = await FirebaseFirestore.instance
//           .collection('Products')
//           .where('productName', isEqualTo: productName)
//           .limit(1)
//           .get();

//       if (productSnapshot.docs.isNotEmpty) {
//         DocumentSnapshot doc = productSnapshot.docs.first;
//         print("✅ Product Document Found!");
//         print("Document ID: ${doc.id}");

//         // Call your action here
//         // await widget.action?.call();
//       } else {
//         print("❌ Product document not found: $productName");
//       }
//     } catch (e) {
//       print("❌ Error fetching product document: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: Center(
//             child: isLoadingProducts
//                 ? const CircularProgressIndicator()
//                 : wheelProducts.isEmpty
//                     ? const Text(
//                         'No products found.',
//                         style: TextStyle(color: Colors.white),
//                       )
//                     : Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           Container(
//                             height: 1000,
//                             width: 900,
//                             decoration: BoxDecoration(
//                               color: Colors.amber,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Container(
//                               decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Color(0xFF101F3C),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(20),
//                                 child: FortuneWheel(
//                                   onAnimationEnd: () async {
//                                     print("Wheel stopped. Selected value: $selectedValue");

//                                     if (selectedValue != null) {
//                                       await fetchSelectedProductDocument(selectedValue!);
//                                     }

//                                     setState(() {
//                                       isSpinning = false;
//                                     });
//                                   },
//                                   selected: controller.stream,
//                                   hapticImpact: HapticImpact.heavy,
//                                   indicators: const <FortuneIndicator>[
//                                     FortuneIndicator(
//                                       alignment: Alignment.topCenter,
//                                       child: TriangleIndicator(
//                                         color: Colors.yellow,
//                                       ),
//                                     ),
//                                   ],
//                                   items: [
//                                     for (int i = 0; i < wheelProducts.length && i < 10; i++)
//                                       FortuneItem(
//                                         child: Text(
//                                           wheelProducts[i],
//                                           style: const TextStyle(
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                         style: FortuneItemStyle(
//                                           color: segmentColors[i % segmentColors.length],
//                                           borderColor: Colors.white,
//                                           borderWidth: 1,
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             child: GestureDetector(
//                               onTap: () async {
//                                 if (isSpinning || wheelProducts.isEmpty) return;

//                                 setState(() {
//                                   isSpinning = true;
//                                 });

//                                 final selected = Random().nextInt(wheelProducts.length);
//                                 selectedValue = wheelProducts[selected];
//                                 controller.add(selected);

//                                 print("Wheel spinning to: $selectedValue");
//                               },
//                               child: Container(
//                                 height: 80,
//                                 width: 80,
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Colors.blueAccent,
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black38,
//                                       blurRadius: 10,
//                                       offset: Offset(0, 4),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     'SPIN',
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                       letterSpacing: 1.2,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               if (selectedCategories.isNotEmpty)
//                 Text(
//                   'Categories: ${selectedCategories.length} selected',
//                   style: const TextStyle(color: Colors.white, fontSize: 14),
//                 ),
//               if (selectedSubcategories.isNotEmpty)
//                 Text(
//                   'Subcategories: ${selectedSubcategories.length} selected',
//                   style: const TextStyle(color: Colors.white, fontSize: 14),
//                 ),
//               if (wheelProducts.isNotEmpty)
//                 Text(
//                   'Showing ${wheelProducts.length} products on wheel',
//                   style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () async {
//                   await showCategorySelectionDialog();
//                 },
//                 child: Text(
//                   selectedCategories.isEmpty
//                       ? 'Select Categories & Subcategories'
//                       : 'Edit Filters',
//                 ),
//               ),
//               if (selectedCategories.isNotEmpty || selectedSubcategories.isNotEmpty)
//                 TextButton(
//                   onPressed: () async {
//                     setState(() {
//                       selectedCategories = [];
//                       selectedSubcategories = [];
//                       categoryCheckboxes = {};
//                       subcategoryCheckboxes = {};
//                     });
//                     await _loadInitialData();
//                   },
//                   child: const Text('Clear All Filters'),
//                 ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:async';
import 'dart:math';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WheelWidget extends StatefulWidget {
  const WheelWidget({
    super.key,
    this.width,
    this.height,
    this.selectedDoc,
    this.action,
  });

  final double? width;
  final double? height;
  final selectedDoc;
  final Future Function()? action;

  @override
  State<WheelWidget> createState() => _WheelWidgetState();
}

class _WheelWidgetState extends State<WheelWidget> {
  StreamController<int> controller = StreamController<int>.broadcast();

  // Categories data
  List<String> allCategories = [];
  List<String> selectedCategories = [];
  Map<String, bool> categoryCheckboxes = {};
  Map<String, DocumentReference> categoryRefs = {}; // Store category references

  // Subcategories data
  List<String> allSubcategories = [];
  List<String> selectedSubcategories = [];
  Map<String, bool> subcategoryCheckboxes = {};
  Map<String, DocumentReference> subcategoryRefs =
      {}; // Store subcategory references

  // Products data
  List<String> allProducts = [];
  List<String> wheelProducts = [];

  bool isLoadingProducts = true;
  bool isSpinning = false;
  String? selectedValue;

  final List<Color> segmentColors = [
    Colors.cyan,
    Colors.pink,
    Colors.orange,
    Colors.deepPurple,
    Colors.red,
    Colors.green,
    Colors.amber,
    Colors.blue,
    Colors.teal,
    Colors.indigo,
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  // Initial data load
  Future<void> _loadInitialData() async {
    setState(() {
      isLoadingProducts = true;
    });

    // Load all products by default
    QuerySnapshot productsSnapshot = await FirebaseFirestore.instance
        .collection('Products')
        .limit(10)
        .get();

    setState(() {
      wheelProducts = productsSnapshot.docs
          .map((doc) => doc['productName'].toString())
          .toList();
      isLoadingProducts = false;
    });
  }

  // Load categories from Firestore
  Future<void> loadCategories() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Catagories')
        .get();

    setState(() {
      allCategories = snapshot.docs
          .map((doc) => doc['catagoryName'].toString())
          .toList();

      // Store category references
      for (var doc in snapshot.docs) {
        categoryRefs[doc['catagoryName'].toString()] = doc.reference;
      }

      categoryCheckboxes = Map.fromIterable(
        allCategories,
        value: (v) => selectedCategories.contains(v),
      );
    });
  }

  // Load subcategories based on selected categories
  Future<void> loadSubcategories() async {
    if (selectedCategories.isEmpty) {
      setState(() {
        allSubcategories = [];
        subcategoryCheckboxes = {};
      });
      return;
    }

    // Get references of selected categories
    List<DocumentReference> selectedCategoryRefs = selectedCategories
        .map((categoryName) => categoryRefs[categoryName])
        .whereType<DocumentReference>()
        .toList();

    if (selectedCategoryRefs.isEmpty) {
      setState(() {
        allSubcategories = [];
        subcategoryCheckboxes = {};
      });
      return;
    }

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('SubCatagories')
        .where('catagoriesRef', whereIn: selectedCategoryRefs)
        .get();

    setState(() {
      allSubcategories = snapshot.docs
          .map((doc) => doc['name'].toString())
          .toList();

      // Store subcategory references
      for (var doc in snapshot.docs) {
        subcategoryRefs[doc['name'].toString()] = doc.reference;
      }

      subcategoryCheckboxes = Map.fromIterable(
        allSubcategories,
        value: (v) => selectedSubcategories.contains(v),
      );
    });
  }

  // Load products based on selected subcategories
  Future<void> loadProducts() async {
    if (selectedSubcategories.isEmpty && selectedCategories.isEmpty) {
      // If no filters selected, load default products
      await _loadInitialData();
      return;
    }

    Query query = FirebaseFirestore.instance.collection('Products');

    // If subcategories are selected, filter by subcategory references
    if (selectedSubcategories.isNotEmpty) {
      List<DocumentReference> selectedSubcategoryRefs = selectedSubcategories
          .map((subcategoryName) => subcategoryRefs[subcategoryName])
          .whereType<DocumentReference>()
          .toList();

      if (selectedSubcategoryRefs.isNotEmpty) {
        query = query.where('subCatagoryRef', whereIn: selectedSubcategoryRefs);
      }
    }
    // If only categories are selected (no subcategories), filter by category references
    else if (selectedCategories.isNotEmpty) {
      List<DocumentReference> selectedCategoryRefs = selectedCategories
          .map((categoryName) => categoryRefs[categoryName])
          .whereType<DocumentReference>()
          .toList();

      if (selectedCategoryRefs.isNotEmpty) {
        query = query.where('catagoryRef', whereIn: selectedCategoryRefs);
      }
    }

    QuerySnapshot snapshot = await query.limit(10).get();

    setState(() {
      wheelProducts = snapshot.docs
          .map((doc) => doc['productName'].toString())
          .toList();
    });
  }

  // Category Selection Dialog
  Future<void> showCategorySelectionDialog() async {
    if (allCategories.isEmpty) {
      await loadCategories();
    }

    // Update checkboxes to reflect currently selected categories
    for (var category in allCategories) {
      if (!categoryCheckboxes.containsKey(category)) {
        categoryCheckboxes[category] = selectedCategories.contains(category);
      }
    }

    Map<String, bool> tempCheckboxes = Map.from(categoryCheckboxes);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            int selectedCount = tempCheckboxes.values
                .where((v) => v == true)
                .length;

            return AlertDialog(
              title: Text('Choose Categories ($selectedCount)'),
              content: Container(
                height: 500,
                width: double.maxFinite,
                child: allCategories.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: allCategories.length,
                        itemBuilder: (context, index) {
                          String category = allCategories[index];
                          bool isChecked = tempCheckboxes[category] ?? false;

                          return CheckboxListTile(
                            title: Text(category),
                            value: isChecked,
                            onChanged: (bool? value) {
                              setDialogState(() {
                                tempCheckboxes[category] = value ?? false;
                              });
                            },
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    int selectedCount = tempCheckboxes.values
                        .where((v) => v == true)
                        .length;

                    if (selectedCount == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select at least one category.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      categoryCheckboxes = tempCheckboxes;
                      selectedCategories = categoryCheckboxes.entries
                          .where((entry) => entry.value == true)
                          .map((entry) => entry.key)
                          .toList();

                      // Reset subcategories when categories change
                      selectedSubcategories = [];
                      subcategoryCheckboxes = {};
                      allSubcategories = [];
                    });

                    Navigator.of(context).pop();

                    // Load products by categories only
                    await loadProducts();
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Subcategory Selection Dialog (independent)
  Future<void> showSubcategorySelectionDialog() async {
    // First check if categories are selected
    if (selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select categories first.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Load subcategories if not already loaded
    if (allSubcategories.isEmpty) {
      await loadSubcategories();
    }

    if (allSubcategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No subcategories found for selected categories.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Update checkboxes to reflect currently selected subcategories
    for (var subcategory in allSubcategories) {
      if (!subcategoryCheckboxes.containsKey(subcategory)) {
        subcategoryCheckboxes[subcategory] = selectedSubcategories.contains(
          subcategory,
        );
      }
    }

    Map<String, bool> tempCheckboxes = Map.from(subcategoryCheckboxes);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            int selectedCount = tempCheckboxes.values
                .where((v) => v == true)
                .length;

            return AlertDialog(
              title: Text('Choose Subcategories ($selectedCount/10)'),
              content: Container(
                height: 500,
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: allSubcategories.length,
                  itemBuilder: (context, index) {
                    String subcategory = allSubcategories[index];
                    bool isChecked = tempCheckboxes[subcategory] ?? false;

                    return CheckboxListTile(
                      title: Text(subcategory),
                      value: isChecked,
                      onChanged: (bool? value) {
                        if (value == true && selectedCount >= 10) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'You can select maximum 10 subcategories.',
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return;
                        }

                        setDialogState(() {
                          tempCheckboxes[subcategory] = value ?? false;
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    int selectedCount = tempCheckboxes.values
                        .where((v) => v == true)
                        .length;

                    if (selectedCount == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please select at least one subcategory.',
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      subcategoryCheckboxes = tempCheckboxes;
                      selectedSubcategories = subcategoryCheckboxes.entries
                          .where((entry) => entry.value == true)
                          .map((entry) => entry.key)
                          .toList();
                    });

                    Navigator.of(context).pop();

                    // Load products based on selected subcategories
                    await loadProducts();
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> fetchSelectedProductDocument(String productName) async {
    try {
      print("Fetching document for product: $productName");

      QuerySnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('Products')
          .where('productName', isEqualTo: productName)
          .limit(1)
          .get();

      if (productSnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = productSnapshot.docs.first;
        print("✅ Product Document Found!");
        print("Document ID: ${doc.id}");

        // Call your action here
        // await widget.action?.call();
      } else {
        print("❌ Product document not found: $productName");
      }
    } catch (e) {
      print("❌ Error fetching product document: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
              const SizedBox(height: 10),

Row(
  mainAxisAlignment: selectedSubcategories.isEmpty
      ? MainAxisAlignment.center  // Center the button when Subcategories is empty
      : MainAxisAlignment.start,  // Default alignment when both buttons are visible
  children: [
    ElevatedButton(
      onPressed: () async {
        await showCategorySelectionDialog();
      },
      child: Text(
        selectedCategories.isEmpty ? 'Select Categories' : 'Edit Categories',
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    ),
    const SizedBox(width: 10),
    // Only show the Subcategory button when it's not empty
    if (selectedCategories.isNotEmpty) 
      ElevatedButton(
        onPressed: selectedCategories.isEmpty
            ? null
            : () async {
                await showSubcategorySelectionDialog();
              },
        child: Text(
          selectedSubcategories.isEmpty
              ? 'Select Subcategories'
              : 'Edit Subcategories',
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
  ],
),


      //         Row(
      //           mainAxisAlignment: selectedSubcategories.isEmpty
      // ? MainAxisAlignment.center  // Center the button when Subcategories is empty
      // : MainAxisAlignment.start, 
      //           children: [
      //             ElevatedButton(
      //               onPressed: () async {
      //                 await showCategorySelectionDialog();
      //               },

      //               child: Text(
      //                 selectedCategories.isEmpty
      //                     ? 'Select Categories'
      //                     : 'Edit Categories',
      //               ),
      //               style: ElevatedButton.styleFrom(
      //                 backgroundColor: Colors.deepOrange,
      //                 padding: const EdgeInsets.symmetric(
      //                   horizontal: 16,
      //                   vertical: 12,
      //                 ),
      //               ),
      //             ),
      //             // const SizedBox(width: 10),
      //             ElevatedButton(
      //               onPressed: selectedCategories.isEmpty
      //                   ? null
      //                   : () async {
      //                       await showSubcategorySelectionDialog();
      //                     },

      //               child: Text(
      //                 selectedSubcategories.isEmpty
      //                     ? 'Select Subcategories'
      //                     : 'Edit Subcategories',
      //               ),
      //               style: ElevatedButton.styleFrom(
      //                 padding: const EdgeInsets.symmetric(
      //                   horizontal: 16,
      //                   vertical: 12,
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),



              const SizedBox(height: 10),

              if (selectedCategories.isNotEmpty ||
                  selectedSubcategories.isNotEmpty)
                TextButton(
                  onPressed: () async {
                    setState(() {
                      selectedCategories = [];
                      selectedSubcategories = [];
                      categoryCheckboxes = {};
                      subcategoryCheckboxes = {};
                      allSubcategories = [];
                    });
                    await _loadInitialData();
                  },
                  child: const Text(
                    'Clear All Filters',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
        Expanded(
          child: Center(
            child: isLoadingProducts
                ? const CircularProgressIndicator()
                : wheelProducts.isEmpty
                ? const Text('No products available to spin.')
                : wheelProducts.length < 2
                ? const Text('Not enough products to spin!')
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 500,
                  width: 500,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF101F3C),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20),

                            child: FortuneWheel(
                              onAnimationEnd: () async {
                                print(
                                  "Wheel stopped. Selected value: $selectedValue",
                                );

                                if (selectedValue != null) {
                                  await fetchSelectedProductDocument(
                                    selectedValue!,
                                  );
                                }

                                setState(() {
                                  isSpinning = false;
                                });
                              },
                              selected: controller.stream,
                              hapticImpact: HapticImpact.heavy,
                              indicators:  <FortuneIndicator>[
                                FortuneIndicator(
                                  alignment: Alignment.topCenter,
                                  child: TriangleIndicator(
                                    color: Colors.yellow,
                                  ),
                                ),
                          
                              ],
                              items: [
                                for (
                                  int i = 0;
                                  i < wheelProducts.length && i < 10;
                                  i++
                                )
                                  FortuneItem(
                                    child: Text(
                                      wheelProducts[i],
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: FortuneItemStyle(
                                      color:
                                          segmentColors[i %
                                              segmentColors.length],
                                      borderColor: Colors.white,
                                      borderWidth: 1,
                                    ),
                                  ),
                              ],
                            ),
                       
                          ),
                        ),
                      ),
                      Positioned(
                        child: GestureDetector(
                          onTap: () async {
                            if (isSpinning || wheelProducts.isEmpty) return;

                            setState(() {
                              isSpinning = true;
                            });

                            final selected = Random().nextInt(
                              wheelProducts.length,
                            );
                            selectedValue = wheelProducts[selected];
                            controller.add(selected);

                            print("Wheel spinning to: $selectedValue");
                          },
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueAccent,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'SPIN',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
         
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(20.0),
        //   child: Column(
        //     children: [
        //       if (selectedCategories.isNotEmpty)
        //         Text(
        //           'Categories: ${selectedCategories.length} selected',
        //           style: const TextStyle(color: Colors.white, fontSize: 14),
        //         ),
        //       if (selectedSubcategories.isNotEmpty)
        //         Text(
        //           'Subcategories: ${selectedSubcategories.length} selected',
        //           style: const TextStyle(color: Colors.white, fontSize: 14),
        //         ),
        //       if (wheelProducts.isNotEmpty)
        //         Text(
        //           'Showing ${wheelProducts.length} products on wheel',
        //           style: const TextStyle(
        //             color: Colors.white,
        //             fontSize: 16,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //       const SizedBox(height: 15),

        //     ],
        //   ),
        // ),
     
      ],
    );

    // return Column(
    //   children: [
    //     Expanded(
    //       child: Center(
    //         child: isLoadingProducts
    //             ? const CircularProgressIndicator()
    //             : wheelProducts.isEmpty
    //             ? const Text(
    //                 'No products found.',
    //                 style: TextStyle(color: Colors.white),
    //               )
    //             : Stack(
    //                 alignment: Alignment.center,
    //                 children: [
    //                   Container(
    //                     height: 1000,
    //                     width: 900,
    //                     decoration: BoxDecoration(
    //                       color: Colors.amber,
    //                       shape: BoxShape.circle,
    //                     ),
    //                     child: Container(
    //                       decoration: const BoxDecoration(
    //                         shape: BoxShape.circle,
    //                         color: Color(0xFF101F3C),
    //                       ),
    //                       child: Padding(
    //                         padding: EdgeInsets.all(20),

    //                         child:  FortuneWheel(
    //                                 onAnimationEnd: () async {

    //                                   print(
    //                                     "Wheel stopped. Selected value: $selectedValue",
    //                                   );

    //                                   if (selectedValue != null) {
    //                                     await fetchSelectedProductDocument(
    //                                       selectedValue!,
    //                                     );
    //                                   }

    //                                   setState(() {
    //                                     isSpinning = false;
    //                                   });
    //                                 },
    //                                 selected: controller.stream,
    //                                 hapticImpact: HapticImpact.heavy,
    //                                 indicators: const <FortuneIndicator>[
    //                                   FortuneIndicator(
    //                                     alignment: Alignment.topCenter,
    //                                     child: TriangleIndicator(
    //                                       color: Colors.yellow,
    //                                     ),
    //                                   ),
    //                                 ],
    //                                 items: [
    //                                   for (
    //                                     int i = 0;
    //                                     i < wheelProducts.length && i < 10;
    //                                     i++
    //                                   )
    //                                     FortuneItem(
    //                                       child: Text(
    //                                         wheelProducts[i],
    //                                         style: const TextStyle(
    //                                           color: Colors.white,
    //                                         ),
    //                                       ),
    //                                       style: FortuneItemStyle(
    //                                         color:
    //                                             segmentColors[i %
    //                                                 segmentColors.length],
    //                                         borderColor: Colors.white,
    //                                         borderWidth: 1,
    //                                       ),
    //                                     ),
    //                                 ],
    //                               )

    //                       ),
    //                     ),
    //                   ),
    //                   Positioned(
    //                     child: GestureDetector(
    //                       onTap: () async {
    //                         if (isSpinning || wheelProducts.isEmpty) return;

    //                         setState(() {
    //                           isSpinning = true;
    //                         });

    //                         final selected = Random().nextInt(
    //                           wheelProducts.length,
    //                         );
    //                         selectedValue = wheelProducts[selected];
    //                         controller.add(selected);

    //                         print("Wheel spinning to: $selectedValue");
    //                       },
    //                       child: Container(
    //                         height: 80,
    //                         width: 80,
    //                         decoration: const BoxDecoration(
    //                           shape: BoxShape.circle,
    //                           color: Colors.blueAccent,
    //                           boxShadow: [
    //                             BoxShadow(
    //                               color: Colors.black38,
    //                               blurRadius: 10,
    //                               offset: Offset(0, 4),
    //                             ),
    //                           ],
    //                         ),
    //                         child: Center(
    //                           child: Text(
    //                             'SPIN',
    //                             style: const TextStyle(
    //                               color: Colors.white,
    //                               fontWeight: FontWeight.bold,
    //                               fontSize: 16,
    //                               letterSpacing: 1.2,
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //       ),
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.all(20.0),
    //       child: Column(
    //         children: [
    //           if (selectedCategories.isNotEmpty)
    //             Text(
    //               'Categories: ${selectedCategories.length} selected',
    //               style: const TextStyle(color: Colors.white, fontSize: 14),
    //             ),
    //           if (selectedSubcategories.isNotEmpty)
    //             Text(
    //               'Subcategories: ${selectedSubcategories.length} selected',
    //               style: const TextStyle(color: Colors.white, fontSize: 14),
    //             ),
    //           if (wheelProducts.isNotEmpty)
    //             Text(
    //               'Showing ${wheelProducts.length} products on wheel',
    //               style: const TextStyle(
    //                 color: Colors.white,
    //                 fontSize: 16,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //           const SizedBox(height: 15),

    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               ElevatedButton(
    //                 onPressed: () async {
    //                   await showCategorySelectionDialog();
    //                 },

    //                 child: Text(
    //                   selectedCategories.isEmpty
    //                       ? 'Select Categories'
    //                       : 'Edit Categories',
    //                 ),
    //                 style: ElevatedButton.styleFrom(
    //                   padding: const EdgeInsets.symmetric(
    //                     horizontal: 16,
    //                     vertical: 12,
    //                   ),
    //                 ),
    //               ),
    //               const SizedBox(width: 10),
    //               ElevatedButton(
    //                 onPressed: selectedCategories.isEmpty
    //                     ? null
    //                     : () async {
    //                         await showSubcategorySelectionDialog();
    //                       },

    //                 child: Text(
    //                   selectedSubcategories.isEmpty
    //                       ? 'Select Subcategories'
    //                       : 'Edit Subcategories',
    //                 ),
    //                 style: ElevatedButton.styleFrom(
    //                   padding: const EdgeInsets.symmetric(
    //                     horizontal: 16,
    //                     vertical: 12,
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),

    //           const SizedBox(height: 10),

    //           if (selectedCategories.isNotEmpty ||
    //               selectedSubcategories.isNotEmpty)
    //             TextButton(
    //               onPressed: () async {
    //                 setState(() {
    //                   selectedCategories = [];
    //                   selectedSubcategories = [];
    //                   categoryCheckboxes = {};
    //                   subcategoryCheckboxes = {};
    //                   allSubcategories = [];
    //                 });
    //                 await _loadInitialData();
    //               },
    //               child: const Text(
    //                 'Clear All Filters',
    //                 style: TextStyle(color: Colors.red),
    //               ),
    //             ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}


// class WheelWithFilters extends StatefulWidget {
//   const WheelWithFilters({
//     super.key,
//     this.width,
//     this.height,
//   });

//   final double? width;
//   final double? height;

//   @override
//   State<WheelWithFilters> createState() => _WheelWithFiltersState();
// }

// class _WheelWithFiltersState extends State<WheelWithFilters> {
//   StreamController<int> controller = StreamController<int>.broadcast();

//   // Categories data
//   List<String> allCategories = [];
//   List<String> selectedCategories = [];
//   Map<String, bool> categoryCheckboxes = {};
//   Map<String, DocumentReference> categoryRefs = {}; // Store category references

//   // Subcategories data
//   List<String> allSubcategories = [];
//   List<String> selectedSubcategories = [];
//   Map<String, bool> subcategoryCheckboxes = {};
//   Map<String, DocumentReference> subcategoryRefs =
//       {}; // Store subcategory references

//   // Products data
//   List<String> allProducts = [];
//   List<String> wheelProducts = [];

//   bool isLoadingProducts = true;
//   bool isSpinning = false;
//   String? selectedValue;

//   final List<Color> segmentColors = [
//     Colors.cyan,
//     Colors.pink,
//     Colors.orange,
//     Colors.deepPurple,
//     Colors.red,
//     Colors.green,
//     Colors.amber,
//     Colors.blue,
//     Colors.teal,
//     Colors.indigo,
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadInitialData();
//   }

//   @override
//   void dispose() {
//     controller.close();
//     super.dispose();
//   }

//   // Initial data load
//   Future<void> _loadInitialData() async {
//     setState(() {
//       isLoadingProducts = true;
//     });

//     // Load all products by default
//     QuerySnapshot productsSnapshot =
//         await FirebaseFirestore.instance.collection('Products').limit(10).get();

//     setState(() {
//       wheelProducts = productsSnapshot.docs
//           .map((doc) => doc['productName'].toString())
//           .toList();
//       isLoadingProducts = false;
//     });
//   }

//   // Load categories from Firestore
//   Future<void> loadCategories() async {
//     QuerySnapshot snapshot =
//         await FirebaseFirestore.instance.collection('Catagories').get();

//     setState(() {
//       allCategories =
//           snapshot.docs.map((doc) => doc['catagoryName'].toString()).toList();

//       // Store category references
//       for (var doc in snapshot.docs) {
//         categoryRefs[doc['catagoryName'].toString()] = doc.reference;
//       }

//       categoryCheckboxes = Map.fromIterable(
//         allCategories,
//         value: (v) => selectedCategories.contains(v),
//       );
//     });
//   }

//   // Load subcategories based on selected categories
//   Future<void> loadSubcategories() async {
//     if (selectedCategories.isEmpty) {
//       setState(() {
//         allSubcategories = [];
//         subcategoryCheckboxes = {};
//       });
//       return;
//     }

//     // Get references of selected categories
//     List<DocumentReference> selectedCategoryRefs = selectedCategories
//         .map((categoryName) => categoryRefs[categoryName])
//         .whereType<DocumentReference>()
//         .toList();

//     if (selectedCategoryRefs.isEmpty) {
//       setState(() {
//         allSubcategories = [];
//         subcategoryCheckboxes = {};
//       });
//       return;
//     }

//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('SubCatagories')
//         .where('catagoriesRef', whereIn: selectedCategoryRefs)
//         .get();

//     setState(() {
//       allSubcategories =
//           snapshot.docs.map((doc) => doc['name'].toString()).toList();

//       // Store subcategory references
//       for (var doc in snapshot.docs) {
//         subcategoryRefs[doc['name'].toString()] = doc.reference;
//       }

//       subcategoryCheckboxes = Map.fromIterable(
//         allSubcategories,
//         value: (v) => selectedSubcategories.contains(v),
//       );
//     });
//   }

//   // Load products based on selected subcategories
//   Future<void> loadProducts() async {
//     if (selectedSubcategories.isEmpty && selectedCategories.isEmpty) {
//       // If no filters selected, load default products
//       await _loadInitialData();
//       return;
//     }

//     Query query = FirebaseFirestore.instance.collection('Products');

//     // If subcategories are selected, filter by subcategory references
//     if (selectedSubcategories.isNotEmpty) {
//       List<DocumentReference> selectedSubcategoryRefs = selectedSubcategories
//           .map((subcategoryName) => subcategoryRefs[subcategoryName])
//           .whereType<DocumentReference>()
//           .toList();

//       if (selectedSubcategoryRefs.isNotEmpty) {
//         query = query.where('subCatagoryRef', whereIn: selectedSubcategoryRefs);
//       }
//     }
//     // If only categories are selected (no subcategories), filter by category references
//     else if (selectedCategories.isNotEmpty) {
//       List<DocumentReference> selectedCategoryRefs = selectedCategories
//           .map((categoryName) => categoryRefs[categoryName])
//           .whereType<DocumentReference>()
//           .toList();

//       if (selectedCategoryRefs.isNotEmpty) {
//         query = query.where('catagoryRef', whereIn: selectedCategoryRefs);
//       }
//     }

//     QuerySnapshot snapshot = await query.limit(10).get();

//     setState(() {
//       wheelProducts =
//           snapshot.docs.map((doc) => doc['productName'].toString()).toList();
//     });
//   }

//   // Category Selection Dialog
//   Future<void> showCategorySelectionDialog() async {
//     if (allCategories.isEmpty) {
//       await loadCategories();
//     }

//     // Update checkboxes to reflect currently selected categories
//     for (var category in allCategories) {
//       if (!categoryCheckboxes.containsKey(category)) {
//         categoryCheckboxes[category] = selectedCategories.contains(category);
//       }
//     }

//     Map<String, bool> tempCheckboxes = Map.from(categoryCheckboxes);

//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             int selectedCount =
//                 tempCheckboxes.values.where((v) => v == true).length;

//             return AlertDialog(
//               title: Text('Choose Categories ($selectedCount)'),
//               content: Container(
//                 height: 500,
//                 width: double.maxFinite,
//                 child: allCategories.isEmpty
//                     ? const Center(child: CircularProgressIndicator())
//                     : ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: allCategories.length,
//                         itemBuilder: (context, index) {
//                           String category = allCategories[index];
//                           bool isChecked = tempCheckboxes[category] ?? false;

//                           return CheckboxListTile(
//                             title: Text(category),
//                             value: isChecked,
//                             onChanged: (bool? value) {
//                               setDialogState(() {
//                                 tempCheckboxes[category] = value ?? false;
//                               });
//                             },
//                           );
//                         },
//                       ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('Cancel'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     int selectedCount =
//                         tempCheckboxes.values.where((v) => v == true).length;

//                     if (selectedCount == 0) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Please select at least one category.'),
//                           duration: Duration(seconds: 2),
//                         ),
//                       );
//                       return;
//                     }

//                     setState(() {
//                       categoryCheckboxes = tempCheckboxes;
//                       selectedCategories = categoryCheckboxes.entries
//                           .where((entry) => entry.value == true)
//                           .map((entry) => entry.key)
//                           .toList();

//                       // Reset subcategories when categories change
//                       selectedSubcategories = [];
//                       subcategoryCheckboxes = {};
//                       allSubcategories = [];
//                     });

//                     Navigator.of(context).pop();

//                     // Load products by categories only
//                     await loadProducts();
//                   },
//                   child: const Text('Apply'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   // Subcategory Selection Dialog (independent)
//   Future<void> showSubcategorySelectionDialog() async {
//     // First check if categories are selected
//     if (selectedCategories.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please select categories first.'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//       return;
//     }

//     // Load subcategories if not already loaded
//     if (allSubcategories.isEmpty) {
//       await loadSubcategories();
//     }

//     if (allSubcategories.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('No subcategories found for selected categories.'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//       return;
//     }

//     // Update checkboxes to reflect currently selected subcategories
//     for (var subcategory in allSubcategories) {
//       if (!subcategoryCheckboxes.containsKey(subcategory)) {
//         subcategoryCheckboxes[subcategory] = selectedSubcategories.contains(
//           subcategory,
//         );
//       }
//     }

//     Map<String, bool> tempCheckboxes = Map.from(subcategoryCheckboxes);

//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             int selectedCount =
//                 tempCheckboxes.values.where((v) => v == true).length;

//             return AlertDialog(
//               title: Text('Choose Subcategories ($selectedCount/10)'),
//               content: Container(
//                 height: 500,
//                 width: double.maxFinite,
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: allSubcategories.length,
//                   itemBuilder: (context, index) {
//                     String subcategory = allSubcategories[index];
//                     bool isChecked = tempCheckboxes[subcategory] ?? false;

//                     return CheckboxListTile(
//                       title: Text(subcategory),
//                       value: isChecked,
//                       onChanged: (bool? value) {
//                         if (value == true && selectedCount >= 10) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text(
//                                 'You can select maximum 10 subcategories.',
//                               ),
//                               duration: Duration(seconds: 2),
//                             ),
//                           );
//                           return;
//                         }

//                         setDialogState(() {
//                           tempCheckboxes[subcategory] = value ?? false;
//                         });
//                       },
//                     );
//                   },
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('Cancel'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     int selectedCount =
//                         tempCheckboxes.values.where((v) => v == true).length;

//                     if (selectedCount == 0) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text(
//                             'Please select at least one subcategory.',
//                           ),
//                           duration: Duration(seconds: 2),
//                         ),
//                       );
//                       return;
//                     }

//                     setState(() {
//                       subcategoryCheckboxes = tempCheckboxes;
//                       selectedSubcategories = subcategoryCheckboxes.entries
//                           .where((entry) => entry.value == true)
//                           .map((entry) => entry.key)
//                           .toList();
//                     });

//                     Navigator.of(context).pop();

//                     // Load products based on selected subcategories
//                     await loadProducts();
//                   },
//                   child: const Text('Apply'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   DocumentReference? selectedProductRef;
//   ProductRecord? selectedProductRecord;

//   Future<void> fetchSelectedProductDocument(String productName) async {
//     try {
//       print("Fetching document for product: $productName");

//       QuerySnapshot productSnapshot = await FirebaseFirestore.instance
//           .collection('Products')
//           .where('productName', isEqualTo: productName)
//           .limit(1)
//           .get();

//       if (productSnapshot.docs.isNotEmpty) {
//         DocumentSnapshot doc = productSnapshot.docs.first;
//         print("✅ Product Document Found!");
//         print("Document ID: ${doc.id}");
//         // selectedProductRecord = ProductRecord.fromSnapshot(doc);

//         // // If you also want the document reference, you can assign it separately
//         // selectedProductRef = doc.reference;
//         // // Call your action here
//         // // await widget.action?.call();
//         // // Assuming ProductRecord can be cast to ProductsRecord
//         // context.pushNamed(
//         //   "ListingDetailPage",
//         //   extra: <String, dynamic>{
//         //     "product": selectedProductRecord, // Pass ProductRecord directly
//         //   },
//         // );
//         selectedProductRef = doc.reference;
//         selectedProductRecord = ProductRecord.fromSnapshot(doc);

//         // Pass the document snapshot to ListingDetailPage
//         context.pushNamed(
//           "ListingDetailPage",
//           extra: <String, dynamic>{
//             "productDoc": doc, // Pass the DocumentSnapshot directly
//           },
//         );
//       } else {
//         selectedProductRecord = null;
//         selectedProductRef = null;
//         print("❌ Product document not found: $productName");
//       }
//     } catch (e) {
//       selectedProductRecord = null;
//       selectedProductRef = null;
//       print("❌ Error fetching product document: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 10),

//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 await showCategorySelectionDialog();
//               },
//               child: Text(
//                 selectedCategories.isEmpty
//                     ? 'Select Categories'
//                     : 'Edit Categories',
//               ),
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 12,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 10),
//             ElevatedButton(
//               onPressed: selectedCategories.isEmpty
//                   ? null
//                   : () async {
//                       await showSubcategorySelectionDialog();
//                     },
//               child: Text(
//                 selectedSubcategories.isEmpty
//                     ? 'Select Subcategories'
//                     : 'Edit Subcategories',
//               ),
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 12,
//                 ),
//               ),
//             ),
//           ],
//         ),

//         const SizedBox(height: 10),

//         if (selectedCategories.isNotEmpty || selectedSubcategories.isNotEmpty)
//           TextButton(
//             onPressed: () async {
//               setState(() {
//                 selectedCategories = [];
//                 selectedSubcategories = [];
//                 categoryCheckboxes = {};
//                 subcategoryCheckboxes = {};
//                 allSubcategories = [];
//               });
//               await _loadInitialData();
//             },
//             child: const Text(
//               'Clear All Filters',
//               style: TextStyle(color: Colors.red),
//             ),
//           ),
//         Expanded(
//           child: Center(
//             child: isLoadingProducts
//                 ? const CircularProgressIndicator()
//                 : wheelProducts.isEmpty
//                     ? const Text('No products available to spin.')
//                     : wheelProducts.length < 2
//                         ? const Text('Not enough products to spin!')
//                         : Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               Container(
//                                 height: widget.height,
//                                 width: widget.width,
//                                 decoration: BoxDecoration(
//                                   color: Colors.amber,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Container(
//                                   decoration: const BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Color(0xFF101F3C),
//                                   ),
//                                   child: Padding(
//                                     padding: EdgeInsets.all(20),
//                                     child: FortuneWheel(
//                                       onAnimationEnd: () async {
//                                         print(
//                                           "Wheel stopped. Selected value: $selectedValue",
//                                         );

//                                         if (selectedValue != null) {
//                                           await fetchSelectedProductDocument(
//                                             selectedValue!,
//                                           );
//                                         }

//                                         setState(() {
//                                           isSpinning = false;
//                                         });
//                                       },
//                                       selected: controller.stream,
//                                       hapticImpact: HapticImpact.heavy,
//                                       indicators: const <FortuneIndicator>[
//                                         FortuneIndicator(
//                                           alignment: Alignment.topCenter,
//                                           child: TriangleIndicator(
//                                             color: Colors.yellow,
//                                           ),
//                                         ),
//                                       ],
//                                       items: [
//                                         for (int i = 0;
//                                             i < wheelProducts.length && i < 10;
//                                             i++)
//                                           FortuneItem(
//                                             child: Text(
//                                               wheelProducts[i],
//                                               style: const TextStyle(
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                             style: FortuneItemStyle(
//                                               color: segmentColors[
//                                                   i % segmentColors.length],
//                                               borderColor: Colors.white,
//                                               borderWidth: 1,
//                                             ),
//                                           ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 child: GestureDetector(
//                                   onTap: () async {
//                                     if (isSpinning || wheelProducts.isEmpty)
//                                       return;

//                                     setState(() {
//                                       isSpinning = true;
//                                     });

//                                     final selected = Random().nextInt(
//                                       wheelProducts.length,
//                                     );
//                                     selectedValue = wheelProducts[selected];
//                                     controller.add(selected);

//                                     print("Wheel spinning to: $selectedValue");
//                                   },
//                                   child: Container(
//                                     height: 80,
//                                     width: 80,
//                                     decoration: const BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Colors.blueAccent,
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.black38,
//                                           blurRadius: 10,
//                                           offset: Offset(0, 4),
//                                         ),
//                                       ],
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         'SPIN',
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 16,
//                                           letterSpacing: 1.2,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//           ),
//         ),
//         // Padding(
//         //   padding: const EdgeInsets.all(20.0),
//         //   child: Column(
//         //     children: [
//         //       if (selectedCategories.isNotEmpty)
//         //         Text(
//         //           'Categories: ${selectedCategories.length} selected',
//         //           style: const TextStyle(color: Colors.white, fontSize: 14),
//         //         ),
//         //       if (selectedSubcategories.isNotEmpty)
//         //         Text(
//         //           'Subcategories: ${selectedSubcategories.length} selected',
//         //           style: const TextStyle(color: Colors.white, fontSize: 14),
//         //         ),
//         //       if (wheelProducts.isNotEmpty)
//         //         Text(
//         //           'Showing ${wheelProducts.length} products on wheel',
//         //           style: const TextStyle(
//         //             color: Colors.white,
//         //             fontSize: 16,
//         //             fontWeight: FontWeight.bold,
//         //           ),
//         //         ),
//         //       const SizedBox(height: 15),

//         //     ],
//         //   ),
//         // ),
//       ],
//     );
 
//   }
// }


