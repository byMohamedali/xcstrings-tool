import Foundation

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension String {
    /// Constant values for the Localizable Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localizable: .key)
    /// value // "Default Value"
    /// ```
    public struct Localizable {
        fileprivate enum BundleDescription {
            case main
            case atURL(URL)
            case forClass(AnyClass)
        }

        fileprivate let key: StaticString
        fileprivate let defaultValue: LocalizationValue
        fileprivate let table: String?
        fileprivate let locale: Locale
        fileprivate let bundle: BundleDescription

        fileprivate init(
            key: StaticString,
            defaultValue: LocalizationValue,
            table: String?,
            locale: Locale,
            bundle: BundleDescription
        ) {
            self.key = key
            self.defaultValue = defaultValue
            self.table = table
            self.locale = locale
            self.bundle = bundle
        }
    }

    public init(localizable: Localizable, locale: Locale? = nil) {
        self.init(
            localized: localizable.key,
            defaultValue: localizable.defaultValue,
            table: localizable.table,
            bundle: .from(description: localizable.bundle),
            locale: locale ?? localizable.locale
        )
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension String.Localizable {
    /// This is a comment
    public static var key: Self {
        Self (
            key: "Key",
            defaultValue: ###"Default Value"###,
            table: "Localizable",
            locale: .current,
            bundle: .current
        )
    }

    public static var myDeviceVariant: Self {
        Self (
            key: "myDeviceVariant",
            defaultValue: ###"Multiplatform Original"###,
            table: "Localizable",
            locale: .current,
            bundle: .current
        )
    }

    public static func myPlural(_ arg1: Int) -> Self {
        Self (
            key: "myPlural",
            defaultValue: ###"I have \###(arg1) plurals"###,
            table: "Localizable",
            locale: .current,
            bundle: .current
        )
    }

    public static func mySubstitute(_ arg1: Int, count arg2: Int) -> Self {
        Self (
            key: "mySubstitute",
            defaultValue: ###"\###(arg1): People liked \###(arg2) posts"###,
            table: "Localizable",
            locale: .current,
            bundle: .current
        )
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
private extension String.Localizable.BundleDescription {
    #if !SWIFT_PACKAGE
    private class BundleLocator {
    }
    #endif

    static var current: Self {
        #if SWIFT_PACKAGE
        .atURL(Bundle.module.bundleURL)
        #else
        .forClass(BundleLocator.self)
        #endif
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
private extension Bundle {
    static func from(description: String.Localizable.BundleDescription) -> Bundle? {
        switch description {
        case .main:
            Bundle.main
        case .atURL(let url):
            Bundle(url: url)
        case .forClass(let anyClass):
            Bundle(for: anyClass)
        }
    }
}

@available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
private extension LocalizedStringResource.BundleDescription {
    static func from(description: String.Localizable.BundleDescription) -> Self {
        switch description {
        case .main:
            .main
        case .atURL(let url):
            .atURL(url)
        case .forClass(let anyClass):
            .forClass(anyClass)
        }
    }
}

@available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
extension LocalizedStringResource {
    /// Constant values for the Localizable Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localized: .localizable.key)
    /// value // "Default Value"
    ///
    /// // Working with SwiftUI
    /// Text(.localizable.key)
    /// ```
    ///
    /// - Note: Using ``LocalizedStringResource.Localizable`` requires iOS 16/macOS 13 or later. See ``String.Localizable`` for an iOS 15/macOS 12 compatible API.
    public struct Localizable {
        /// This is a comment
        public var key: LocalizedStringResource {
            LocalizedStringResource(localizable: .key)
        }

        public var myDeviceVariant: LocalizedStringResource {
            LocalizedStringResource(localizable: .myDeviceVariant)
        }

        public func myPlural(_ arg1: Int) -> LocalizedStringResource {
            LocalizedStringResource(localizable: .myPlural(arg1))
        }

        public func mySubstitute(_ arg1: Int, count arg2: Int) -> LocalizedStringResource {
            LocalizedStringResource(localizable: .mySubstitute(arg1, count: arg2))
        }
    }

    private init(localizable: String.Localizable) {
        self.init(
            localizable.key,
            defaultValue: localizable.defaultValue,
            table: localizable.table,
            locale: localizable.locale,
            bundle: .from(description: localizable.bundle)
        )
    }

    public static let localizable = Localizable()
}