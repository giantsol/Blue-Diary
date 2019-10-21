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
  <a href="#usage">Usage</a> •
  <a href="#architecture">Architecture</a> •
  <a href="#download">Download</a> •
  <a href="#feedback">Feedback</a> •
  <a href="#license">License</a> •
</p>

## Screenshots

<p float="left">
  <img src="https://user-images.githubusercontent.com/4879766/67226803-cc24f780-f470-11e9-9578-343f1ad62516.jpeg" width="200" />
  <img src="https://user-images.githubusercontent.com/4879766/67226805-ce875180-f470-11e9-9dba-82f330b9d6da.jpeg" width="200" /> 
  <img src="https://user-images.githubusercontent.com/4879766/67226810-d0511500-f470-11e9-9855-26849cc5f00d.jpeg" width="200" />
  <img src="https://user-images.githubusercontent.com/4879766/67226814-d21ad880-f470-11e9-8f5f-a54bdfc7f678.jpeg" width="200" />
</p>

## Usage

You can build and run this app by yourself. You'll need [Git](https://git-scm.com) and [Flutter](https://flutter.dev/docs/get-started/install),and [Android Studio](https://developer.android.com/studio) installed first. After that, clone this project by running command:

```
$ git clone https://github.com/giantsol/Blue-Diary.git
```

Open cloned directory with Android Studio and it'll notify you to run `Packages get` to install dependencies. Do that.

Lastly, when you try to run the project by pressing `Run` button at the top, build will fail because this app uses [Sendgrid](https://sendgrid.com/?opt=variant-header) to send emails in [SettingsBloc](https://github.com/giantsol/Blue-Diary/blob/master/lib/presentation/settings/SettingsBloc.dart) file, and `SENDGRID_AUTHORIZATION` constant isn't git-controlled.

You can solve this in 2 ways:

1. You can follow [Sendgrid guide](https://sendgrid.com/docs/for-developers/sending-email/api-getting-started/) and assign your own token to `SENDGRID_AUTHORIZATION` constant:
```dart
// Create lib/Secrets.dart file
const SENDGRID_AUTHORIZATION = 'Bearer <<YOUR API KEY>>';
```

2. Just replace `SENDGRID_AUTHORIZATON` to `''`. In this case, email sending won't function, but other app functions will work just fine. In [SettingsBloc](https://github.com/giantsol/Blue-Diary/blob/master/lib/presentation/settings/SettingsBloc.dart) file:
```dart
headers: {
  HttpHeaders.authorizationHeader: SENDGRID_AUTHORIZATION,
  HttpHeaders.contentTypeHeader: 'application/json',
},
```
Replace above code with below:
```dart
headers: {
  HttpHeaders.authorizationHeader: '',
  HttpHeaders.contentTypeHeader: 'application/json',
},
```

Press `Run` button again, and it should build fine. 

If you still can't run it, please leave <a href="#feedback">Feedback</a>!

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
6. [Utils.dart](https://github.com/giantsol/Blue-Diary/blob/master/lib/Utils.dart): well, yeah.. Utils.

If you have any questions on why the heck I've done something strange, or have any suggestions to make this app better, please do contact me as shown in <a href="#feedback">Feedback</a>. Thank you!

## Download

<a href='https://play.google.com/store/apps/details?id=com.giantsol.blue_diary'>
  <img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/images/generic/en_badge_web_generic.png' width='200'/>
</a>

iOS version, not yet.

## Feedback

Feel free to leave any feedback about this app, code, or whatever.

Leave [Issues](https://github.com/giantsol/Blue-Diary/issues), [Pull requests](https://github.com/giantsol/Blue-Diary/pulls) or email me at giantsol64@gmail.com.

## License

MIT
