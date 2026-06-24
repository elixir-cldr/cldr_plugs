defmodule Cldr.Plug.AcceptLanguage.Test do
  use ExUnit.Case, async: true
  import Plug.Test

  import ExUnit.CaptureLog
  import Plug.Conn, only: [put_req_header: 3]

  test "that the locale is set if the accept-language header is a valid locale name" do
    opts = Cldr.Plug.AcceptLanguage.init(cldr_backend: TestBackend.Cldr)

    conn =
      :get
      |> conn("/")
      |> put_req_header("accept-language", "en")
      |> Cldr.Plug.AcceptLanguage.call(opts)

    assert conn.private[:cldr_locale] ==
             %Cldr.LanguageTag{
               backend: TestBackend.Cldr,
               canonical_locale_name: "en",
               cldr_locale_name: :en,
               extensions: %{},
               gettext_locale_name: "en",
               language: "en",
               locale: %{},
               private_use: [],
               rbnf_locale_name: :en,
               requested_locale_name: "en",
               script: :Latn,
               territory: :US,
               transform: %{},
               language_variants: []
             }
  end

  test "that the gettext locale is a set when an ancestor is available" do
    opts = Cldr.Plug.AcceptLanguage.init(cldr_backend: TestBackend.Cldr)

    conn =
      :get
      |> conn("/")
      |> put_req_header("accept-language", "en-AU")
      |> Cldr.Plug.AcceptLanguage.call(opts)

    # ex_cldr resolves the closest known Gettext locale via CLDR language
    # matching. "en-AU" matches the "en_GB" Gettext locale (both are non-US
    # English) in preference to the more distant "en".
    assert conn.private[:cldr_locale].gettext_locale_name == "en_GB"
  end

  test "that the gettext locale is a set" do
    opts = Cldr.Plug.AcceptLanguage.init(cldr_backend: TestBackend.Cldr)

    conn =
      :get
      |> conn("/")
      |> put_req_header("accept-language", "en-GB")
      |> Cldr.Plug.AcceptLanguage.call(opts)

    assert conn.private[:cldr_locale].gettext_locale_name == "en_GB"
  end

  test "that the default locale is used if no backend is configured" do
    assert Cldr.Plug.AcceptLanguage.init([]).backend == Cldr.default_backend!()
  end

  test "that the locale is not set if the accept-language header is an invalid locale name" do
    opts = Cldr.Plug.AcceptLanguage.init(cldr_backend: TestBackend.Cldr)

    capture_log(fn ->
      conn =
        :get
        |> conn("/")
        |> put_req_header("accept-language", "not_valid_locale_name")
        |> Cldr.Plug.AcceptLanguage.call(opts)

      assert conn.private[:cldr_locale] == nil
    end)
  end

  test "that the locale is not set if the accept-language header does not exists" do
    opts = Cldr.Plug.AcceptLanguage.init(cldr_backend: TestBackend.Cldr)

    capture_log(fn ->
      conn =
        :get
        |> conn("/")
        |> Cldr.Plug.AcceptLanguage.call(opts)

      assert conn.private[:cldr_locale] == nil
    end)
  end

  test "No logging configured for no-match warnings" do
    opts =
      Cldr.Plug.AcceptLanguage.init(cldr_backend: TestBackend.Cldr, no_match_log_level: :error)

    # "za" (Zhuang) is a valid language subtag with no CLDR locale, so it
    # parses successfully but matches no configured locale, yielding
    # Cldr.NoMatchingLocale. (A subtag with any CLDR locale, e.g. "ab", now
    # matches under ex_cldr's language-matching algorithm and is no longer a
    # no-match.)
    assert capture_log(fn ->
             :get
             |> conn("/")
             |> put_req_header("accept-language", "za")
             |> Cldr.Plug.AcceptLanguage.call(opts)
           end) =~ "Cldr.NoMatchingLocale: No configured locale could be matched to \"za\""
  end

  test "Log level not configured for no-match warnings" do
    opts = Cldr.Plug.AcceptLanguage.init(cldr_backend: TestBackend.Cldr, no_match_log_level: nil)

    assert capture_log(fn ->
             :get
             |> conn("/")
             |> put_req_header("accept-language", "xx")
             |> Cldr.Plug.AcceptLanguage.call(opts)
           end) =~ ~r/Cldr.InvalidLanguageError: The language./
  end

  test "Log level configured for no-match warnings below logger configured level" do
    opts =
      Cldr.Plug.AcceptLanguage.init(cldr_backend: TestBackend.Cldr, no_match_log_level: :info)

    assert capture_log(fn ->
             :get
             |> conn("/")
             |> put_req_header("accept-language", "xx")
             |> Cldr.Plug.AcceptLanguage.call(opts)
           end) =~ ~r/Cldr.InvalidLanguageError: The language./
  end
end
