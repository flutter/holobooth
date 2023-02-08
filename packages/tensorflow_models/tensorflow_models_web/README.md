# tensorflow_models_web

A tensorflow_models plugin for Flutter web.

## Autogeneration of interop

The tool to autognerate is: https://github.com/dart-lang/js_facade_gen

Steps to autogenerate:

1. On the folder of the Tensorflow model execute this command:
   `npx tsc --declaration --emitDeclarationOnly`
2. This will generate dist folder. Inisde you can find .d.ts files.
3. Execute the tool with `dart_js_facade_gen`. This will generate the interop files. For example
   `dart_js_facade_gen --destination=posenet_interop posenet_model.d.ts`

Things to have in mind:

1. There are some imports that for our purpose they are not needed so stick to what actually is needed, for example:

- Model can be dynamic.
- Inside models there are so many methods or implementations, most of the times we will not need everything.

2. For any reason the autogeneration is creating some private classes of the model that are not needed, we can have everything in a public class. Actually the library itself does not have these private classes so I assume is maybe an issue with autogeneration.
3. To avoid load issues we need to start the file declaring the javascript library that we will use else it will complain that is not able to find the library

```
@JS('posenet')
library posenet;
```

4. Most of the get/set is not needed so we can delete them
5. Take care with nullability since the tool does not support it.
6. We can delete the method ‘fakeConstructor’
7. It is creating some extensions on the methods to facilitate be called from Dart. We dont need that since we will have a bridge between Dart and JS to make that in one single place for all methods we will implement.
8. We need equivalent models and a converter between Dart and JS models. You can check as example `posenet_bridge.dart`
