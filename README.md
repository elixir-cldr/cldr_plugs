# Cldr Plug

## Installation

The package can be installed by adding `ex_cldr_plugs` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_cldr_plugs, "~> 1.3"},
  ]
end
```
Documentation can be found at [https://hexdocs.pm/ex_cldr_plugs](https://hexdocs.pm/ex_cldr_plugs).

## Plugs

`Cldr` provides two plugs to aid integration into an HTTP workflow.  These two plugs are:

* `Cldr.Plug.AcceptLanguage` which will parse an `accept-language` header and resolve the best matched and configured `Cldr` locale. The result is stored in `conn.private[:cldr_locale]` which is also returned by `Cldr.Plug.AcceptLanguage.get_cldr_locale/1`.

* `Cldr.Plug.PutLocale` which will look for a locale in the several places and then call `Cldr.put_locale/2` and `Gettext.put_locale/2` if configured so to do. Finally, The result is stored in `conn.private[:cldr_locale]` which is then available through `Cldr.Plug.PutLocale.get_cldr_locale/1`. The plug will look for a locale in the following locations depending on the plug configuration:

  * `path_params`
  * `query_params`
  * `body_params`
  * `cookies`
  * `accept-language` header
  * Hostname suffix
  * the `session`
  * An `{Module, function, [args]}` or `{Module, function}` tuple that should return `{:ok, Cldr.LanguageTag.t()}` - any other return will not set the locale.

See `Cldr.Plug.PutLocale` for a description of how to configure the plug.

In addition, note that when migrating from `ex_cldr` 1.x versions, a backend needs to be configured for both plugs. In the simplest case an example would be:
```elixir
plug Cldr.Plug.PutLocale,
  apps:    [:cldr],
  cldr:    MyApp.Cldr

plug Cldr.Plug.AcceptLanguage,
  cldr_backend: MyApp.Cldr
```

### Using Cldr.Plug.PutLocale without Phoenix

If you are using `Cldr.Plug.PutLocale` without Phoenix and you plan to use `:path_param` to identify the locale of a request then `Cldr.Plug.PutLocale` must be configured *after* `plug :match` and *before* `plug :dispatch`.  For example:
```elixir
defmodule MyRouter do
  use Plug.Router

  plug :match

  plug Cldr.Plug.PutLocale,
    apps: [:cldr, :gettext],
    from: [:path, :query],
    gettext: MyApp.Gettext,
    cldr: MyApp.Cldr

  plug :dispatch

  get "/hello/:locale" do
    send_resp(conn, 200, "world")
  end
end
```

### Using Cldr.Plug.PutLocale with Phoenix

If you are using `Cldr.Plug.PutLocale` with Phoenix and you plan to use the `:path_param` to identify the locale of a request then `Cldr.Plug.PutLocale` must be configured in the router module, *not* in the endpoint module. This is because `conn.path_params` has not yet been populated in the endpoint. For example:
```elixir
defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug Cldr.Plug.PutLocale,
      apps: [:cldr, :gettext],
      from: [:path, :query],
      gettext: MyApp.Gettext,
      cldr: MyApp.Cldr
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/:locale", HelloWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

end
```
