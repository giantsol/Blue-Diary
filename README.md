<h1 align="center">
  <br>
  <a href=""><img src="https://user-images.githubusercontent.com/4879766/67226792-c62f1680-f470-11e9-9609-7cd1f2410dd2.png" alt="Blue Diary" width="200"></a>
  <br>
  Blue Diary
  <br>
</h1>

<h3 align="center">A lightweight & effective Todo app made with <a href="https://flutter.dev" target="_blank">Flutter</a>. Supports English and Korean.</h3>

<p align="center">
  <a href="#screenshots">Screenshots</a> •
  <a href="#download">Download</a> •
  <a href="#usage">Usage</a> •
  <a href="#architecture">Architecture</a> •
  <a href="#feedback">Feedback</a> •
  <a href="#license">License</a> •
</p>

## Screenshots

<p float="left">
  <img src="https://user-images.githubusercontent.com/4879766/72454492-4e208480-3804-11ea-9a97-ba36de80f73d.png" width="250" />
  <img src="https://user-images.githubusercontent.com/4879766/72454500-511b7500-3804-11ea-953b-685c3cda78f9.png" width="250" /> 
  <img src="https://user-images.githubusercontent.com/4879766/72454503-537dcf00-3804-11ea-884e-d43b993c5a37.png" width="250" />
  <img src="https://user-images.githubusercontent.com/4879766/72454508-54aefc00-3804-11ea-9a5c-9b5a7c220e3f.png" width="250" />
  <img src="https://user-images.githubusercontent.com/4879766/72454509-5678bf80-3804-11ea-8f53-8f5b0cbdd775.png" width="250" />
</p>

## Download

<a href='https://play.google.com/store/apps/details?id=com.giantsol.blue_diary'>
  <img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/images/generic/en_badge_web_generic.png' width='200'/>
</a>

<a href='https://apps.apple.com/us/app/id1495060000'>
  <img alt='Download on the App Store' src='https://itsallwidgets.com/images/apple.png' width='200'/>
</a>

## Usage

You can build and run this app by yourself. You'll need [Git](https://git-scm.com), [Flutter](https://flutter.dev/docs/get-started/install), [NPM](https://www.npmjs.com/get-npm) and [Android Studio](https://developer.android.com/studio) installed.

Building this app for yourself needs 2 steps:
1. <a href="#1-basic-setup">Basic Setup</a>
2. <a href="#2-firebase-integration">Firebase Integration</a>

I'll describe these steps in detail.

### 1. Basic Setup

First of all, clone this project by running command:

```
$ git clone https://github.com/giantsol/Blue-Diary.git
```

Open cloned directory with Android Studio and it'll notify you to run `Packages get` to install dependencies. Do that.

