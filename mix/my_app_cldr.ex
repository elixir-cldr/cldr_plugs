require MyApp.Gettext

defmodule MyApp.Cldr do
  use Cldr,
    locales: ["en", "th", "zh-Hant", "zh-Hans", "ar", "he"],
    gettext: MyApp.Gettext,
    default_locale: "en",
    providers: []
end
