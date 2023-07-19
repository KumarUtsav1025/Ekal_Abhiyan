# Ekal-Abhiyan Instructor App

## For the developers
Flutter version required: 2.10.5

### Step 1: Get all the dependencies
```bash
flutter pub get
```

### Step 2: Authorization
To do this, first of all, you have to generate an SHA-1 and an SHA-256 fingerprint, then request the Firebase Admin to add your fingerprint to the Firebase app.
To generate the fingerprints, first move to the root directory of the project, then:
```bash
cd android
./gradlew signingReport
```
This will generate the above-mentioned fingerprints.

### Step 3: Debug the app now.
```bash
flutter run --no-sound-null-safety
```

Happy Debugging!!!🙂
