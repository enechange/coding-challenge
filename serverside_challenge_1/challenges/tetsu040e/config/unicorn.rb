rails_root = File.expand_path('../../', __FILE__)
ENV['BUNDLE_GEMFILE'] = rails_root + "/Gemfile"

worker_processes  2
timeout           15
working_directory rails_root
pid               File.expand_path 'tmp/pids/unicorn.pid', rails_root
listen            3000
stdout_path       File.expand_path 'log/unicorn.log', rails_root
stderr_path       File.expand_path 'log/unicorn.log', rails_root
preload_app       true
