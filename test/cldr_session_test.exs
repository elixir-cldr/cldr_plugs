defmodule Cldr.Plug.Test do
  use ExUnit.Case, async: true
  use Plug.Test

  import Plug.Conn, only: [get_session: 2, get_session: 1]

  test "that the session is set" do
    conn = conn(:get, "/hello/es", %{this: "thing"})
    conn = MyRouter.call(conn, MyRouter.init([]))

    session = get_session(conn)
    locale = get_session(conn, Cldr.Plug.SetLocale.session_key())

    assert locale == "es-ES"

    assert {:ok, _locale} = Cldr.Plug.put_locale_from_session(session)
    assert {:ok, _locale} = Cldr.Plug.put_locale_from_session(session, [:cldr])
    assert {:ok, _locale} = Cldr.Plug.put_locale_from_session(session, [:cldr, :gettext])

    assert locale == Cldr.to_string(Cldr.get_locale())

    assert_raise ArgumentError,
                 ~r/Invalid application passed to Cldr.Plug.put_locale_from_session.*/,
                 fn ->
                   Cldr.Plug.put_locale_from_session(session, [:invalid])
                 end
  end
end
