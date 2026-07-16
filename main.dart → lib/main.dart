# DeltaBot Monitor — Flutter App

Yeh sirf app ka **Dart source code** (`lib/`) + `pubspec.yaml` hai.

## ✅ Sabse aasan free tarika — GitHub Actions (koi installation nahi)

Is folder mein `.github/workflows/build_apk.yml` already bana hua hai - GitHub
par push karte hi APK **cloud mein khud-ba-khud** ban jaayegi, aapke computer
par kuch bhi install karne ki zaroorat nahi.

1. https://github.com par free account banao (agar nahi hai).
2. Naya **repository** banao (Public ya Private, dono free hain) - "Create a
   new repository" → koi bhi naam do (jaise `deltabot-monitor-app`).
3. Us repo ke andar is `flutter_app` folder ka **poora content** upload karo:
   - Repo page par "Add file" → "Upload files" click karo
   - Is folder ke andar ke saare files/folders (lib/, pubspec.yaml,
     .github/ waghera) drag-drop karo
   - ⚠️ **Important:** `.github` folder hidden hoti hai, isliye use "Upload
     files" mein drag karte waqt zaroor include karna (agar drag-drop na ho
     to Git command line use karo: `git add -A` sab kuch add kar deta hai
     hidden files sahit).
   - "Commit changes" dabao.
4. Repo ke top par **"Actions"** tab kholo. Workflow khud start ho jaayega
   (2-3 minute lagte hain). Agar na chale to "Run workflow" button dabao.
5. Build complete hone par usi run ke neeche **"Artifacts"** section mein
   `deltabot-monitor-apk` milega - wahan se `.zip` download karo, andar
   `app-release.apk` hogi.
6. Wo APK phone mein transfer karke install kar lo (Settings mein "install
   from unknown sources" allow karna padega).

**Git command-line se upload karna hai to** (zyada reliable, hidden `.github`
folder bhi sahi se chala jaata hai):
```bash
cd flutter_app
git init
git add -A
git commit -m "DeltaBot Monitor app"
git branch -M main
git remote add origin https://github.com/<username>/<repo-name>.git
git push -u origin main
```

## Doosra option — apne computer par khud build karna

1. Flutter SDK install karo: https://docs.flutter.dev/get-started/install
2. Is folder ke andar terminal khol kar:
   ```bash
   flutter create .          # android/ios/ folders generate karega
   flutter pub get
   flutter build apk --release
   ```
3. APK yahan milegi: `build/app/outputs/flutter-apk/app-release.apk`

## Backend se connect karna

App ke **Settings** screen mein apna backend server ka URL daalna hoga
(jaise `http://192.168.1.10:8000` local network par, ya public URL agar
server internet par expose kiya hai). Login: `.env` mein set kiya gaya
`MONITOR_USERNAME` / `MONITOR_PASSWORD`.

