require 'logger'
require 'rubygems'

gem 'moneta'
gem 'json'

require 'pathname'
require 'moneta'
require "#{File.dirname(__FILE__)}/../vendor/moneta-yaml"
require 'json'

class Jaunte
  attr_accessor :store
  
  def self.default_store; @@default_store end
  def self.default_store=(store); @@default_store = store end
  
  def initialize options={}
    @jaunte_dir = options[:jaunte_dir] || "#{ENV['HOME']}/.jaunte"
    
    Dir.mkdir(@jaunte_dir) unless File.exists?(@jaunte_dir)
    
    @@default_store ||= Moneta::YAML.new(:path => "#{@jaunte_dir}/catalog.yaml")
    
    @logger = Logger.new("#{@jaunte_dir}/jaunte.log")
    
    @store = options[:store] || @@default_store
  end
  
  def weigh path, tag, tags, i
    i == 0 ? 1 : 0 #1 - (i * (1.0 / tags.length)) ** 2
  end
  
  def taggify path
    path.split(/[\W\/]+/).reject { |el| el.nil? || el.empty? }.
      map { |el| el.downcase }.reverse
  end
  
  def append dir
    path = Pathname.new(dir).expand_path.to_s
    tags = taggify(path)
    tuples = []

    tags.each_with_index do |tag, i|
      key = "#{tag}:paths"
      score_key = "#{path}:#{tag}:score"
      score = (@store.has_key?(score_key) ? @store[score_key] : 0) +
        weigh(path, tag, tags, i)
        
      tuples << [tag, score]

      @store[key] ||= []
      @store[key] = @store[key] << path unless @store[key].include?(path)
      @store[score_key] = score
    end
    
    @logger.debug("APPEND: #{path}\n  #{tuples.to_json}")
  end
  
  def stat tag
    paths = @store["#{tag}:paths"] || []
    tuples = paths.map { |path| [@store["#{path}:#{tag}:score"] || 0, path] }.
      sort { |a, b| b[0] <=> a[0] }
      
    @logger.debug("STAT: #{tag}\n  #{tuples.to_json}")

    tuples
  end
  
  def jump tag
    stats = stat(tag) || []
    tuple = stats[0] || []
    
    @logger.debug("JUMP: #{tag}\n  #{tuple.to_json}")
    
    tuple[1] || ""
  end
end