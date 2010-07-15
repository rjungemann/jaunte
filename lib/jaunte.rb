require 'rubygems'

gem "moneta"
gem "json"

require 'pathname'
require 'moneta'
require "#{File.dirname(__FILE__)}/../vendor/moneta-yaml"
require 'json'

class Jaunte
  attr_accessor :store
  
  @@default_store = Moneta::YAML.new(:path => "#{@jaunte_dir}/catalog.yaml")
  
  def self.default_store; @@default_store end
  def self.default_store=(store); @@default_store = store end
  
  def initialize options={}
    @jaunte_dir = options[:jaunte_dir] || "#{ENV['HOME']}/.jaunte"
    
    Dir.mkdir(@jaunte_dir) unless File.exists?(@jaunte_dir)
    
    @store = options[:store] || @@default_store
  end
  
  def weigh path, tag, tags
    1 - (tags.index(tag) * (1.0 / tags.length)) ** 2
  end
  
  def taggify path
    path.split(/[\W\/]+/).reject { |el| el.nil? || el.empty? }.
      map { |el| el.downcase }.reverse
  end
  
  def append dir
    path = Pathname.new(dir).expand_path.to_s
    tags = taggify(path)

    tags.each_with_index do |tag, i|
      key = "#{tag}:paths"
      score_key = "#{path}:#{tag}:score"
      score = (@store.has_key?(score_key) ? @store[score_key] : 0) +
        weigh(path, tag, tags)

      @store[key] ||= []
      @store[key] = @store[key] << path unless @store[key].include?(path)
      @store[score_key] = score
    end
  end
  
  def stat tag
    paths = @store["#{tag}:paths"] || []
    tuples = paths.map { |path| [@store["#{path}:#{tag}:score"] || 0, path] }.
      sort { |a, b| a[0] <=> b[0] }

    tuples
  end
  
  def jump tag
    stats = stat(tag) || []
    tuple = stats[0] || []
    
    tuple[1] || ""
  end
end