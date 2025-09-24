# AI-Психолог - Мобильное приложение

Это полноценное мобильное приложение "AI-Психолог" для iOS и Android, созданное с использованием Flutter для фронтенда и Node.js (Express) для бэкенда.

## Структура проекта

```
/
├── backend/
│   ├── node_modules/
│   ├── package.json
│   ├── server.js
│   └── .env
├── lib/
│   ├── app/
│   │   └── app_state.dart
│   ├── core/
│   │   ├── models/
│   │   └── services/
│   ├── features/
│   │   ├── chat/
│   │   │   ├── screens/
│   │   │   │   └── chat_screen.dart
│   │   │   └── widgets/
│   │   │       ├── chat_input_field.dart
│   │   │       └── message_bubble.dart
│   │   ├── history/
│   │   │   └── screens/
│   │   │       └── history_screen.dart
│   │   ├── main/
│   │   │   └── main_screen.dart
│   │   ├── onboarding/
│   │   │   └── screens/
│   │   │       └── onboarding_screen.dart
│   │   └── settings/
│   │       └── screens/
│   │           └── settings_screen.dart
│   ├── widgets/
│   └── main.dart
├── assets/
├── test/
├── .gitignore
├── pubspec.lock
└── pubspec.yaml
```

## Технологии

- **Frontend**: Flutter 3.x, Dart, Provider, GoRouter
- **Backend**: Node.js, Express.js
- **AI**: API языковой модели (например, GPT-4)

## Инструкция по установке и запуску

### Шаг 1: Настройка бэкенда

1.  **Перейдите в папку `backend`:**
    ```bash
    cd backend
    ```

2.  **Установите зависимости:**
    ```bash
    npm install
    ```

3.  **Настройте переменные окружения:**
    Создайте файл `.env` в папке `backend` и добавьте в него ваш API-ключ от OpenAI (или другой языковой модели):
    ```
    AI_API_KEY=ВАШ_СЕКРЕТНЫЙ_КЛЮЧ_API
    ```

4.  **Запустите сервер:**
    ```bash
    npm start
    ```
    Сервер будет запущен на `http://localhost:3000`.

### Шаг 2: Настройка фронтенда (Flutter)

1.  **Убедитесь, что у вас установлен Flutter SDK.**
    Если нет, следуйте [официальной инструкции](https://flutter.dev/docs/get-started/install).

2.  **Перейдите в корневую папку проекта.**

3.  **Получите зависимости Flutter:**
    ```bash
    flutter pub get
    ```

4.  **Настройте URL бэкенда:**
    В файле `lib/features/chat/screens/chat_screen.dart` убедитесь, что URL для API-запросов указан правильно. Если вы запускаете на эмуляторе Android, используйте `http://10.0.2.2:3000` вместо `http://localhost:3000`.
    ```dart
    // lib/features/chat/screens/chat_screen.dart

    // ...
    // Замените 'localhost' на '10.0.2.2' для эмулятора Android
    final url = Uri.parse('http://10.0.2.2:3000/api/chat'); 
    // ...
    ```

5.  **Запустите приложение:**
    Выберите нужное устройство (эмулятор iOS, эмулятор Android или физическое устройство) и выполните команду:
    ```bash
    flutter run
    ```

## Как это работает

1.  **Пользовательский интерфейс (Flutter):**
    - Приложение начинается с экрана приветствия (`onboarding_screen.dart`), который знакомит пользователя с функциями.
    - Основной экран (`main_screen.dart`) содержит навигацию по приложению: чат, история и настройки.
    - Экран чата (`chat_screen.dart`) позволяет пользователю отправлять сообщения.
    - Введенное сообщение отправляется на бэкенд-сервер в виде POST-запроса.

2.  **Бэкенд-сервер (Node.js):**
    - Сервер на Express.js принимает запрос от Flutter-приложения на эндпоинт `/api/chat`.
    - Он извлекает сообщение пользователя и формирует запрос к API языковой модели (например, OpenAI).
    - В запрос добавляется **системный промт**, который определяет личность и поведение AI-психолога "Мира".
    - API-ключ хранится на сервере и безопасно добавляется в заголовок запроса к AI.
    - Ответ от AI возвращается в Flutter-приложение.

3.  **Отображение ответа:**
    - Flutter-приложение получает ответ от сервера и отображает его в окне чата в виде сообщения от AI.
    - Во время ожидания ответа отображается индикатор набора текста.

Проект готов к работе!

## Подпись Android (keystore)

Для публикации в Google Play вам потребуется `keystore` и настройки подписи.

1) Сгенерируйте `keystore` (локально, в корне проекта):

```bash
keytool -genkeypair -v \
    -keystore android/app/my-release-key.jks \
    -alias ai_psychologist_alias \
    -keyalg RSA -keysize 2048 -validity 10000
```

2) Скопируйте шаблон и заполните пароли (НЕ коммитьте реальные значения):

```bash
cp android/key.properties.template android/key.properties
# Отредактируйте android/key.properties и заполните storePassword и keyPassword
```

3) Убедитесь, что keystore и `key.properties` игнорируются в `.gitignore` (файл уже добавлен в репозиторий).

4) Локальная сборка релиза:

```bash
flutter pub get
flutter build apk --release
# Артефакт: build/app/outputs/flutter-apk/app-release.apk
```

5) Загрузка в Codemagic:
- В Workflow Editor -> Code signing загрузите `android/app/my-release-key.jks`.
- Укажите `Keystore password`, `Key alias` (ai_psychologist_alias) и `Key password`.
- Запустите Release сборку.

6) Если Codemagic не поддерживает прямую загрузку файла, загрузите keystore как base64 в защищённую переменную и восстановите файл в before-build шаге:

```bash
# Локально
base64 -w 0 android/app/my-release-key.jks > keystore.b64
# В Codemagic: создайте защищённую переменную KEYSTORE_BASE64 со значением содержимого keystore.b64
```

7) Важно: никогда не коммитьте `android/app/my-release-key.jks` и `android/key.properties` в репозиторий.

Локальная генерация keystore (рекомендуется):

```bash
# интерактивно создаёт android/app/my-release-key.jks
./scripts/generate_keystore.sh
```

Создание `android/key.properties` (НЕ коммитить в репозиторий):

```text
# android/key.properties
storePassword=ВАШ_ПАРОЛЬ_KEYSTORE
keyPassword=ВАШ_ПАРОЛЬ_КЛЮЧА
keyAlias=ai_psychologist_alias
storeFile=android/app/my-release-key.jks
```

Сборка релизного AAB локально:

```bash
flutter pub get
flutter build appbundle --release
```

CI (Codemagic) — рекомендации:

- Загрузите `android/app/my-release-key.jks` как защищённую базу64-переменную `KEYSTORE_BASE64`, или загрузите файл напрямую в Code signing.
- Установите защищённые переменные `KEYSTORE_PASSWORD`, `KEY_PASSWORD`.
- Пример workflow уже добавлен в `codemagic.yaml` — он декодирует keystore, создаёт `android/key.properties` и делает `flutter build appbundle --release`.
