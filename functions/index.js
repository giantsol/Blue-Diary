const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const db = admin.firestore();

exports.getTodayInMillis = functions.https.onCall((data, context) => {
    return Date.now();
});

exports.setMyRankingUserInfo = functions.https.onCall(async (data, context) => {
    const currentInMillis = Date.now();
    const uid = data.uid;
    const modifiedData = data;
    modifiedData.last_updated_millis = currentInMillis;
    await db.collection('ranking_user_info').doc(uid).set(modifiedData, { merge: true });
});
