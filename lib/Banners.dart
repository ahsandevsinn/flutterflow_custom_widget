import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
class Banners extends StatefulWidget {
  const Banners({super.key});

  @override
  State<Banners> createState() => _BannersState();
}

class _BannersState extends State<Banners> {
  // Change from List<String> to List<Map<String, dynamic>>
  List<Map<String, dynamic>> bannerItems = [];

  final ScrollController _scrollController = ScrollController();
  double scrollPosition = 0;
  Timer? autoScrollTimer;

  @override
  void initState() {
    super.initState();
    fetchBanners();
  }

  @override
  void dispose() {
    autoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchBanners() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore.collection('Banner').get();

      List<Map<String, dynamic>> items = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();

        items.add({
          "image": data["image"] ?? "",
          "bannerName": data["bannerName"] ?? "", 
            "CatagoryRef": data["CatagoryRef"],   // Add category reference
          "SubCatagoryRef": data["SubCatagoryRef"],
        });
      }

      setState(() {
        bannerItems = items;
      });

      if (items.isNotEmpty) startAutoScroll();
    } catch (e) {
      print("Error fetching banners: $e");
      setState(() {
        bannerItems = [];
      });
    }
  }


  void startAutoScroll() {
    autoScrollTimer = Timer.periodic(Duration(milliseconds: 25), (timer) {
      if (!_scrollController.hasClients) return;

      scrollPosition += 1;

      final maxScroll = _scrollController.position.maxScrollExtent;
      _scrollController.jumpTo(scrollPosition % (maxScroll + 200));
    });
  }
   navigateToCategoryOrSubCategory(Map<String, dynamic> bannerItem)async {
   
    final categoryRef = bannerItem["CatagoryRef"];
    final subcategoryRef = bannerItem["SubCatagoryRef"];

    if (categoryRef != null) {
      if (subcategoryRef != null) {
          DocumentSnapshot subCatagoryDoc = await subcategoryRef.get();
          log("subCatagoryDoc ${subCatagoryDoc.data()}");
        // Navigate to the subcategory page
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => SubCategoryPage(subcategoryRef: subcategoryRef),
        //   ),
        // );
        log("Sub Catagory");
      } else {
        log("Catagory");
         DocumentSnapshot catDoc = await categoryRef.get();
         log("catDoc ${catDoc.data()}");
        //  log("catDoc ${catDoc}");

        // Navigate to the category page
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => CategoryPage(categoryRef: categoryRef),
        //   ),
        // );
      }
    }
  }

    //  DocumentSnapshot doc = categorySnapshot.docs.first;

    //     selectedCategoryRecord = CatagoriesRecord.fromSnapshot(doc);
  @override
  Widget build(BuildContext context) {
    final safeItems = bannerItems;

    return Scaffold(
      appBar: AppBar(title: Text("Banners")),
      body: Column(
        children: [
          Container(
            height: 50,
            color: Colors.black,
            child: safeItems.isEmpty
                ? Center(
                    child: Text(
                      "Loading banners...",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: safeItems.length * 1000,
                    itemBuilder: (context, index) {
                      final item = safeItems[index % safeItems.length];
                      final imageUrl = item["image"];
                      final text = item["bannerName"];

                      return GestureDetector(
                        onTap: () => navigateToCategoryOrSubCategory(item),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                             
                              Text(
                                text,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                        
                              const SizedBox(width: 8),
                        
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  imageUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          
        ],
      ),
    );
  }
}



//  context.pushNamed(
//           "EventsEntertainmentScreenCopy",
//           extra: <String, dynamic>{
//             "catagories": selectedCategoryRecord,
//           },
//         );Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 12),
                //   child: Row(
                //     children: [
                //       Text(
                //         text,
                //         style: TextStyle(
                //           color:
                //               FlutterFlowTheme.of(context).dashboardSelection,
                //           fontSize: 18,
                //           fontFamily: 'Courier',
                //         ),
                //       ),
                //       const SizedBox(width: 20),
                //       ClipRRect(
                //         borderRadius: BorderRadius.circular(8),
                //         child: Image.network(
                //           imageUrl,
                //           width: 40,
                //           height: 40,
                //           fit: BoxFit.cover,
                //         ),
                //       ),
                //       const SizedBox(width: 20),
                //     ],
                //   ),
                // );