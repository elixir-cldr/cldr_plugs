defmodule MyModule do
  def get_locale(%Plug.Conn{} = _conn, options) do
    if Keyword.keyword?(options) do
      TestBackend.Cldr.validate_locale("fr")
    else
      raise "Options isn't a Keyword list"
    end
  end

  def get_locale(%Plug.Conn{} = _conn, options, :fred) do
    if Keyword.keyword?(options) do
      TestBackend.Cldr.validate_locale("fr")
    else
      raise "Options isn't a Keyword list"
    end
  end
end