import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() =>
      _ComplaintScreenState();
}

class _ComplaintScreenState
    extends State<ComplaintScreen> {

  final titleController =
      TextEditingController();

  final descController =
      TextEditingController();

  bool loading = false;

  File? selectedImage;

  final ImagePicker picker =
      ImagePicker();

  // ☁ CLOUDINARY DETAILS
  // 🔥 REPLACE WITH YOUR REAL VALUES
  final String cloudName =
      "dr4nwpajc";

  final String uploadPreset =
      "smart_village_upload";

  // 📷 PICK IMAGE
  Future<void> pickImage(
      ImageSource source) async {

    final XFile? image =
        await picker.pickImage(
      source: source,
    );

    if (image != null) {

      setState(() {

        selectedImage =
            File(image.path);
      });
    }
  }

  // ☁ UPLOAD IMAGE
  Future<String> uploadImage() async {

    try {

      if (selectedImage == null) {
        return "";
      }

      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );

      var request =
          http.MultipartRequest(
        "POST",
        url,
      );

      request.fields['upload_preset'] =
          uploadPreset;

      request.files.add(
        await http.MultipartFile
            .fromPath(
          'file',
          selectedImage!.path,
        ),
      );

      var response =
          await request.send();

      var responseData =
          await response.stream
              .bytesToString();

      print(responseData);

      var data =
          jsonDecode(responseData);

      // ✅ SUCCESS
      if (data['secure_url'] != null) {

        return data['secure_url'];
      }

      return "";

    } catch (e) {

      print("UPLOAD ERROR: $e");

      return "";
    }
  }

  // 🚀 SUBMIT COMPLAINT
  Future<void> submitComplaint() async {

    if (titleController.text.isEmpty ||
        descController.text.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text("Fill all fields"),
        ),
      );

      return;
    }

    setState(() {
      loading = true;
    });

    // ☁ Upload image
    String imageUrl =
        await uploadImage();

    // 🔥 Save complaint
    await FirebaseFirestore.instance
        .collection('complaints')
        .add({

      'title':
          titleController.text.trim(),

      'description':
          descController.text.trim(),

      'image': imageUrl,

      'status': 'Pending',

      'time': Timestamp.now(),
    });

    titleController.clear();
    descController.clear();

    setState(() {

      selectedImage = null;
      loading = false;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content:
            Text("Complaint Submitted"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
            const Text("Complaints"),
        centerTitle: true,
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
              const EdgeInsets.all(16),

          child: Column(
            children: [

              // 📌 TITLE
              TextField(
                controller:
                    titleController,

                decoration:
                    InputDecoration(
                  labelText:
                      "Complaint Title",

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                                12),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 📝 DESCRIPTION
              TextField(
                controller:
                    descController,

                maxLines: 3,

                decoration:
                    InputDecoration(
                  labelText:
                      "Description",

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                                12),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // 🖼 IMAGE PREVIEW
              if (selectedImage != null)

                ClipRRect(

                  borderRadius:
                      BorderRadius
                          .circular(
                              12),

                  child: Image.file(

                    selectedImage!,

                    height: 180,

                    width:
                        double.infinity,

                    fit: BoxFit.cover,
                  ),
                ),

              const SizedBox(height: 10),

              // 📷 BUTTONS
              Row(
                children: [

                  Expanded(
                    child:
                        ElevatedButton.icon(

                      onPressed: () {

                        pickImage(
                          ImageSource
                              .camera,
                        );
                      },

                      icon: const Icon(
                        Icons.camera_alt,
                      ),

                      label: const Text(
                        "Camera",
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child:
                        ElevatedButton.icon(

                      onPressed: () {

                        pickImage(
                          ImageSource
                              .gallery,
                        );
                      },

                      icon: const Icon(
                        Icons.image,
                      ),

                      label: const Text(
                        "Gallery",
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // 🚀 SUBMIT BUTTON
              SizedBox(
                width:
                    double.infinity,
                height: 50,

                child:
                    ElevatedButton(

                  onPressed:
                      loading
                          ? null
                          : submitComplaint,

                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        Colors.green,
                  ),

                  child: loading

                      ? const CircularProgressIndicator(
                          color:
                              Colors
                                  .white,
                        )

                      : const Text(
                          "Submit Complaint",

                          style:
                              TextStyle(
                            color:
                                Colors
                                    .white,
                            fontSize:
                                16,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              const Divider(),

              const SizedBox(height: 10),

              // 📋 COMPLAINTS
              StreamBuilder<QuerySnapshot>(

                stream:
                    FirebaseFirestore
                        .instance
                        .collection(
                            'complaints')
                        .orderBy(
                          'time',
                          descending:
                              true,
                        )
                        .snapshots(),

                builder:
                    (context, snapshot) {

                  if (!snapshot
                      .hasData) {

                    return const Center(
                      child:
                          CircularProgressIndicator(),
                    );
                  }

                  var complaints =
                      snapshot.data!.docs;

                  if (complaints
                      .isEmpty) {

                    return const Text(
                      "No complaints found",
                    );
                  }

                  return ListView.builder(

                    shrinkWrap: true,

                    physics:
                        const NeverScrollableScrollPhysics(),

                    itemCount:
                        complaints.length,

                    itemBuilder:
                        (context, index) {

                      var map =
                          complaints[index]
                                  .data()
                              as Map<
                                  String,
                                  dynamic>;

                      String status =
                          map['status'] ??
                              'Pending';

                      return Card(

                        margin:
                            const EdgeInsets
                                .only(
                          bottom: 12,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                                      12),
                        ),

                        child: Padding(

                          padding:
                              const EdgeInsets
                                  .all(12),

                          child: Column(

                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              // 📌 TITLE
                              Text(

                                map['title'] ??
                                    '',

                                style:
                                    const TextStyle(
                                  fontSize:
                                      18,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),

                              const SizedBox(
                                  height:
                                      8),

                              // 📝 DESCRIPTION
                              Text(
                                map['description'] ??
                                    '',
                              ),

                              // 🖼 IMAGE
                              if (map['image'] !=
                                      null &&
                                  map['image'] !=
                                      "")

                                Padding(

                                  padding:
                                      const EdgeInsets
                                          .only(
                                    top: 10,
                                    bottom:
                                        10,
                                  ),

                                  child:
                                      ClipRRect(

                                    borderRadius:
                                        BorderRadius.circular(
                                            12),

                                    child:
                                        Image.network(

                                      map['image'],

                                      height:
                                          180,

                                      width:
                                          double.infinity,

                                      fit: BoxFit
                                          .cover,
                                    ),
                                  ),
                                ),

                              // 🚦 STATUS
                              Row(
                                children: [

                                  const Text(
                                    "Status: ",

                                    style:
                                        TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),

                                  Container(

                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                      horizontal:
                                          10,
                                      vertical:
                                          4,
                                    ),

                                    decoration:
                                        BoxDecoration(

                                      color: status ==
                                              'Solved'
                                          ? Colors.green
                                              .withOpacity(
                                                  0.2)
                                          : Colors.orange
                                              .withOpacity(
                                                  0.2),

                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                                  8),
                                    ),

                                    child:
                                        Text(

                                      status,

                                      style:
                                          TextStyle(

                                        color: status ==
                                                'Solved'
                                            ? Colors
                                                .green
                                            : Colors
                                                .orange,

                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}