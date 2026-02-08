class CloudflareConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'CLOUDFLARE_API_BASE_URL',
    defaultValue: 'https://blood.amhmeed31.workers.dev',
  );
}
