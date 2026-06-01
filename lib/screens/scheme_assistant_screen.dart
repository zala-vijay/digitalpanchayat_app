import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SchemeAssistantScreen extends StatefulWidget {
  const SchemeAssistantScreen({super.key});

  @override
  State<SchemeAssistantScreen> createState() =>
      _SchemeAssistantScreenState();
}

class _SchemeAssistantScreenState
    extends State<SchemeAssistantScreen> {

  final ageController =
      TextEditingController();

  final incomeController =
      TextEditingController();

  String occupation = "Farmer";
  String gender = "Male";

  List<String> eligibleSchemes = [];

  // 🔍 Find Schemes
  void findSchemes() {

    eligibleSchemes.clear();

    int age =
        int.tryParse(ageController.text) ?? 0;

    int income =
        int.tryParse(
              incomeController.text,
            ) ??
            0;

    // 🌾 Farmer Schemes
    if (occupation == "Farmer") {

      eligibleSchemes.add(
        "PM Kisan Samman Nidhi",
      );

      eligibleSchemes.add(
        "Kisan Credit Card Scheme",
      );
    }

    // 🎓 Student Schemes
    if (occupation == "Student") {

      eligibleSchemes.add(
        "National Scholarship Scheme",
      );

      eligibleSchemes.add(
        "Digital Education Scheme",
      );
    }

    // 👵 Senior Citizen
    if (age >= 60) {

      eligibleSchemes.add(
        "Old Age Pension Scheme",
      );
    }

    // 👩 Women Schemes
    if (gender == "Female") {

      eligibleSchemes.add(
        "Women Empowerment Scheme",
      );

      eligibleSchemes.add(
        "Free Sewing Machine Scheme",
      );
    }

    // 💰 Low Income
    if (income < 200000) {

      eligibleSchemes.add(
        "Free Ration Scheme",
      );

      eligibleSchemes.add(
        "Ayushman Bharat Yojana",
      );
    }

    setState(() {});
  }

  // 🌐 Open Government Website
  Future<void> openSchemeWebsite(
    String scheme,
  ) async {

    String url = "";

    // 🌾 Farmer Schemes
    if (scheme ==
        "PM Kisan Samman Nidhi") {

      url =
          "https://pmkisan.gov.in/";
    }

    else if (scheme ==
        "Kisan Credit Card Scheme") {

      url =
          "https://www.myscheme.gov.in/schemes/kcc";
    }

    // 🎓 Student Schemes
    else if (scheme ==
        "National Scholarship Scheme") {

      url =
          "https://scholarships.gov.in/";
    }

    else if (scheme ==
        "Digital Education Scheme") {

      url =
          "https://www.digitalindia.gov.in/";
    }

    // 👵 Pension
    else if (scheme ==
        "Old Age Pension Scheme") {

      url =
          "https://nsap.nic.in/";
    }

    // 👩 Women Schemes
    else if (scheme ==
        "Women Empowerment Scheme") {

      url =
          "https://wcd.nic.in/";
    }

    else if (scheme ==
        "Free Sewing Machine Scheme") {

      url =
          "https://www.india.gov.in/";
    }

    // 💰 Health / Ration
    else if (scheme ==
        "Free Ration Scheme") {

      url =
          "https://nfsa.gov.in/";
    }

    else if (scheme ==
        "Ayushman Bharat Yojana") {

      url =
          "https://pmjay.gov.in/";
    }

    try {

    final Uri uri = Uri.parse(url);

    await launchUrl(
      uri,

      mode:
          LaunchMode
              .externalApplication,
    );

    } catch (e) {
    
      ScaffoldMessenger.of(context)
          .showSnackBar(
          
        const SnackBar(
          content: Text(
            "Could not open website",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
            const Text(
                "Scheme Assistant"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // 👤 AGE
            TextField(
              controller: ageController,

              keyboardType:
                  TextInputType.number,

              decoration:
                  InputDecoration(
                labelText: "Age",

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                          12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 💰 INCOME
            TextField(
              controller:
                  incomeController,

              keyboardType:
                  TextInputType.number,

              decoration:
                  InputDecoration(
                labelText:
                    "Yearly Income",

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                          12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 👨 OCCUPATION
            DropdownButtonFormField(
              value: occupation,

              items: const [

                DropdownMenuItem(
                  value: "Farmer",
                  child: Text("Farmer"),
                ),

                DropdownMenuItem(
                  value: "Student",
                  child: Text("Student"),
                ),

                DropdownMenuItem(
                  value: "Worker",
                  child: Text("Worker"),
                ),
              ],

              onChanged: (value) {

                setState(() {
                  occupation =
                      value.toString();
                });
              },

              decoration:
                  InputDecoration(
                labelText:
                    "Occupation",

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                          12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 🚻 GENDER
            DropdownButtonFormField(
              value: gender,

              items: const [

                DropdownMenuItem(
                  value: "Male",
                  child: Text("Male"),
                ),

                DropdownMenuItem(
                  value: "Female",
                  child: Text("Female"),
                ),
              ],

              onChanged: (value) {

                setState(() {
                  gender =
                      value.toString();
                });
              },

              decoration:
                  InputDecoration(
                labelText: "Gender",

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                          12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔍 FIND BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(

                onPressed:
                    findSchemes,

                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      Colors.green,
                ),

                child: const Text(
                  "Find Schemes",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Eligible Schemes",

              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // 📋 SCHEMES
            if (eligibleSchemes.isEmpty)

              const Text(
                "No schemes found",
              )

            else

              ListView.builder(

                shrinkWrap: true,

                physics:
                    const NeverScrollableScrollPhysics(),

                itemCount:
                    eligibleSchemes.length,

                itemBuilder:
                    (context, index) {

                  return Card(

                    elevation: 4,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                              12),
                    ),

                    child: ListTile(

                      leading: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),

                      title: Text(
                        eligibleSchemes[index],

                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      subtitle: const Text(
                        "You are eligible for this scheme",
                      ),

                      trailing:
                          ElevatedButton(

                        onPressed: () {

                          openSchemeWebsite(
                            eligibleSchemes[
                                index],
                          );
                        },

                        style:
                            ElevatedButton
                                .styleFrom(
                          backgroundColor:
                              Colors.green,
                        ),

                        child: const Text(
                          "Apply",

                          style: TextStyle(
                            color:
                                Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}