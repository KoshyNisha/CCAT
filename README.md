# CCAT

Flutter web application for Creatives for Climate Action - Thailand (CCAT).

## Current implementation

Implemented pages are the **Resources & Knowledge Hub** and **About** pages,
based on the updated CCAT Figma designs. The shared navigation now opens each
site tab, with Resources in its dedicated Resources tab. The implemented
screens include:

- Responsive desktop and narrow-screen layouts.
- Publications/toolkits and session-recording card collections.
- Category filters for all resources, publications/toolkits, and recordings.
- Typed local resource data sourced from the CCAT 2026 website brief, structured
  so it can be replaced by WordPress responses without changing the page layout.
- An About page with CCAT’s origin, conference-to-initiative story, milestone
  timeline, partners section, and shared footer.

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
