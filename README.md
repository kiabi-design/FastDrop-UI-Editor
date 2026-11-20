# FastDrop UI Editor

Мобильный визуальный редактор HTML-макета FastDrop на Flutter + WebView. Интерфейс редактора загружается локально из `assets/editor/index.html`, поэтому для базовой работы интернет не требуется.

## Возможности текущей сборки

- Готовый макет FastDrop в формате 390×844.
- Добавление текста, кнопок и карточек.
- Перемещение элементов касанием и изменение размера зелёным маркером.
- Настройка текста, ширины/высоты, X/Y, размера шрифта, скругления, цвета текста и фона, прозрачности.
- Список слоёв и выбор элемента.
- Импорт JSON-проекта и экспорт JSON, HTML и CSS через системное меню «Поделиться».
- Android и iOS через Flutter.

## Требования

- Flutter stable (Dart 3.3+).
- Android SDK для APK.
- Для сборки iOS нужен macOS с Xcode.

## Подготовка платформенных папок

Если папок `android/` и `ios/` ещё нет, один раз выполни в корне проекта:

```bash
flutter create . --platforms=android,ios --org com.kiabi.fastdrop --project-name fastdrop_ui_editor
flutter pub get
```

После генерации платформенных папок добавь их в GitHub вместе с остальными файлами.

## Запуск

```bash
flutter pub get
flutter run
```

## Android APK

```bash
flutter build apk --release
```

APK появится в `build/app/outputs/flutter-apk/app-release.apk`.

## iOS

```bash
flutter build ios --release
```

Для установки на iPhone и публикации потребуется корректная подпись Apple Developer, Bundle ID и настройки Xcode. Эти секреты не включаются в исходный архив.

## GitHub Actions

В `.github/workflows/` лежат отдельные workflow для Android APK и iOS build. Сборки запускаются после загрузки проекта в GitHub. iOS workflow требует macOS runner; публикация в App Store требует отдельно настроенной подписи.

## Важно перед релизом

Это подготовленный исходный проект для сборки и проверки, а не уже подписанные IPA/APK. Перед публичным релизом проверьте UI на реальных устройствах, экспорт/импорт файлов, accessibility, app icons, launch screens, package/bundle identifiers, privacy details и подпись.
