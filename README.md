# my_flutter_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## REST API Endpoints

Base URL: `http://ccat-cms.local/wp-json/wp/v2` (Local)

| Content Type | Endpoint | Example Full URL |
| :--- | :--- | :--- |
| **Posts** | `/posts` | `/wp-json/wp/v2/posts` |
| **Events** | `/events` | `/wp-json/wp/v2/events` |
| **Pages** | `/pages` | `/wp-json/wp/v2/pages` |

### Custom Parameters
* Add `?acf_format=standard` to expand ACF field relational data in responses.
