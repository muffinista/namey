require 'bundler'
Bundler::GemHelper.install_tasks


require "namey/version"

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov_opts = %w{--exclude .bundler,.rvm}
  spec.rcov = true
end

task :default => :spec



desc "Generate RDoc"
task :doc => ['doc:generate']


#
# YARD task from http://stackoverflow.com/questions/2138427/can-i-get-my-readme-textile-into-my-rdoc-with-proper-formatting
#
namespace :doc do
  project_root = File.expand_path(File.join(File.dirname(__FILE__)))
  doc_destination = File.join(project_root, 'doc')

  begin
    require 'yard'
    require 'yard/rake/yardoc_task'

    YARD::Rake::YardocTask.new(:generate) do |yt|
      yt.files   = Dir.glob(File.join(project_root, 'lib', '**', '*.rb'))
      #+ 
      #             [ File.join(project_root, 'README.markdown') ]
      yt.options = ['--output-dir', doc_destination, '--readme', 'README.markdown']
    end
  rescue LoadError
    desc "Generate YARD Documentation"
    task :generate do
      abort "Please install the YARD gem to generate rdoc."
    end
  end

  desc "Remove generated documenation"
  task :clean do
    rm_r doc_destination if File.exists?(doc_destination)
  end

end
