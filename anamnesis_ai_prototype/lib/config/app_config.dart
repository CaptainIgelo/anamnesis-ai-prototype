class AppConfig {
  static const bool useMockOpenAi = bool.fromEnvironment(
    'USE_MOCK_OPENAI',
    defaultValue: true,
  );

  static const String openAiApiKey = String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue: 'mock-key-local-later',
  );
}
