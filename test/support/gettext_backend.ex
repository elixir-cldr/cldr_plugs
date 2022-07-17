defmodule TestGettext.Gettext do
  @moduledoc """
  Implements a Gettext-compatible module but using Cldr locales.  Its for
  testing only.
  """
  use Gettext,
    otp_app: :ex_cldr_plugs,
    priv: "priv/gettext_test"
end
