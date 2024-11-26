# frozen_string_literal: true

require_relative 'lib/vng_storage_active_storage/version'

Gem::Specification.new do |spec|
  spec.name = 'vng_storage_active_storage'
  spec.version = VngStorageActiveStorage::VERSION
  spec.authors = ['Alpha']
  spec.email = ['alphanolucifer@gmail.com']

  spec.summary = 'ActiveStorage Service for VNG Storage'
  spec.description = 'ActiveStorage Service for VNG Storage'
  spec.homepage = 'https://github.com/zgid123/vng_storage_active_storage'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(
          *%w[
            bin/
            test/
            spec/
            features/
            .git
            .circleci
            appveyor
            examples/
            Gemfile
            .rubocop.yml
            .vscode/settings.json
            LICENSE.txt
            lefthook.yml
          ]
        )
    end
  end

  spec.require_paths = ['lib']
end
