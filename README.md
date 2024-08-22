# ZenohexPhoenixDemo

## Deploy locally

This operation can be confirmed in `MIX_ENV=dev` or default setting.

  * Run `mix setup` to install and setup dependencies
  * Run `mix compile` to compile project
  * Then, start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit `http://localhost:4000` from your browser.

## Deploy on the cloud (or servers)

Note: we only confirmed the operation of this repository on the cloud VM in `MIX_ENV=prod`

To start your Phoenix server:

  * Adjust [config/config.exs#L15](https://github.com/b5g-ex/zenohex_phoenix_demo/blob/main/config/config.exs#L15) and [config/runtime.exs#L36](https://github.com/b5g-ex/zenohex_phoenix_demo/blob/main/config/runtime.exs#L36) to your server's URL
  * Run `mix deps.get --only prod` to install and setup dependencies
  * Run `MIX_ENV=prod mix compile` to compile project
  * Run `MIX_ENV=prod mix assets.deploy` to assets
  * Run `MIX_ENV=prod mix phx.gen.secret`, and set the result to `$SECRET_KEY_BASE`
  * Then, start Phoenix endpoint with `MIX_ENV=prod mix phx.server` or inside IEx with `MIX_ENV=prod iex -S mix phx.server`

Now you can visit `http://<your_vm_url>:4000` from your browser.

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
