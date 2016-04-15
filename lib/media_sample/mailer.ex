defmodule MediaSample.Mailer do
  import Phoenix.View, only: [render_to_string: 3]
  import MediaSample.Gettext
  alias MediaSample.{LayoutView, MailView}

  def deliver(email) do
    task = Mailman.deliver(email, context)
    {:ok, task}
  end

  def context do
    config = Application.get_env(:media_sample, __MODULE__)
    %Mailman.Context{
      config: %Mailman.SmtpConfig{
        relay: config[:server],
        username: config[:username],
        password: config[:passoword],
        port: 587,
        tls: :always,
        auth: :always},
     composer: %Mailman.EexComposeConfig{}
    }
  end

  def testing_email(assign \\ %{}) do
    config = Application.get_env(:media_sample, __MODULE__)
    %Mailman.Email{
      subject: "Hello Mailman!",
      from: config[:sender],
      to: [config[:sender]],
      text: "Hello Mate",
      html: render_to_string(MailView, "test.html", put_layout(assign))}
  end

  def confirmation_email(%Plug.Conn{}=conn, to, token) do
    config = Application.get_env(:media_sample, __MODULE__)
    %Mailman.Email{
      subject: gettext("confirmation instructions"),
      from: config[:sender],
      to: [to],
      # text: "Hello",
      html: render_to_string(MailView, "confirmation_instructions.html", %{conn: conn, token: token} |> put_layout)}
  end

  def put_layout(assign) do
    Map.put(assign, :layout, {LayoutView, "mail.html"})
  end
end
