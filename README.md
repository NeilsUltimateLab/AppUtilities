# AppConfiguration

Swift package with utility classes for iOS projects.

This package packs the some useful
- [Extensions](/Sources/AppUtilities/Extensions) over `Array`, `Data`, `String`, `Storyboard`, `UIView`, `UIViewController` types.
- Provides the common data types like [FieldValue](/Sources/AppUtilities/Models/FieldValue.swift), [Row](/Sources/AppUtilities/Models/Row.swift).
- Error handling interface like [AppErrorProvider](/Sources/AppUtilities/Protocols/AppErrorProvider.swift).
- Child View Controller implementation via [ContainmentProvider](/Sources/AppUtilities/Protocols/ContainmentProvider.swift).
- Image Picker Controller permissions via [ImagePickerDisplaying](/Sources/AppUtilities/Protocols/ImagePickerDisplaying.swift).
- Selection interface for collection of items using [SelectionViewController](/Sources/AppUtilities/ViewControllers/SelectionViewController.swift).
- `TextField`/`TextView` subclass for textChange, character limit feature.
- [FetchingView](/Sources/AppUtilities/Views/FetchingView.swift) and [IndicatorButton](/Sources/AppUtilities/Views/IndicatorButton.swift) for modeling networking states.
- Classes for custom `UIViewController` transition/presentation animations using [PopAnimator](/Sources/AppUtilities/Views/PopAnimator.swift).
- Support for `UIViewController` and `UIView` subclass's preview in Xcode Canvas using [UIPreview](/Sources/AppUtilities/Views/UIPreview.swift).
- [DocC](https://developer.apple.com/documentation/docc) compatible documentation.
