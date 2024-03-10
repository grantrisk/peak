const admin = require("firebase-admin");
const fs = require("fs");

const serviceAccount = require("../firebase_keys/firebase-adminsdk.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function deleteCustomExercises() {
  const exercisesRef = db.collection("default_exercises");
  const snapshot = await exercisesRef.where("custom", "==", false).get();

  if (snapshot.empty) {
    console.log("No matching documents to delete.");
    return;
  }

  // Delete documents
  const deletePromises = snapshot.docs.map((doc) => doc.ref.delete());
  await Promise.all(deletePromises);
  console.log("Custom=false documents successfully deleted.");
}

async function recreateExercisesWithAdditionalFields() {
  const exercisesData = JSON.parse(
    fs.readFileSync("./scripts/resources/workouts.json", "utf8"),
  );
  const categories = Object.keys(exercisesData); // Get all categories (e.g., "shoulders")

  const createPromises = categories.flatMap((category) =>
    exercisesData[category].map((exercise) => {
      // Assuming 'sets' and 'custom' are not part of your JSON and need default values or computation
      const defaultSets = []; // Replace with default sets if any
      const defaultCustom = false; // Set a default value for 'custom'
      const defaultOwner = "PEAK"; // Set a default value for 'owner'

      // Mapping the JSON structure to the desired Firestore document structure
      const exerciseDoc = {
        id: exercise.id,
        name: exercise.name,
        primaryMuscle: exercise.muscles_worked.primary,
        secondaryMuscles: exercise.muscles_worked.secondary || [],
        sets: defaultSets || [],
        custom: defaultCustom,
        owner: defaultOwner,
      };

      // Creating/updating the document in Firestore
      return db
        .collection("default_exercises")
        .doc(exercise.id)
        .set(exerciseDoc);
    }),
  );

  await Promise.all(createPromises);
  console.log("Exercises with additional fields recreated from JSON.");
}

async function manageExercises() {
  await deleteCustomExercises();
  await recreateExercisesWithAdditionalFields();
}

manageExercises().catch(console.error);
