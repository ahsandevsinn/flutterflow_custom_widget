import 'dart:async';
import 'dart:developer';
import 'dart:math';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_text/scrollable_text.dart';

import 'package:text_scroll/text_scroll.dart';

// class WheelScreen extends StatefulWidget {
//   const WheelScreen({super.key});

//   @override
//   State<WheelScreen> createState() => _WheelScreenState();
// }

// class _WheelScreenState extends State<WheelScreen> {
//   StreamController<int> controller = StreamController<int>();
//   late CollectionReference categoriesCollection;
//   String? selectedValue;
//     @override
//   void dispose() {
//     controller.close();
//     super.dispose();
//   }

//   var value;
//   List<String> options = [];

//   Future<List<String>> getCategories() async {
//     categoriesCollection = FirebaseFirestore.instance.collection('Catagories');

//     QuerySnapshot snapshot = await categoriesCollection.get();
//     return snapshot.docs
//         .map(
//           (doc) => doc['catagoryName'].toString(),
//         ) // assuming you have a 'name' field
//         .toList();
//   }

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
//     Colors.lime,
//     Colors.deepOrange,
//     Colors.lightBlue,
//     Colors.lightGreen,
//     Colors.purple,
//     Colors.yellow,
//     Colors.brown,
//     Colors.blueGrey,
//   ];

//   List<String> allCategories = [];
// List<String> selectedCategories = [];
// Map<String, bool> categoryCheckboxes = {};

// // Fetch categories method (your existing method)
// // Future<List<String>> getCategories() async {
// //   categoriesCollection = FirebaseFirestore.instance.collection('Catagories');

// //   QuerySnapshot snapshot = await categoriesCollection.get();
// //   return snapshot.docs
// //       .map(
// //         (doc) => doc['catagoryName'].toString(),
// //       )
// //       .toList();
// // }

// Future<void> loadCategories() async {
//   allCategories = await getCategories();
//   // Initialize all checkboxes as unchecked
//   for (var category in allCategories) {
//     categoryCheckboxes[category] = false;
//   }
//   setState(() {});
// }

// Future<void> showCategorySelectionDialog() async {
//   // Create a temporary copy to allow cancel
//   Map<String, bool> tempCheckboxes = Map.from(categoryCheckboxes);

//   await showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (context, setDialogState) {
//           return AlertDialog(
//             title: const Text('Choose Categories'),
//             content: Container(
//               width: double.maxFinite,
//               child: allCategories.isEmpty
//                   ? const Center(child: CircularProgressIndicator())
//                   : ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: allCategories.length,
//                       itemBuilder: (context, index) {
//                         String category = allCategories[index];
//                         return CheckboxListTile(
//                           title: Text(category),
//                           value: tempCheckboxes[category] ?? false,
//                           onChanged: (bool? value) {
//                             setDialogState(() {
//                               tempCheckboxes[category] = value ?? false;
//                             });
//                           },
//                         );
//                       },
//                     ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(); // Close without saving
//                 },
//                 child: const Text('Cancel'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   // Update the main checkboxes state
//                   setState(() {
//                     categoryCheckboxes = tempCheckboxes;
//                     // Extract selected categories
//                     selectedCategories = categoryCheckboxes.entries
//                         .where((entry) => entry.value == true)
//                         .map((entry) => entry.key)
//                         .toList();
//                   });

//                   print('Selected Categories: $selectedCategories');
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('Update'),
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }

//   int? selectedIndex;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF8A70F0),
//       body: Column(
//         children: [
//           Center(
//             child: FutureBuilder<List<String>>(
//               future: getCategories(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const CircularProgressIndicator();
//                 }

//                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Text('No categories found.');
//                 }

//                 options = snapshot.data!;
//                 options.addAll(selectedCategories);

//                 return Stack(
//                   alignment: Alignment.center,
//                   children: [

//                     Container(
//                       height: 650,
//                       width: 750,
//                       decoration: BoxDecoration(
//                         color: Colors.amber,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Container(

