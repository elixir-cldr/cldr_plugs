defmodule Cldr.Plug do
  @moduledoc """
  Functions to support setting the locale
  for Cldr and/or Gettext from the session.

  """

  @type application :: :cldr | :gettext
  @type applications :: [application]

  @session_key Cldr.Plug.PutLocale.session_key()

  @doc """
  Puts the locale from the session into the current
  process for `C;dr` and/or `Gettext`,

  This function is useful to place in the `on_mount`
  callback for a LiveView.

  ## Arguments

  * `session` is any map, typically the map returned
    as part of the `conn` of a Phoenix or Plug request,
    A `session` is passed as the first parameter to the
    `on_mount` callback of a LiveView request.

  * `applications` is a list of applications for which
    the locale may be set. The valid options are `:cldr`
    and `:gettext`. The default is `[:cldr, :gettext]`

  ## Returns

  * `{:ok, locale}` or

  * `{:error, {exception, reason}}`

  ## Example

      => Cldr.Plug.put_locale_from_session(session)
      => Cldr.Plug.put_locale_from_session(session, [:cldr])
      => Cldr.Plug.put_locale_from_session(session, [:cldr, :gettext])

      # In a LiveView
      def on_mount(:default, _params, session, socket) do
        {:ok, locale} = Cldr.Plug.put_locale_from_session(session)
      end

  """
  @spec put_locale_from_session(Cldr.LanguageTag.t(), applications) ::
    {:ok, Cldr.LanguageTag.t()} | {:error, {module(), String.t()}}

  def put_locale_from_session(locale, applications \\ [:cldr, :gettext])

  def put_locale_from_session(%{@session_key => locale}, applications) do
    with {:ok, locale} <- Cldr.validate_locale(locale) do
      Enum.reduce_while(applications, nil, fn
        :cldr, _acc ->
          {:cont, Cldr.put_locale(locale)}

        :gettext, _acc ->
          if locale.gettext_locale_name do
            gettext_backend = locale.backend.__cldr__(:config).gettext
            Gettext.put_locale(gettext_backend, locale.gettext_locale_name)
            {:cont, {:ok, locale}}
          else
            {:halt, {:error, {Cldr.UnknownLocaleError, "No gettext locale defined for #{inspect locale}"}}}
          end

        other, _acc ->
          raise ArgumentError,
            "Invalid application passed to Cldr.Plug.put_locale_from_session/2. " <>
            "Valid applications are :cldr and :gettext. Found #{inspect other}"
      end)
    end
  end

  def put_locale_from_session(_session, _options) do
    {:error, {Cldr.UnknownLocaleError, "No locale was found in the session"}}
  end
end