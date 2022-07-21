# Changelog

## Cldr Plugs v1.2.0

This is the changelog for Cldr Plugs v1.2.0 released on _______, 2022.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_plugs/tags)

### Behaviour Change

* `Cldr.Plug.PutSession` now puts the full `%Cldr.LanguageTag{}` into the session, rather than just the text. The disadvantage is that the size (in bytes) of the locale as stored in the session is larger, at around 400-500 bytes. There are however several benefits:
  * Limits the number of times the locale name is parsed which improved performance
  * Easier pattern matching on the session, which is very useful with using the new `Cldr.Session.put_locale/2`

### Deprecations

* Deprecate `Cldr.Plug.SetLocale` in favour of the more consistent `Cldr.Plug.PutLocale` name.

* Deprecate the `:assigns` `from` key in favour of they key `:route`. `Cldr.Route` will, as of version 0.5.0, place the locale in the `conn.private.cldr_locale` location.  `from: :route` better reflects the intent.  The `:assigns` keyword remains valid with a deprecation warning. 

### Bug Fixes

* Fix setting the locale from the result returned from an `{M, f}` or `{M, f, [a]}`. Thanks to @rubas for the PR.

* Don't make modules `Cldr.Plug.AcceptLanguage` and `Cldr.Plug.PutSession` dependent on `Plug`, `Plug` is a required dependency since this library was split from `ex_cldr`. Thanks to @linusdm for the report. Closes #1.

### Enhancements

* Adds `Cldr.Session.put_locale/{1, 2}` that takes the locale from the session (if there is one) and puts the Cldr locale and/or the Gettext locale into the current process.  This is very useful to add to the `on_mount` callback in LiveView but it can be applied at any time the session is available. For example:
```elixir
def on_mount(:default, _params, session, socket) do
  {:ok, locale} = Cldr.Session.put_locale(session)
  ....
end
```

## Cldr Plugs v1.1.0

This is the changelog for Cldr Plugs v1.1.0 released on July 17th, 2022.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_plugs/tags)

### Enhancements

* Adds `:assigns` as an optional source of the locale in `Cldr.Plug.SetLocale`.  The library [ex_cldr_routes](https://hex.pm/packages/ex_cldr_routes) introduces localised routing. These localised routes will set the `conn.assigns[:cldr_locale]` and therefore may be used as an indicator of the users locale preference if no other locale source (like the session, path or params) can be identified. Since the routes locale is tied to the route, not necessarily the users preference, this should be considered a lower priority locale source.  The default `:from` parameter is updated to reflect this and is now set to `[:session, :accept_language, :query, :path, :assigns]`.

## Cldr Plugs v1.0.0

This is the changelog for Cldr Plugs v1.0.0 released on May 10th, 2022.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_plugs/tags)

### Enhancements

* Intiial release, extracted from `ex_cldr`

* Adds support for [MFA](https://elixirforum.com/t/documentation-of-what-an-mfa-is/25376) (and the variant without arguments `MF`) tuples that can be used as part of the `Cldr.Plug.SetLocale` configuration in the `:from` and `:default` cases.