Next is to integrate [Firebase](https://firebase.google.com/).

### 2. Firebase Integration

This app uses various features of Firebase, including [Firebase Authentication](https://firebase.google.com/docs/auth/), [Cloud Firestore](https://firebase.google.com/docs/firestore/) and more. If Firebase is not set up, you *can* still build the app, but you won't be able to see the first screen.

#### (1) Create Firebase project

First, you have to create a new project in [Firebase Console](https://console.firebase.google.com/). Click **Create a project** as below:
<p><img src="https://user-images.githubusercontent.com/4879766/72488982-fb6fb880-3855-11ea-8ad1-650330927054.png" width=400" /></p>

Set a project name as below(can be anything else):
<p><img src="https://user-images.githubusercontent.com/4879766/72488984-ff9bd600-3855-11ea-9c6a-67c9b7d300ac.png" width=400" /></p>

Go into your newly created project. We'll add **Android** app first. Click **Android** button:
<p><img src="https://user-images.githubusercontent.com/4879766/72488992-032f5d00-3856-11ea-988e-a1de262dcbb9.png" width=400" /></p>
                                                                                                                         
In package name, put `com.giantsol.blue_diary.debug` since this is the applicationId for debug builds. You can put anything for App nickname(e.g. Blue Diary Debug).

Click next, and click **Download google-service.json** and save it right below **your-cloned-dir/android/app** directory. You should skip step 3 and 4:
<p><img src="https://user-images.githubusercontent.com/4879766/72488997-07f41100-3856-11ea-9951-c0e84d8d1c65.png" width=400" /></p>

Run `flutter packages get` in your cloned directory to install dependencies.                                                                                  
Next we'll add **iOS** app. Click **iOS** button:
<p><img src="https://user-images.githubusercontent.com/4879766/72489003-0de9f200-3856-11ea-87fe-f74bf05c98f8.png" width=400" /></p>  

In bundle ID, put `com.giantsol.blue-diary.debug`(note that iOS bundle id and Android applicationId is subtly different!). You can put anything for App nickname(e.g. Blue Diary Debug).

Click next, and click **Download GoogleService-Info.plist** and save it anywhere for now. You should skip step 3, 4 and 5:
<p><img src="https://user-images.githubusercontent.com/4879766/72489011-13473c80-3856-11ea-98fd-d8e160ae642d.png" width=400" /></p>
                                                                                                                         
Open your cloned project using Xcode. If you're using Android Studio, you can open ios module in Xcode by right clicking your project directory from Project panel - Flutter - Open iOS module in Xcode:
<p><img src="https://user-images.githubusercontent.com/4879766/72490344-5dcab800-385a-11ea-90d7-8166eb5caf77.png" width=400" /></p>  

In Xcode, drag and drop **GoogleService-Info.plist** file you downloaded into Runner/Runner directory. Note that you **must** use Xcode in this procedure, since it needs to update indexes of file:
<p><img src="https://user-images.githubusercontent.com/4879766/72489024-1b06e100-3856-11ea-9136-bb58fef3e0e4.png" width=400" /></p>

Done! Run `flutter packages get` in your cloned directory again.

#### (2) Firebase Authentication Integration

We use google sign-in. First, you need to turn on google sign-in function in your Firebase project by navigating to Authentication - Sign-in method tab and enabling Google by toggling switch button. Click Save:
<p><img src="https://user-images.githubusercontent.com/4879766/72489039-20fcc200-3856-11ea-9ab9-18f9c45cbd22.png" width=400" /></p>
                                                                                                                         
Nothing else to do for Android, but if you're planning to build on iOS, you need one more step. Go to your **Info.plist** file located in `your-cloned-dir/ios/Runner/Info.plist`. It should have below code:

```
<!-- Google Sign-in Section -->
<key>CFBundleURLTypes</key>
<array>
	<dict>
		<key>CFBundleTypeRole</key>
		<string>Editor</string>
		<key>CFBundleURLSchemes</key>
		<array>
			<!-- TODO Replace this value: -->
			<!-- Copied from GoogleService-Info.plist key REVERSED_CLIENT_ID -->
			<string>$(GOOGLE_SERVICE_INFO_REVERSED_CLIENT_ID)</string>
		</array>
	</dict>
</array>
<!-- End of the Google Sign-in Section -->
```

Change `$(GOOGLE_SERVICE_INFO_REVERSED_CLIENT_ID)` with your own **GoogleService-Info.plist**'s **REVERSED_CLIENT_ID** value.

#### (3) Firebase Functions Integration

You need to deploy firebase functions to your Firebase project. First, run `npm install -g firebase-tools` from anywhere in cmd. If you don't have `npm` installed, follow this [link](https://www.npmjs.com/get-npm).

After firebase-tools is installed, run `firebase login` anywhere in your cmd to authenticate firebase tool.

Then run `firebase init functions` in your cloned directory. It would ask you for options. Select Use an existing project -> JavaScript -> No -> Yes as below:
<p><img src="https://user-images.githubusercontent.com/4879766/72489071-370a8280-3856-11ea-80bf-5a6e2b1fc935.png" width=400" /></p>
                                                                                                                         
New file should have been created as `your-cloned-dir/functions/index.js`. Copy and paste below code to `index.js`:

```js
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
```

Finally, run `firebase deploy --only functions` from your cloned directory. This command uploads these functions to your firebase project server.

#### (4) Cloud Firestore Integration

Our last step is to create the database we need in your Firebase project. In your Firebase console, click Database - Create Database - Start in test mode:
<p><img src="https://user-images.githubusercontent.com/4879766/72489084-3ffb5400-3856-11ea-948b-c689aedd21fc.png" width=400" /></p>
                                                                                                                         
When database is created, we need to create an **index** for this database. In Database page, click Indexes - Composite - Add index and fill in fields as below:
<p><img src="https://user-images.githubusercontent.com/4879766/72491336-18f45080-385d-11ea-9969-dfd2c2946e8e.png" width=400" /></p>
                                                                                                                         
Click **Create index** and wait for the process to finish.   

<br />

**All Done!** Build and run app. If you still can't see the first screen although internet is connected, you should first check your Firebase account's quota. Perhaps your Spark plan's quota is all used. If there's other problems, please leave <a href="#feedback">Feedback</a>!

## Architecture

This app is based on [BLoC pattern](http://flutterdevs.com/blog/bloc-pattern-in-flutter-part-1/), together with my own architectural practices.

Inside the [lib](https://github.com/giantsol/Blue-Diary/tree/master/lib) folder, there are three main folders:

1. [data](https://github.com/giantsol/Blue-Diary/tree/master/lib/data): This folder contains Dart files that actually update/fetch data from Preferences, Databases, or Network (although we don't use Network here). Most of the files here are implementations of Repository interface declared in [domain/repository](https://github.com/giantsol/Blue-Diary/tree/master/lib/domain/repository) folder.

2. [domain](https://github.com/giantsol/Blue-Diary/tree/master/lib/domain): This folder contains the so called 'Business Logic' of this app. It is further divided into three main folders:
    - [entity](https://github.com/giantsol/Blue-Diary/tree/master/lib/domain/entity): contains pure data classes such as [ToDo](https://github.com/giantsol/Blue-Diary/blob/master/lib/domain/entity/ToDo.dart) and [Category](https://github.com/giantsol/Blue-Diary/blob/master/lib/domain/entity/Category.dart).
    - [repository](https://github.com/giantsol/Blue-Diary/tree/master/lib/domain/repository): contains interfaces defining functions that update/fetch data. Actual implementations are located in [data](https://github.com/giantsol/Blue-Diary/tree/master/lib/data) folder.
    - [usecase](https://github.com/giantsol/Blue-Diary/tree/master/lib/domain/usecase): contains per-screen business logics that utilizes several repositories to achieve each screen's needs. This is the layer that [presentation](https://github.com/giantsol/Blue-Diary/tree/master/lib/presentation) has access to to utilize app data. For instance, [WeekScreen](https://github.com/giantsol/Blue-Diary/blob/master/lib/presentation/week/WeekScreen.dart) uses (well, actually [WeekBloc](https://github.com/giantsol/Blue-Diary/blob/master/lib/presentation/week/WeekBloc.dart) uses) [WeekUsecases](https://github.com/giantsol/Blue-Diary/blob/master/lib/domain/usecase/WeekUsecases.dart) to interact with data underneath without directly touching repositories.
  
3. [presentation](https://github.com/giantsol/Blue-Diary/tree/master/lib/presentation): This folder contains `Screen`s, `Bloc`s and `State`s that are used to display UI. It is divided into further directories that correspond to each screens in the app.
    - `**Screen`: where Widget's `build` method is called to build the actual UI shown to the user. UI is determined by values inside `State`, and any interactions users make (e.g. clicking a button) are delegated to corresponding `Bloc`s.
    - `**Bloc`: what this basically does is "User does something (e.g. click a button)" -> "Set/Get data using corresponding [usecase](https://github.com/giantsol/Blue-Diary/tree/master/lib/domain/usecase) and update the values inside `State` obect" -> "Notify `Screen` that `State` has changed and you have to rebuild".
    - `**State`: holds all the information `Screen` needs to draw UI. For instance, `currentDate`, `todos`, and `isLocked` kinds of things.
  
Above three directories are divided to as closely follow Uncle Bob's [Clean Architecture pattern](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html). Any tackles, highly welcomed.

Besides these directories are flat Dart files inside [lib](https://github.com/giantsol/Blue-Diary/tree/master/lib) folder:

1. [AppColors.dart](https://github.com/giantsol/Blue-Diary/blob/master/lib/AppColors.dart): just simple color constants.
2. [Delegators.dart](https://github.com/giantsol/Blue-Diary/blob/master/lib/Delegators.dart): I used delegators when children needed to call parent's methods. However, as I've become more familiar with Flutter now, I guess [ancestorStateOfType](https://api.flutter.dev/flutter/widgets/Element/ancestorStateOfType.html) can just do that job... researching on it!
3. [Dependencies.dart](https://github.com/giantsol/Blue-Diary/blob/master/lib/Dependencies.dart): contains singleton objects such as repositories and usecases. Basically, it enables a very simple injection pattern like `dependencies.weekUsecases` as in [WeekBloc.dart](https://github.com/giantsol/Blue-Diary/blob/master/lib/presentation/week/WeekBloc.dart).
4. [Localization.dart](https://github.com/giantsol/Blue-Diary/blob/master/lib/Localization.dart): where localization texts are declared.
5. [Main.dart](https://github.com/giantsol/Blue-Diary/blob/master/lib/Main.dart): the main entry point of this app.
6. [Utils.dart](https://github.com/giantsol/Blue-Diary/blob/master/lib/Utils.dart): Utils (duh).

If you have any questions, or have any suggestions to make this app better, do contact me as shown in <a href="#feedback">Feedback</a>. Thanks!

## Feedback

Feel free to leave any feedback about this app, code, or whatever.

Leave [Issues](https://github.com/giantsol/Blue-Diary/issues), [Pull requests](https://github.com/giantsol/Blue-Diary/pulls) or email me at giantsol64@gmail.com.

## License

MIT
