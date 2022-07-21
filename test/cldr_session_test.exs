defmodule Cldr.Session.Test do
  use ExUnit.Case, async: true
  use Plug.Test

  import Plug.Conn, only: [get_session: 2, get_session: 1]

  test "that the session is set" do
    conn = conn(:get, "/hello/es", %{this: "thing"})
    conn = MyRouter.call(conn, MyRouter.init([]))

    session = get_session(conn)
    locale = get_session(conn, Cldr.Plug.SetLocale.session_key())

    assert %Cldr.LanguageTag{} = locale

    assert {:ok, _locale} = Cldr.Session.put_locale(session)
    assert {:ok, _locale} = Cldr.Session.put_locale(session, [:cldr])
    assert {:ok, _locale} = Cldr.Session.put_locale(session, [:cldr, :gettext])

    assert locale == Cldr.get_locale()

    assert_raise ArgumentError, ~r/Invalid application passed to Cldr.Session.put_locale.*/, fn ->
      Cldr.Session.put_locale(session, [:invalid])
    end
  end
end