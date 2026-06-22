class PluginTextRenderContext {
  final String locale;
  final String fallbackLocale;

  const PluginTextRenderContext({
    required this.locale,
    this.fallbackLocale = 'en',
  });

  const PluginTextRenderContext.english()
      : locale = 'en',
        fallbackLocale = 'en';
}