//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Color(0xFF101F3C),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(20),
//                           child: FortuneWheel(
//                             onAnimationEnd: () {
//                               print("function call");

//                               print("${options}");
//                             },
//                             selected: controller.stream,
//                             hapticImpact: HapticImpact.heavy,
//                             indicators: const <FortuneIndicator>[
//                               FortuneIndicator(
//                                 alignment: Alignment.topCenter,
//                                 child: TriangleIndicator(color: Colors.yellow),
//                               ),
//                             ],
//                             items: [
//                               for (int i = 0; i < options.length && i < 20; i++)
//                                 FortuneItem(
//                                   child: Text(
//                                     options[i],
//                                     style: const TextStyle(color: Colors.white),
//                                   ),
//                                   style: FortuneItemStyle(
//                                     color:
//                                         segmentColors[i % segmentColors.length],
//                                     borderColor: Colors.white,
//                                     borderWidth: 1,
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),

//                     Positioned(
//                       child: GestureDetector(
//                         onTap: () {
//                           final selected = Random().nextInt(options.length);
//                           controller.add(selected);
//                           // selectedValue = options[selected];
//                           // value = options[selected];
//                           print("Selected index: $selected");
//                           print("Selected value: $selectedValue");
//                           //  setState(() {
//                           //     selectedValue = options[selected];
//                           //   });

//                           print("Selected index: $selected");
//                           print("Selected value: $selectedValue");
//                           print("value ${value}");
//                         },
//                         child: Container(
//                           height: 80,
//                           width: 80,
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.blueAccent,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black38,
//                                 blurRadius: 10,
//                                 offset: Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: const Center(
//                             child: Text(
//                               'SPIN',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                                 letterSpacing: 1.2,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),

//                   ],
//                 );
//               },
//             ),
//           ),

//           ElevatedButton(
//   onPressed: () {
//     if (allCategories.isEmpty) {
//       loadCategories().then((_) {
//         showCategorySelectionDialog();
//       });
//     } else {
//       showCategorySelectionDialog();
//     }
//   },
//   child: const Text('Choose Categories'),
// )
//         ],
//       ),
//     );
//   }
// }

// class WheelScreen extends StatefulWidget {
//   const WheelScreen({super.key});

//   @override
//   State<WheelScreen> createState() => _WheelScreenState();
// }

// class _WheelScreenState extends State<WheelScreen> {
//   StreamController<int> controller = StreamController<int>();
//   late CollectionReference categoriesCollection;
//   String? selectedValue;

//   @override
//   void dispose() {
//     controller.close();
//     super.dispose();
//   }

//   var value;
//   List<String> options = [];

//   Future<List<String>> getCategories() async {
//     categoriesCollection = FirebaseFirestore.instance.collection('Catagories');

//     QuerySnapshot snapshot = await categoriesCollection.get();
//     return snapshot.docs
//         .map(
//           (doc) => doc['catagoryName'].toString(),
//         )
//         .toList();
//   }

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
//     Colors.lime,
//     Colors.deepOrange,
//     Colors.lightBlue,
//     Colors.lightGreen,
//     Colors.purple,
//     Colors.yellow,
//     Colors.brown,
//     Colors.blueGrey,
//   ];

//   List<String> allCategories = [];
//   List<String> selectedCategories = [];
//   Map<String, bool> categoryCheckboxes = {};

//   Future<void> loadCategories() async {
//     allCategories = await getCategories();
//     // Initialize all checkboxes as unchecked
//     for (var category in allCategories) {
//       categoryCheckboxes[category] = false;
//     }
//     setState(() {});
//   }

//   Future<void> showCategorySelectionDialog() async {
//     // Create a temporary copy to allow cancel
//     Map<String, bool> tempCheckboxes = Map.from(categoryCheckboxes);

//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             // Count currently selected items in temp
//             int selectedCount = tempCheckboxes.values.where((v) => v == true).length;

