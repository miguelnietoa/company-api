import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :company_api, CompanyApi.Repo,
  username: "miguelnietoa",
  password: "",
  database: "company_api_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :company_api, CompanyApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "7sdWWLTRmxMYX1T4aeqo9B0VWFgkFlIF4jNxjWwUl3FlssqeTuHHXamFuz0KcRzt",
  server: false

# In test we don't send emails.
config :company_api, CompanyApi.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
