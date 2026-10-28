## 0.1.2

- Fix pending timer assertion in widget tests

## 0.1.1

- Fix hover-pause timer bug: remaining duration now decrements correctly during progress ticks
- Fix `removeAll()` ConcurrentModificationError when `onDismissed` callbacks mutate entries
- Fix flaky widget test by testing service layer directly
- Update CI to use latest stable Flutter

## 0.1.0

- Initial release
- Context-free `toast()` API with success, error, warning, info, loading types
- Promise API: `toast.promise()` auto-transitions loading to success/error
- Spring physics animations for all transitions
- Smart stacking with collapse/expand behavior
- Swipe-to-dismiss with velocity detection
- Full theming with auto light/dark mode
- Six toast positions supported
- Progress bar with pause-on-hover
- Zero dependencies beyond Flutter SDK
