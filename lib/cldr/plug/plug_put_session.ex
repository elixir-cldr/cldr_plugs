defmodule Cldr.Plug.SetSession do
  @moduledoc false

  @deprecated "Please use Cldr.Plug.PutSession"
  defdelegate init(options), to: Cldr.Plug.PutSession

  defdelegate call(conn, options), to: Cldr.Plug.PutSession
end

defmodule Cldr.Plug.PutSession do
  alias Cldr.Plug.PutLocale
  import Plug.Conn

  @moduledoc """
  Puts the CLDR locale in the session.

  The session key is fixed to be `#{PutLocale.session_key()}`
  in order that downstream functions like those in `liveview` don't
  have to be passed options.

  ## Options

  * `:as` is an options that determines the format in which
    the locale is saved in the session. That valid settings
    for this options are:

    * `:string` in which the current locale is converted
      to a string before storing in the session. It will then
      be parsed back into a `%Cldr.LanguageTag{}` upon
      reading it from the session.  This option has the benefit
      that it will minimise space used in the session at the
      expense of the CPU time required to serialized and parse.
      The average size of commonly used locales is under 10 bytes
      and often less than 5.

    * `:language_tag` in which the current locale is stored
      in the session in its native `%Cldr.LanguageTag{}`
      format. This has the benefit of minimizing CPU time
      serialising and parsing the locale at the expense of
      a larger payment size in the session. The average
      size of a language tag struct, when serialized, is
      around 500 bytes.

  The default is `as: :string`.

  ## Examples

      # Define a router module that
      # sets the locale for the current process
      # and then also sets it in the session

      defmodule MyAppWeb.Router do
        use MyAppWeb, :router

        pipeline :browser do
          plug :accepts, ["html"]
          plug :fetch_session
          plug Cldr.Plug.SetLocale,
      	    apps: [:cldr, :gettext],
      	    from: [:path, :query],
      	    gettext: MyApp.Gettext,
      	    cldr: MyApp.Cldr
          plug Cldr.Plug.PutSession, as: :string
          plug :fetch_flash
          plug :protect_from_forgery
          plug :put_secure_browser_headers
        end
      end

  """

  @doc false
  def init(options \\ []) when is_list(options) do
    {as, options} = Keyword.pop(options, :as, :string)

    options_map =
      case as do
        :string ->
          if Application.get_env(:ex_cldr, :default_backend) do
            %{as: :string}
          else
            raise ArgumentError,
              """
              To save the locale in the session as a string requires
              that :default_backend be set in the :ex_cldr compile-time configuration.
              For example, in config.exs:

              config :ex_cldr,
                default_backend: MyApp.Cldr

              """
          end

        :language_tag ->
          %{as: :language_tag}

        other ->
          raise ArgumentError, "Invalid option for `:as`. Valid settings are :string or :language_tag. Found #{other}}"
      end

    if length(options) > 0,
      do: raise ArgumentError, "Invalid options. Valid option is `:as`. Found #{inspect options}"

    options_map
  end

  @doc false
  def call(conn, %{as: as}) do
    case PutLocale.get_cldr_locale(conn) do
      %Cldr.LanguageTag{} = cldr_locale ->
        conn = fetch_session(conn)

        locale =
          if as == :string do
            Cldr.to_string(cldr_locale)
          else
            cldr_locale
          end

        put_session(conn, PutLocale.session_key(), locale)

      _other ->
        conn
    end
  end
end

