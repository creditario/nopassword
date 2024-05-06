module NoPassword
  module NoPasswordHelper
    def no_password_importmap_tags(entry_point = "application")
      safe_join [
        javascript_inline_importmap_tag(NoPassword.configuration.importmap.to_json(resolver: self)),
        javascript_importmap_module_preload_tags(NoPassword.configuration.importmap),
        javascript_import_module_tag(entry_point)
      ].compact, "\n"
    end
  end
end
