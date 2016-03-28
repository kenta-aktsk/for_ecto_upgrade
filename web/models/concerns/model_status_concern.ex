defmodule ForEctoUpgrade.ModelStatusConcern do
  defmacro __using__(opts) do
    quote location: :keep do
      alias ForEctoUpgrade.Enums.Status
      @spec valid(Ecto.Queryable.t) :: Ecto.Query.t
      def valid(query) do
        from r in query, where: r.status == ^Status.valid.id
      end
    end
  end
end
