namespace :parkviet do
  desc "Back up configured databases outside the repository before preparing their schema"
  task prepare: :environment do
    require "fileutils"
    require "open3"

    root = Pathname.new(ENV.fetch("PARKVIET_BACKUP_DIR", File.join(Dir.home, ".local/share/parkviet/backups"))).expand_path
    abort "Backup directory must be outside the repository" if root.to_s.start_with?(Rails.root.to_s + "/") || root == Rails.root
    FileUtils.mkdir_p(root, mode: 0o700)
    environments = Rails.env.development? ? %w[development test] : [ Rails.env ]
    configurations = environments.flat_map { |environment| ActiveRecord::Base.configurations.configs_for(env_name: environment) }
    configurations.each do |config|
      values = config.configuration_hash
      database = values[:database]
      abort "Missing database configuration" if database.blank?
      env = { "PGPASSWORD" => values[:password].to_s }
      args = [ "pg_dump", "--format=custom", "--file=#{root.join("#{config.name}-#{config.env_name}-#{Time.now.utc.strftime('%Y%m%d%H%M%S')}.dump")}" ]
      { host: "--host", port: "--port", username: "--username" }.each { |key, flag| args.concat([ flag, values[key].to_s ]) if values[key].present? }
      args << database
      _output, _error, status = Open3.capture3(env, *args)
      abort "Database backup failed; no schema changes were applied." unless status.success?
      puts "Backed up #{config.name} (#{config.env_name}) outside Git."
    end
    Rake::Task["db:prepare"].invoke
    Rake::Task["db:seed"].invoke
  end
end
