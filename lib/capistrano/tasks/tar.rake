# frozen_string_literal: true

# -*- mode: ruby -*-
namespace :tar do
  task :create_release do
    unless ENV['package']
      abort "require 'package=<path/to/archive.tar.gz>' environment variable by tar scm"
    end

    on release_roles :all do
      pkg = ENV['package']
      rev = (File.basename(pkg).split('.') - ['tar', 'gz', 'tgz']).join('.')
      tmp = capture 'mktemp'

      # upload tarball
      upload! pkg, tmp

      # expand tarball
      execute :mkdir, '-p', release_path
      execute :tar, '-xzpf', tmp, '-C', release_path
      set :current_revision, rev

      # cleanup
      execute :rm, tmp
    end
  end

  task :check
  task :set_current_revision
end
