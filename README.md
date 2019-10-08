<h1 align="center">
  <br>
  <a href=""><img src="https://user-images.githubusercontent.com/4879766/66365941-ba9c1400-e9c9-11e9-8d96-d161ff087035.png" alt="Blue Diary" width="200"></a>
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
  <img src="https://user-images.githubusercontent.com/4879766/66365952-c8519980-e9c9-11e9-824d-fc4533b4d328.jpeg" width="200" />
  <img src="https://user-images.githubusercontent.com/4879766/66365965-d0a9d480-e9c9-11e9-931f-a54e70308d27.jpeg" width="200" /> 
  <img src="https://user-images.githubusercontent.com/4879766/66365968-d1db0180-e9c9-11e9-95cf-03ffd83490d2.jpeg" width="200" />
  <img src="https://user-images.githubusercontent.com/4879766/66365969-d3a4c500-e9c9-11e9-9c4d-2082479cc7f7.jpeg" width="200" />
</p>

## Usage

You can build and run this app by yourself. You'll need [Git](https://git-scm.com) and [Flutter](https://flutter.dev/docs/get-started/install) installed first. After that, from your command line:

```
# Clone this repository
$ git clone https://github.com/giantsol/Blue-Diary.git

# Go into the repository
$ cd Blue-Diary

# Install dependencies
$ flutter packages get
```

Build will fail at this moment because this app uses [Sendgrid](https://sendgrid.com/?opt=variant-header) to send emails in [SettingsBloc](https://github.com/giantsol/Blue-Diary/blob/master/lib/presentation/settings/SettingsBloc.dart) file, and `SENDGRID_AUTHORIZATION` constant isn't git-controlled.

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

Build the app again, and run `flutter run` from console or press `Run` button from Android Studio. 

## Architecture

This app is based on [BLoC pattern](http://flutterdevs.com/blog/bloc-pattern-in-flutter-part-1/), together with my own architectural practices.

// todo: add Architecture

## Download

Android version of this app is in pending publication state. Will update link when it's published.

iOS version, not yet.

## Feedback

Feel free to leave any feedback about this app, code, or whatever.

Leave [Issues](https://github.com/giantsol/Blue-Diary/issues), [Pull requests](https://github.com/giantsol/Blue-Diary/pulls) or email me at giantsol64@gmail.com.

## License

MIT
