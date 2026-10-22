# CCAT

Flutter web application for Creatives for Climate Action - Thailand (CCAT).

## Current implementation

The first implemented screen is the **Resources & Knowledge Hub**, based on the
CCAT Figma Resources page. It includes:

- Responsive desktop and narrow-screen layouts.
- Publications/toolkits and session-recording card collections.
- Category filters for all resources, publications/toolkits, and recordings.
- Typed local mock content that mirrors the Figma copy and can be replaced by
  WordPress responses without changing the page layout.

## Run locally in WSL

```bash
cd /home/justm/Thailand/CCAT
flutter pub get
flutter run -d chrome
```

## WordPress REST API

The local CMS base URL is:

```text
http://ccat-cms.local/wp-json/wp/v2
```

| Content type | Endpoint |
|---|---|
| Posts | `/posts` |
| Events | `/events` |
| Pages | `/pages` |

Use `?acf_format=standard` to expand ACF relational fields in responses.

`ccat-cms.local` must resolve inside the WSL environment before the app can
replace its mock data with CMS content.

## Validation

```bash
flutter analyze
flutter test
```