//             return AlertDialog(
//               title: Text('Choose Categories (${selectedCount}/10)'),
//               content: Container(
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
//                               // Check if trying to select more than 20
//                               if (value == true && selectedCount >= 10) {
//                                 // Show warning
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text('Maximum 10 categories allowed!'),
//                                     duration: Duration(seconds: 2),
//                                   ),
//                                 );
//                                 return;
//                               }

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
//                   onPressed: () {
//                     setState(() {
//                       categoryCheckboxes = tempCheckboxes;
//                       selectedCategories = categoryCheckboxes.entries
//                           .where((entry) => entry.value == true)
//                           .map((entry) => entry.key)
//                           .toList();
//                     });

//                     print('Selected Categories: $selectedCategories');
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('Update'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   int? selectedIndex;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF8A70F0),
//       body: Column(
//         children: [
//           Center(
//             child: selectedCategories.isEmpty
//                 ? Center(
//             child: FutureBuilder<List<String>>(
//               future: getCategories(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const CircularProgressIndicator();
//                 }

//                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Text('No categories found.');
//                 }

//                 options = snapshot.data!;
//                 options.addAll(selectedCategories);

//                 return Stack(
//                   alignment: Alignment.center,
//                   children: [

//                     Container(
//                       height: 600,
//                       width: 750,
//                       decoration: BoxDecoration(
//                         color: Colors.amber,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Container(

//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Color(0xFF101F3C),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(20),
//                           child: FortuneWheel(
//                             onAnimationEnd: () {
//                               print("function call");

//                               print("${options}");
//                             },
//                             selected: controller.stream,
//                             hapticImpact: HapticImpact.heavy,
//                             indicators: const <FortuneIndicator>[
//                               FortuneIndicator(
//                                 alignment: Alignment.topCenter,
//                                 child: TriangleIndicator(color: Colors.yellow),
//                               ),
//                             ],
//                             items: [
//                               for (int i = 0; i < options.length && i < 20; i++)
//                                 FortuneItem(
//                                   child: Text(
//                                     options[i],
//                                     style: const TextStyle(color: Colors.white),
//                                   ),
//                                   style: FortuneItemStyle(
//                                     color:
//                                         segmentColors[i % segmentColors.length],
//                                     borderColor: Colors.white,
//                                     borderWidth: 1,
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),

//                     Positioned(
//                       child: GestureDetector(
//                         onTap: () {
//                           final selected = Random().nextInt(options.length);
//                           controller.add(selected);
//                           // selectedValue = options[selected];
//                           // value = options[selected];
//                           print("Selected index: $selected");
//                           print("Selected value: $selectedValue");
//                           //  setState(() {
//                           //     selectedValue = options[selected];
//                           //   });

//                           print("Selected index: $selected");
//                           print("Selected value: $selectedValue");
//                           print("value ${value}");
//                         },
//                         child: Container(
//                           height: 80,
//                           width: 80,
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.blueAccent,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black38,
//                                 blurRadius: 10,
//                                 offset: Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: const Center(
//                             child: Text(
//                               'SPIN',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                                 letterSpacing: 1.2,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),

//                   ],
//                 );
//               },
//             ),
//           )

