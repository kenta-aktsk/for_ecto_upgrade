defmodule ForEctoUpgrade.ReadRepo do
  defmacro __using__(opts) do
    master = __CALLER__.module
    read_repo = Module.split(__CALLER__.module) |> List.first |> Module.safe_concat(ReadRepo)
    quote location: :keep do
      @master unquote(master)
      @otp_app unquote(opts)[:otp_app] || Module.get_attribute(@master, :otp_app)
      @regexp unquote(opts)[:regexp] || Regex.compile!(".*#{unquote(read_repo)}[0-9]+", "i")
      Module.register_attribute __MODULE__, :slaves, accumulate: true
      @before_compile unquote(__MODULE__)

      contents = quote location: :keep do
        use Ecto.Repo, otp_app: unquote(@otp_app)
      end

      env = Application.get_all_env(@otp_app)
      Enum.each(env, fn({key, conf}) when is_atom(key) ->
        if Regex.match?(@regexp, Atom.to_string(key)) do
          Module.create(key, contents, Macro.Env.location(__ENV__))
          @slaves key
        end
      end)
    end
  end

  defmacro __before_compile__(env) do
    slaves = Module.get_attribute(env.module, :slaves) |> Enum.reverse
    master = Module.get_attribute(env.module, :master)
    count = length(slaves)
    quote location: :keep do
      def slaves do
        unquote(Macro.escape(slaves))
      end
      if unquote(count) > 0 do
        def slave do
          at = Enum.random(0..unquote(Macro.escape(count)) - 1)
          Enum.fetch!(slaves, at)
        end
      else
        def slave do
          unquote(master)
        end
      end
    end
  end
end
