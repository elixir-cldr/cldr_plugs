Application.ensure_all_started(:gettext)

defmodule MyApp.Gettext do
  use Gettext,
    otp_app: :ex_cldr_plugs,
    plural_forms: MyApp.Gettext.Plural,
    priv: "priv/gettext_test"
end
