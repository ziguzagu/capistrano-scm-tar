require 'capistrano/scm/tar/version'
require 'capistrano/scm/plugin'

module Capistrano
  class SCM
    class Tar
      class Plugin < ::Capistrano::SCM::Plugin
        def set_defaults
        end

        def self.authentication
          [ENV['http_user'], ENV['http_password']]
        end

        def self.revision
          ::File.basename(ENV['package_uri'] || ENV['package']).split('.')[0]
        end

        def self.find_package
          return ::File.open(ENV['package']) unless ENV['package_uri']
          require 'open-uri'
          require 'tempfile'
          tmp = ::Tempfile.new revision(ENV['package_uri'])
          tmp.binmode
          tmp.write(open(ENV['package_uri'], http_basic_authentication: authentication).read)
          tmp
        end

        def self.cleanup(tmp)
          tmp.close
          return unless ENV['package_uri']
          tmp.unlink
        end

        def self.with_package_file
          pkg = find_package
          yield(pkg)
          cleanup pkg
        end

        def define_tasks
          namespace :tar do
            task :create_release do
              unless ENV['package_uri'] || ENV['package']
                abort "require 'package=<path/to/archive.tar.gz>' or 'package_uri=URI' environment variable by tar scm"
              end

              on release_roles :all do
                # Make temporary File for artifact
                tmp = capture 'mktemp'

                if ENV['remote'] && ENV['package_uri']
                  execute :curl, '-sS', ENV['package_uri'], '-o', tmp, '>/dev/null'
                else
                  ::Capistrano::SCM::Tar::Plugin.with_package_file do |pkg|
                    upload! pkg.path, tmp
                  end
                end

                # Expand Tarball
                execute :mkdir, '-p', release_path, '&&', :tar, '-xzpf', tmp, '-C', release_path, ';', :rm, tmp

                # Update revision
                set :current_revision, ::Capistrano::SCM::Tar::Plugin.revision
              end
            end

            task :check
            task :set_current_revision
          end
        end

        def register_hooks
          after "deploy:new_release_path", "tar:create_release"
        end
      end
    end
  end
end
