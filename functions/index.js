const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendNotificationOnComplaint = functions.firestore
  .document("complaints/{id}")
  .onCreate(async (snapshot, context) => {
    const data = snapshot.data();

    const message = {
      notification: {
        title: "New Complaint 📝",
        body: data.title || "A new complaint has been submitted",
      },
      topic: "all_users",
    };

    await admin.messaging().send(message);
  });