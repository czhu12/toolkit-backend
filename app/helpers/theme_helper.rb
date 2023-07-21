module ThemeHelper
  def theme_options
    [
      [t("themes.system"), ""],
      [t("themes.light"), "light"],
      [t("themes.dark"), "dark"]
    ]
  end
end