//                 : Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Container(
//                         height: 600,
//                         width: 750,
//                         decoration: BoxDecoration(
//                           color: Colors.amber,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Container(
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Color(0xFF101F3C),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(20),
//                             child: FortuneWheel(
//                               onAnimationEnd: () {
//                                 print("function call");
//                                 print("${selectedCategories}");
//                               },
//                               selected: controller.stream,
//                               hapticImpact: HapticImpact.heavy,
//                               indicators: const <FortuneIndicator>[
//                                 FortuneIndicator(
//                                   alignment: Alignment.topCenter,
//                                   child: TriangleIndicator(color: Colors.yellow),
//                                 ),
//                               ],
//                               items: [
//                                 for (int i = 0; i < selectedCategories.length; i++)
//                                   FortuneItem(
//                                     child: Text(
//                                       selectedCategories[i],
//                                       style: const TextStyle(color: Colors.white),
//                                     ),
//                                     style: FortuneItemStyle(
//                                       color: segmentColors[i % segmentColors.length],
//                                       borderColor: Colors.white,
//                                       borderWidth: 1,
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         child: GestureDetector(
//                           onTap: () {
//                             final selected = Random().nextInt(selectedCategories.length);
//                             controller.add(selected);
//                             selectedValue = selectedCategories[selected];

//                             print("Selected index: $selected");
//                             print("Selected value: $selectedValue");
//                           },
//                           child: Container(
//                             height: 80,
//                             width: 80,
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.blueAccent,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black38,
//                                   blurRadius: 10,
//                                   offset: Offset(0, 4),
//                                 ),
//                               ],
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 'SPIN',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                   letterSpacing: 1.2,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//           // const SizedBox(height: 20),
//           if (selectedCategories.isNotEmpty)
//             ElevatedButton(
//               onPressed: () {
//                 if (allCategories.isEmpty) {
//                   loadCategories().then((_) {
//                     showCategorySelectionDialog();
//                   });
//                 } else {
//                   showCategorySelectionDialog();
//                 }
//               },
//               child: const Text('Edit Categories'),
//             ),

//                  Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // const SizedBox(height: 100),
//                       const Text(
//                         'No categories selected',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                         ),
//                       ),
//                       // const SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: () {
//                           if (allCategories.isEmpty) {
//                             loadCategories().then((_) {
//                               showCategorySelectionDialog();
//                             });
//                           } else {
//                             showCategorySelectionDialog();
//                           }
//                         },
//                         child: const Text('Choose Categories'),
//                       ),
//                     ],
//                   )

//         ],
//       ),
//     );
//   }
// }

class WheelScreen extends StatefulWidget {
  const WheelScreen({super.key});

  @override
  State<WheelScreen> createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> {
  StreamController<int> controller = StreamController<int>.broadcast();
  late CollectionReference categoriesCollection;
  String? selectedValue;
  DocumentSnapshot? selectedCategoryDocument;

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  var value;
  List<String> options = [];

  Future<List<String>> getCategories() async {
    categoriesCollection = FirebaseFirestore.instance.collection('Catagories');
    QuerySnapshot snapshot = await categoriesCollection.get();
    return snapshot.docs.map((doc) => doc['catagoryName'].toString()).toList();
  }

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
    Colors.lime,
    Colors.deepOrange,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.purple,
    Colors.yellow,
    Colors.brown,
    Colors.blueGrey,
  ];

  List<String> allCategories = [];
  List<String> selectedCategories = [];
  Map<String, bool> categoryCheckboxes = {};

  Future<void> loadCategories() async {
    allCategories = await getCategories();

    for (var category in allCategories) {
      categoryCheckboxes[category] = false;
    }
    setState(() {});
  }

  Future<void> showCategorySelectionDialog() async {
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
              title: Text('Choose Categories (${selectedCount}/10)'),
              content: Container(
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
                              if (value == true && selectedCount >= 10) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Maximum 10 categories allowed!',
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                return;
                              }

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
                  onPressed: () {
                    setState(() {
                      categoryCheckboxes = tempCheckboxes;
                      selectedCategories = categoryCheckboxes.entries
                          .where((entry) => entry.value == true)
                          .map((entry) => entry.key)
                          .toList();
                    });

                    print('Selected Categories: $selectedCategories');
                    Navigator.of(context).pop();
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  int? selectedIndex;
  late CollectionReference productsCollection;
  DocumentReference? selectedCategoryRef;
  List<Map<String, dynamic>> categoryProducts = [];
  bool isLoadingProducts = false;

  Future<void> fetchSelectedCategoryDocument(String categoryName) async {
    try {
      print("Fetching document for category: $categoryName");

      QuerySnapshot categorySnapshot = await FirebaseFirestore.instance
          .collection('Catagories')
          .where('catagoryName', isEqualTo: categoryName)
          .limit(1)
          .get();

      if (categorySnapshot.docs.isNotEmpty) {
        // Category ka document mil gaya
        selectedCategoryDocument = categorySnapshot.docs.first;
        selectedCategoryRef = selectedCategoryDocument!.reference;

        // Document ka data print karo
        print("✅ Category Document Found!");
        print("document $selectedCategoryDocument");
        print("Document ID: ${selectedCategoryDocument!.id}");
        print("Document Reference: ${selectedCategoryRef!.path}");
        print("Document Data: ${selectedCategoryDocument!.data()}");
       var docData = selectedCategoryDocument!.data();
       print("docData $docData");

        // Document ko setState mein store karo taake use kar sako
        // setState(() {});

        // Agar aap yahan se products bhi fetch karna chahte ho
        // to uncomment kar dein:
        // await fetchProductsByCategory();
      } else {
        print("❌ Category document not found: $categoryName");
        selectedCategoryDocument = null;
        selectedCategoryRef = null;
      }
    } catch (e) {
      print("❌ Error fetching category document: $e");
      selectedCategoryDocument = null;
      selectedCategoryRef = null;
    }
  }

  bool isSpinning = false;
  @override
  Widget build(BuildContext context) {
    List<String> wheelCategories = selectedCategories.isEmpty
        ? options
        : selectedCategories;

    return Column(
      children: [
        Expanded(
          child: Center(
            child: FutureBuilder<List<String>>(
              future: getCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text(
                    'No categories found.',
                    style: TextStyle(color: Colors.white),
                  );
                }

                options = snapshot.data!;

                wheelCategories = selectedCategories.isEmpty
                    ? options
                    : selectedCategories;

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 600,
                      width: 750,
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
                          padding: const EdgeInsets.all(20),
                          child: FortuneWheel(
                            //   onAnimationEnd: () async{
                            //     print("function call");
                            //     print("Wheel categories: ${wheelCategories}");
                            //               if (wheelCategories.isNotEmpty) {
                            //   final selected = Random().nextInt(
                            //     wheelCategories.length,
                            //   );
                            //   // controller.add(selected);
                            //   selectedValue = wheelCategories[selected];
                            //     //  await fetchSelectedCategoryDocument(selectedValue!);

                            //   print("Selected index: $selected");
                            //   print("Selected value: $selectedValue");
                            // }
                            //   },
                            onAnimationEnd: () async {
                              print(
                                "Wheel stopped. Selected value: $selectedValue",
                              );
                              if (selectedValue != null) {
                                await fetchSelectedCategoryDocument(
                                  selectedValue!,
                                );
                              }
                              isSpinning = false; // allow next spin
                            },
                            selected: controller.stream,
                            hapticImpact: HapticImpact.heavy,
                            indicators: const <FortuneIndicator>[
                              FortuneIndicator(
                                alignment: Alignment.topCenter,
                                child: TriangleIndicator(color: Colors.yellow),
                              ),
                            ],
                            items: [
                              for (
                                int i = 0;
                                i < wheelCategories.length && i < 10;
                                i++
                              )
                                FortuneItem(
                                  child: Text(
                                    wheelCategories[i],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  style: FortuneItemStyle(
                                    color:
                                        segmentColors[i % segmentColors.length],
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
                        // onTap: () async{
                        //   if (wheelCategories.isNotEmpty) {
                        //     final selected = Random().nextInt(
                        //       wheelCategories.length,
                        //     );
                        //     // controller.add(selected);
                        //     selectedValue = wheelCategories[selected];
                        //       //  await fetchSelectedCategoryDocument(selectedValue!);
                        //     print("Selected index: $selected");
                        //     print("Selected value: $selectedValue");
                        //   }
                        // },
                        onTap: () async {
                          if (isSpinning || wheelCategories.isEmpty) return;

                          isSpinning = true;
                          final selected = Random().nextInt(
                            wheelCategories.length,
                          );
                          selectedValue = wheelCategories[selected];
                          controller.add(selected);

                          print("Wheel spinning...");
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
                          child: const Center(
                            child: Text(
                              'SPIN',
                              style: TextStyle(
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
                );
              },
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              if (selectedCategories.isNotEmpty)
                Text(
                  'Showing ${selectedCategories.length} selected categories',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (allCategories.isEmpty) {
                    loadCategories().then((_) {
                      showCategorySelectionDialog();
                    });
                  } else {
                    showCategorySelectionDialog();
                  }
                },
                child: Text(
                  selectedCategories.isEmpty
                      ? 'Choose Categories'
                      : 'Edit Categories',
                ),
              ),
              // Text(
              //                 '${selectedCategoryDocument}',
              //                 style: TextStyle(
              //                   color: Colors.black,
              //                   fontWeight: FontWeight.bold,
              //                   fontSize: 16,
              //                   letterSpacing: 1.2,
              //                 ),
              //               ),
            ],
          ),
        ),
      ],
    );
  }
}

// class WheelScreen extends StatefulWidget {
//   const WheelScreen({super.key});

//   @override
//   State<WheelScreen> createState() => _WheelScreenState();
// }

// class _WheelScreenState extends State<WheelScreen> {
//   StreamController<int> controller = StreamController<int>.broadcast();
//   late CollectionReference categoriesCollection;
//   String? selectedValue;
//   DocumentSnapshot? selectedCategoryDocument;

//   @override
//   void dispose() {
//     controller.close();
//     super.dispose();
//   }

//   var value;
//   List<String> options = [];

//   Future<List<String>> getCategories() async {
//     categoriesCollection = FirebaseFirestore.instance.collection('Catagories');
//     QuerySnapshot snapshot = await categoriesCollection.get();
//     return snapshot.docs.map((doc) => doc['catagoryName'].toString()).toList();
//   }

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
//     Colors.lime,
//     Colors.deepOrange,
//     Colors.lightBlue,
//     Colors.lightGreen,
//     Colors.purple,
//     Colors.yellow,
//     Colors.brown,
//     Colors.blueGrey,
//   ];

//   List<String> allCategories = [];
//   List<String> selectedCategories = [];
//   Map<String, bool> categoryCheckboxes = {};

//   Future<void> loadCategories() async {
//     allCategories = await getCategories();

//     for (var category in allCategories) {
//       categoryCheckboxes[category] = false;
//     }
//     setState(() {});
//   }

//   Future<void> showCategorySelectionDialog() async {
//     Map<String, bool> tempCheckboxes = Map.from(categoryCheckboxes);

//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             int selectedCount = tempCheckboxes.values
//                 .where((v) => v == true)
//                 .length;

//             return AlertDialog(
//               title: Text('Choose Categories (${selectedCount}/10)'),
//               content: Container(
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
//                               if (value == true && selectedCount >= 10) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text(
//                                       'Maximum 10 categories allowed!',
//                                     ),
//                                     duration: Duration(seconds: 2),
//                                   ),
//                                 );
//                                 return;
//                               }

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
//                   onPressed: () {
//                     setState(() {
//                       categoryCheckboxes = tempCheckboxes;
//                       selectedCategories = categoryCheckboxes.entries
//                           .where((entry) => entry.value == true)
//                           .map((entry) => entry.key)
//                           .toList();
//                     });

//                     print('Selected Categories: $selectedCategories');
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('Update'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   int? selectedIndex;
//   late CollectionReference productsCollection;
//   DocumentReference? selectedCategoryRef;
//   List<Map<String, dynamic>> categoryProducts = [];
//   bool isLoadingProducts = false;

//   Future<void> fetchSelectedCategoryDocument(String categoryName) async {
//     try {
//       print("Fetching document for category: $categoryName");

//       QuerySnapshot categorySnapshot = await FirebaseFirestore.instance
//           .collection('Catagories')
//           .where('catagoryName', isEqualTo: categoryName)
//           .limit(1)
//           .get();

//       if (categorySnapshot.docs.isNotEmpty) {
//         selectedCategoryDocument = categorySnapshot.docs.first;
//         selectedCategoryRef = selectedCategoryDocument!.reference;

//         print("✅ Category Document Found!");
//         print("Document ID: ${selectedCategoryDocument!.id}");
//         print("Document Reference: ${selectedCategoryRef!.path}");
//         print("Document Data: ${selectedCategoryDocument!.data()}");

//         setState(() {});

//       } else {
//         print("❌ Category document not found: $categoryName");
//         selectedCategoryDocument = null;
//         selectedCategoryRef = null;
//       }
//     } catch (e) {
//       print("❌ Error fetching category document: $e");
//       selectedCategoryDocument = null;
//       selectedCategoryRef = null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<String> wheelCategories = selectedCategories.isEmpty
//         ? options
//         : selectedCategories;

//     return Column(
//       children: [
//         Expanded(
//           child: Center(
//             child: FutureBuilder<List<String>>(
//               future: getCategories(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const CircularProgressIndicator();
//                 }

//                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Text(
//                     'No categories found.',
//                     style: TextStyle(color: Colors.white),
//                   );
//                 }

//                 options = snapshot.data!;

//                 wheelCategories = selectedCategories.isEmpty
//                     ? options
//                     : selectedCategories;

//                 return Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Container(
//                       height: 600,
//                       width: 750,
//                       decoration: BoxDecoration(
//                         color: Colors.amber,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Container(
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Color(0xFF101F3C),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(20),
//                           child: FortuneWheel(
//                             onAnimationEnd: () async {
//                               // Sirf selected value fetch karo, dobara spin mat karo
//                               print("Wheel stopped!");
//                               print("Selected value: $selectedValue");

//                             },
//                             selected: controller.stream,
//                             hapticImpact: HapticImpact.heavy,
//                             indicators: const <FortuneIndicator>[
//                               FortuneIndicator(
//                                 alignment: Alignment.topCenter,
//                                 child: TriangleIndicator(color: Colors.yellow),
//                               ),
//                             ],
//                             items: [
//                               for (
//                                 int i = 0;
//                                 i < wheelCategories.length && i < 10;
//                                 i++
//                               )
//                                 FortuneItem(
//                                   child: Text(
//                                     wheelCategories[i],
//                                     style: const TextStyle(color: Colors.white),
//                                   ),
//                                   style: FortuneItemStyle(
//                                     color:
//                                         segmentColors[i % segmentColors.length],
//                                     borderColor: Colors.white,
//                                     borderWidth: 1,
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       child: GestureDetector(
//                         onTap: () async{
//                           if (wheelCategories.isNotEmpty) {
//                             final selected = Random().nextInt(
//                               wheelCategories.length,
//                             );
//                             // Pehle selected value store karo
//                             selectedValue = wheelCategories[selected];

//                               if (selectedValue != null) {
//                                 await fetchSelectedCategoryDocument(selectedValue!);
//                               }
//                             // Phir wheel ko spin karo
//                             controller.add(selected);

//                             print("Spinning to index: $selected");
//                             print("Target category: $selectedValue");
//                           }
//                         },
//                         child: Container(
//                           height: 80,
//                           width: 80,
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.blueAccent,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black38,
//                                 blurRadius: 10,
//                                 offset: Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: const Center(
//                             child: Text(
//                               'SPIN',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                                 letterSpacing: 1.2,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ),

//         Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               if (selectedCategories.isNotEmpty)
//                 Text(
//                   'Showing ${selectedCategories.length} selected categories',
//                   style: const TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   if (allCategories.isEmpty) {
//                     loadCategories().then((_) {
//                       showCategorySelectionDialog();
//                     });
//                   } else {
//                     showCategorySelectionDialog();
//                   }
//                 },
//                 child: Text(
//                   selectedCategories.isEmpty
//                       ? 'Choose Categories'
//                       : 'Edit Categories',
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

class DottedCirclePainter extends CustomPainter {
  final Color dotColor;

  DottedCirclePainter({required this.dotColor});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint dotPaint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;

    final int dotCount = 24;
    final double dotRadius = 6;

    final double innerRadius = radius - dotRadius - 10;

    for (int i = 0; i < dotCount; i++) {
      final double angle = (2 * pi * i) / dotCount;
      final double x = center.dx + innerRadius * cos(angle);
      final double y = center.dy + innerRadius * sin(angle);
      canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}




// Automatic FlutterFlow imports
// import '/backend/backend.dart';
// import '/backend/schema/structs/index.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/custom_code/widgets/index.dart'; // Imports other custom widgets
// import '/custom_code/actions/index.dart'; // Imports custom actions
// import '/flutter_flow/custom_functions.dart'; // Imports custom functions
// import 'package:flutter/material.dart';
// // Begin custom widget code
// // DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// import 'dart:math';

// import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

// import 'dart:async';

// class WheelWidget extends StatefulWidget {
//   const WheelWidget({
//     super.key,
//     this.width,
//     this.height,
//   });

//   final double? width;
//   final double? height;

//   @override
//   State<WheelWidget> createState() => _WheelWidgetState();
// }

// class _WheelWidgetState extends State<WheelWidget> {
//   StreamController<int> controller = StreamController<int>();
//   late CollectionReference categoriesCollection;
//   String? selectedValue;
//   List<String> options = [];

//   Future<List<String>> getCategories() async {
//     categoriesCollection = FirebaseFirestore.instance.collection('Catagories');

//     QuerySnapshot snapshot = await categoriesCollection.get();
//     return snapshot.docs
//         .map(
//           (doc) => doc['catagoryName'].toString(),
//         ) // assuming you have a 'name' field
//         .toList();
//   }

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
//     Colors.lime,
//     Colors.deepOrange,
//     Colors.lightBlue,
//     Colors.lightGreen,
//     Colors.purple,
//     Colors.yellow,
//     Colors.brown,
//     Colors.blueGrey,
//   ];

//   int? selectedIndex;
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: FutureBuilder<List<String>>(
//         future: getCategories(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const CircularProgressIndicator();
//           }

//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Text('No categories found.');
//           }

//           options = snapshot.data!;

//           return Stack(
//             alignment: Alignment.center,
//             children: [
//               // CustomPaint(
//               //   painter: DottedCirclePainter(
//               //     dotColor: Colors.yellowAccent,
//               //   ),
//               //   size: const Size(430, 430),
//               // ),
//               Container(
//                 height: 410,
//                 width: 410,
//                 decoration: BoxDecoration(
//                   color: Colors.amber,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Container(
//                   height: 350,
//                   width: 350,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Color(0xFF101F3C),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: FortuneWheel(
//                       onAnimationEnd: () {
//                         print("function call");

//                         print("${options}");
//                       },
//                       selected: controller.stream,
//                       hapticImpact: HapticImpact.heavy,
//                       indicators: const <FortuneIndicator>[
//                         FortuneIndicator(
//                           alignment: Alignment.topCenter,
//                           child: TriangleIndicator(color: Colors.yellow),
//                         ),
//                       ],
//                       items: [
//                         for (int i = 0; i < options.length; i++)
//                           FortuneItem(
//                             child: Text(
//                               options[i],
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                             style: FortuneItemStyle(
//                               color: segmentColors[i % segmentColors.length],
//                               borderColor: Colors.white,
//                               borderWidth: 1,
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 child: GestureDetector(
//                   onTap: () {
//                     final selected = Random().nextInt(options.length);
//                     controller.add(selected);
//                     selectedValue = options[selected];
//                     print("Selected index: $selected");
//                     print("Selected value: $selectedValue");
//                     //  setState(() {
//                     //     selectedValue = options[selected];
//                     //   });

//                     print("Selected index: $selected");
//                     print("Selected value: $selectedValue");
//                   },
//                   child: Container(
//                     height: 80,
//                     width: 80,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.blueAccent,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black38,
//                           blurRadius: 10,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: const Center(
//                       child: Text(
//                         'SPIN',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           letterSpacing: 1.2,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }