# Changelog

**Elixir version 1.11 or greater is required from ex_cldr_plugs version 1.3.1**

## Cldr Plugs v1.3.3

This is the changelog for Cldr Plugs v1.3.3 released on May 3rd, 2024.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_plugs/tags)

### Bug Fixes

* Add `config/prod.exs` so `MIX_ENV=prod` compilation succeeds. Thanks to @camelpunch for the PR. Closes #12.

## Cldr Plugs v1.3.2

This is the changelog for Cldr Plugs v1.3.2 released on April 9th, 2024.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_plugs/tags)

### Bug Fixes

* Fix spec for `put_locale_from_session/2`. Thanks to @woylie for the PR. Closes #4.

## Cldr Plugs v1.3.1

This is the changelog for Cldr Plugs v1.3.1 released on October 28th, 2023.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_plugs/tags)

### Bug Fixes

* Fix default log level to be `:warning`, not `:warn`. Thanks to @philipgiuliani for the PR. Closes #9.

## Cldr Plugs v1.3.0

This is the changelog for Cldr Plugs v1.3.0 released on April 28th, 2023.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_plugs/tags)

### Enhancements

* Updates to [ex_cldr version 2.37.0](https://hex.pm/packages/ex_cldr/2.37.0) which includes data from [CLDR release 43](https://cldr.unicode.org/index/downloads/cldr-43)

## Cldr Plugs v1.2.1

This is the changelog for Cldr Plugs v1.2.1 released on January 30th, 2023.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_plugs/tags)

### Bug Fixes

* Improves logger messages when `Cldr.Plug.PutLocale` is attempting to set the Gettext locale. There are now one of two warnings logged:
  * One when the CLDR backend module has no configured Gettext module
  * One when there is a configured Gettext module but that module does not have the specified locale configured.
  
* Changes `Logger.warn/1` to `Logger.warning/1` to avoid deprecation messages on Elixir 1.15

## Cldr Plugs v1.2.0

This is the changelog for Cldr Plugs v1.2.0 released on July 27th, 2022.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_plugs/tags)

### Deprecations

* Deprecate `Cldr.Plug.SetLocale` in favour of the more consistent `Cldr.Plug.PutLocale` name.

* Deprecate the `:assigns` `from` key in favour of they key `:route`. `Cldr.Route` will, as of version 0.5.0, place the locale in the `conn.private.cldr_locale` location.  `from: :route` better reflects the intent.  The `:assigns` keyword remains valid with a deprecation warning. 

### Bug Fixes

* Fix setting the locale from the result returned from an `{M, f}` or `{M, f, [a]}`. Thanks to @rubas for the PR.

* Don't make modules `Cldr.Plug.AcceptLanguage` and `Cldr.Plug.PutSession` dependent on `Plug`, `Plug` is a required dependency since this library was split from `ex_cldr`. Thanks to @linusdm for the report. Closes #1.

### Enhancements

* Adds `Cldr.Plug.put_locale_from_session/2` that takes the locale from the session (if there is one) and puts the Cldr locale and/or the Gettext locale into the current process.  This is very useful to add to the `on_mount` callback in LiveView but it can be applied at any time the session is available. For example:
```elixir
def on_mount(:default, _params, session, socket) do
  {:ok, locale} = Cldr.Plug.put_locale_from_session(session)
  ....
end
```

* `Cldr.Plug.PutSession` now has the option to store the full `%Cldr.LanguageTag{}` into the session, or just the string representation (which the default and the same as previous releases). The tradeoff is space used the session (less than 10 bytes typically for the string, around 500 bytes for the struct) versus the performance hit serializing and parsing the locale when storing it in the session or retrieving it later on.

## Cldr Plugs v1.1.0

This is the changelog for Cldr Plugs v1.1.0 released on July 17th, 2022.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_plugs/tags)

### Enhancements

* Adds `:assigns` as an optional source of the locale in `Cldr.Plug.SetLocale`.  The library [ex_cldr_routes](https://hex.pm/packages/ex_cldr_routes) introduces localised routing. These localised routes will set the `conn.assigns[:cldr_locale]` and therefore may be used as an indicator of the users locale preference if no other locale source (like the session, path or params) can be identified. Since the routes locale is tied to the route, not necessarily the users preference, this should be considered a lower priority locale source.  The default `:from` parameter is updated to reflect this and is now set to `[:session, :accept_language, :query, :path, :assigns]`.

## Cldr Plugs v1.0.0

This is the changelog for Cldr Plugs v1.0.0 released on May 10th, 2022.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_plugs/tags)

### Enhancements

* Intiial release, extracted from `ex_cldr`

* Adds support for [MFA](https://elixirforum.com/t/documentation-of-what-an-mfa-is/25376) (and the variant without arguments `MF`) tuples that can be used as part of the `Cldr.Plug.SetLocale` configuration in the `:from` and `:default` cases.
