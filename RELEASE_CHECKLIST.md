# Release checklist

- [ ] Generate and commit `android/` and `ios/` with `tool/bootstrap_platforms.sh`.
- [ ] Set final Android applicationId and iOS bundle identifier.
- [ ] Add app icon and launch/splash assets.
- [ ] Test add/select/move/resize/edit/delete/layers on Android and iPhone.
- [ ] Test JSON import and JSON/HTML/CSS export from the native share sheet.
- [ ] Test on small and large screens, portrait orientation, and accessibility text sizes.
- [ ] Configure Android signing for Play Store distribution.
- [ ] Configure Apple signing and provisioning for device installation/App Store.
- [ ] Review privacy disclosures and store metadata.
- [ ] Run `flutter analyze`, `flutter test`, and release builds.
