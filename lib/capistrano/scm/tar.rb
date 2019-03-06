require 'capistrano/scm/tar/version'
require 'capistrano/scm/plugin'

module Capistrano
  class SCM
    class Tar
      class Plugin < ::Capistrano::SCM::Plugin
        def set_defaults
        end

        def find_package
          return ::File.open(ENV['package']) unless ENV['package_uri']
          require 'open-uri'
          tmp = ::Tempfile.new
          tmp.binmode
          tmp.write(open(ENV['package_uri']).read)
          tmp
        end

        def cleanup(tmp)
          tmp.close
          return unless ENV['package_uri']
          tmp.unlink
        end

        def with_package_file
          pkg = find_package
          yield(pkg)
          cleanup pkg
        end

        def define_tasks
          namespace :tar do
            task :create_release do
              unless ENV['package_uri'] || ENV['package']
                abort "require 'package=<path/to/archive.tar.gz' or 'package_uri=URI' environment variable by tar scm"
              end

              on release_roles :all do
                with_package_file do |pkg|
                  # Derive revision
                  rev = pkg.basename.split('.')[0]

                  # Create Temporary File for upload
                  tmp = capture 'mktemp'

                  # Upload Package
                  upload! f.path, tmp

                  # Expand Tarball
                  execute :mkdir, '-p', release_path
                  execute :tar, '-xzpf', tmp, '-C', release_path

                  # Update revision
                  set :current_revision, rev

                  # cleanup Tempfiles
                  execute :rm, tmp
                end
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
