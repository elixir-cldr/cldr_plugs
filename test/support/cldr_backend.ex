require TestGettext.Gettext

defmodule TestBackend.Cldr do
  use Cldr,
    default_locale: "en-001",
    locales: ["en", "fr", "ru", "en-AU", "zh-Hant", "es", "pl"],
    gettext: TestGettext.Gettext,
    precompile_transliterations: [{:latn, :arab}, {:arab, :thai}, {:arab, :latn}],
    providers: []
end

# Test with no Gettext
defmodule WithNoGettextBackend.Cldr do
  use Cldr,
    locales: ["en", "fr"],
    precompile_transliterations: [{:latn, :arab}, {:arab, :thai}, {:arab, :latn}],
    providers: []
end