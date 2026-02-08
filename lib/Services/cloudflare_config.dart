class CloudflareConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'CLOUDFLARE_API_BASE_URL',
    defaultValue: 'https://blood.amhmeed31.workers.dev',
  );

  static const String configEndpoint = String.fromEnvironment(
    'CLOUDFLARE_CONFIG_ENDPOINT',
    defaultValue: 'https://blood.amhmeed31.workers.dev/config',
  );

  static const String configToken = String.fromEnvironment(
    'CLOUDFLARE_CONFIG_TOKEN',
    defaultValue: '',
  );
}
