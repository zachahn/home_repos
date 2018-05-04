class CustomSettings
  def initialize(defaults:, settings:)
    @defaults = read_settings_file(defaults)
    @overrides = read_settings_file(settings)
    @settings = {}

    resolve_settings!
  end

  private

  def resolve_settings!
    handle_unknown(@overrides.keys - @defaults.keys)

    @defaults.each do |key, value|
      @settings[key] =
        if @overrides.key?(key)
          @overrides[key]
        else
          value
        end

      getter_define(key)
    end
  end

  def getter_define(key)
    class_eval(<<~GETTER, __FILE__, __LINE__)
      def #{key}
        @settings[:#{key}]
      end
    GETTER
  end

  def read_settings_file(path)
    if path.exist?
      YAML.load(File.read(path)).deep_symbolize_keys
    else
      {}
    end
  end

  def handle_unknown(unknown_settings)
    if unknown_settings.any?
      raise InvalidOverriddenKeys,
        "Tried to override unknown keys: #{unknown_settings.join(", ")}"
    end
  end

  class InvalidOverriddenKeys < StandardError
  end
end
