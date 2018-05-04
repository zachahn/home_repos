require "test_helper"

class CustomSettingsTest < ActiveSupport::TestCase
  def test_prefers_settings
    FakeFS do
      File.write("defaults.yml", <<~DEFAULTS)
        ---
        key: value
      DEFAULTS

      File.write("settings.yml", <<~OVERRIDES)
        ---
        key: overridden!
      OVERRIDES

      settings = CustomSettings.new(
        defaults: Pathname.new("defaults.yml"),
        settings: Pathname.new("settings.yml")
      )

      assert_equal("overridden!", settings.key)
    end
  end

  def test_falls_back_to_overrides_if_settings_file_doesnt_exist
    FakeFS do
      File.write("defaults.yml", <<~DEFAULTS)
        ---
        key: value
      DEFAULTS

      settings = CustomSettings.new(
        defaults: Pathname.new("defaults.yml"),
        settings: Pathname.new("settings.yml")
      )

      assert_equal("value", settings.key)
    end
  end

  def test_disallows_new_keys
    FakeFS do
      File.write("defaults.yml", <<~DEFAULTS)
        ---
        key: value
      DEFAULTS

      File.write("settings.yml", <<~OVERRIDES)
        ---
        doesnt_exist: overridden!
      OVERRIDES

      assert_raises(CustomSettings::InvalidOverriddenKeys) do
        CustomSettings.new(
          defaults: Pathname.new("defaults.yml"),
          settings: Pathname.new("settings.yml")
        )
      end
    end
  end
end
