# I/O Photo Booth

[![Photo Booth Header][logo]][photo_booth_link]

[![io_photobooth][build_status_badge]][workflow_link]
![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

A Photo Booth built with [Flutter][flutter_link] and [Firebase][firebase_link] for [Google I/O 2021][google_io_link].

[Try it now][photo_booth_link] and [learn about how it's made][blog_link].

*Built by [Very Good Ventures][very_good_ventures_link] in partnership with Google*

*Created using [Very Good CLI][very_good_cli_link] 🤖*

---

## Getting Started 🚀

To run the desired project either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
$ flutter run -d chrome
```

_\*I/O Photo Booth works on Web._

---

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/
# Open Coverage Report
$ open coverage/index.html
```

---

## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:io_photobooth/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

---

## Working with Mason 🧱

This project relies on [mason](https://github.com/felangel/mason) to create and consume reusable templates called bricks. For additional documentation see [BrickHub](https://docs.brickhub.dev).

1. Install mason from [pub](https://pub.dev):
```sh
dart pub global activate mason_cli
```

2. Check the current project bricks:
```sh
mason list
```

3. Add your own bricks:
```sh
mason add bloc
```

4. Generate code from a brick:
```sh
mason make bloc
```

> **Note**
> Mason support for Visual Studio Code can be found [here](https://marketplace.visualstudio.com/items?itemName=FelixAngelov.mason).

---
# Debug web app on iphone

To debug the web app on the iphone, we need to run it as https, because without that, the iphone won't let us use the camera. We need to configure safari to listen for logs from the iphone.

### Configure https server

1. Install http-server from [npm](https://www.npmjs.com):

```sh
npm install -g http-server
```

2. Create a script.sh file

```sh
cd ~/
mkdir .localhost-ssl

sudo openssl genrsa -out ~/.localhost-ssl/localhost.key 2048
sudo openssl req -new -x509 -key ~/.localhost-ssl/localhost.key -out ~/.localhost-ssl/localhost.crt -days 3650 -subj /CN=localhost
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ~/.localhost-ssl/localhost.crt

echo "
function https-server() {
  http-server --ssl --cert ~/.localhost-ssl/localhost.crt --key ~/.localhost-ssl/localhost.key
}
" >> ~/.bash_profile
source ~/.bash_profile
```

3. Run `script.sh` file, each running of a script will add function to ~/.bash_profile

```sh
sh script.sh
```

4. Build web project

```sh
flutter build web
```

5. Go to the generated directory

```sh
cd {project_dir}/build/web
```

6. Run server

```sh
https-server
```

### Configure Safari to listen for logs

1. On Mac

```sh
Open Safari > Preferences > Advanced > enable "Show Develop menu in menu bar"
```

2. On iPhone

```sh
Open Settings > Safari > Advanced > enable "Web Inspector"
```

3. Connect your device to your Mac using a USB cable.

4. Open Safari on iphone and enter server adress, for example https://192.168.1.1:8080

5. On Mac

```sh
Safari > Develop > Find "YourPhoneName" > select the Safari session entered earlier, for example 192.168.1.1
```

[build_status_badge]: https://github.com/flutter/photobooth/actions/workflows/main.yaml/badge.svg
[coverage_badge]: coverage_badge.svg
[firebase_link]: https://firebase.google.com/
[flutter_link]: https://flutter.dev
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[google_io_link]: https://events.google.com/io/
[blog_link]: https://medium.com/flutter/how-its-made-i-o-photo-booth-3b8355d35883
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo]: art/header.png
[photo_booth_link]: https://photobooth.flutter.dev
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
[very_good_ventures_link]: https://verygood.ventures/
[workflow_link]: https://github.com/flutter/photobooth/actions/workflows/main.yaml
