# Changelog

## Cldr Plugs v1.1.0

This is the changelog for Cldr Plugs v1.1.0 released on July 17th, 2022.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_plugs/tags)

### Enhancements

* Adds `:assigns` as an optional source of the locale in `Cldr.Plug.SetLocale`.  The library [ex_cldr_routes](https://hex.pm/packages/ex_cldr_routes) introduces localised routing. These localised routes will set the `conn.assigns[:cldr_locale]` and therefore may be used as an indicator of the users locale preference if no other locale source (like the session, path or params) can be identified. Since the routes locale is tied to the route, not necessarily the users preference, this should be considered a lower priority locale source.  The default `:from` parameter is updated to reflect this and is now set to `[:session, :accept_language, :query, :path, :assigns]`.

## Cldr Plugs v1.0.0

This is the changelog for Cldr Plugs v1.0.0 released on May 10th, 2022.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_plugs/tags)

### Enhancements

* Intiial release, extracted from `ex_cldr`

* Adds support for [MFA](https://elixirforum.com/t/documentation-of-what-an-mfa-is/25376) (and the variant without arguments `MF`) tuples that can be used as part of the `Cldr.Plug.SetLocale` configuration in the `:from` and `:default` cases.
