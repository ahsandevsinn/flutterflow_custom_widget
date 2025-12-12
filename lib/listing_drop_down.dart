
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                            child: Text(category['name']),
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
        if (subCategories.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xfffcf8ea),
                border: Border.all(color: Color(0xfffc6e50)),
                borderRadius: BorderRadius.circular(8.0),
              ),
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
                              child: Text(subCategory['name']),
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
        if (subCategories.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text('No sub-categories available for this category.'),
          ),
      ],
    );
  }
}
