##
# This class is used to detect the favorite language for a github user.
require 'json'
require 'net/http'
require 'uri'
class Github
  USERNAME_NOT_FOUND = "Username not found"

  attr_reader :username

  def initialize(args={})
    @username = args[:username]
    get_repos
  end

  def max_repos_size
    repos_per_languages.values.max
  end

  def max_languages_names
    if is_valid?
      return "None" if repos_per_languages.empty?
      repos_per_languages.reject{|k,v| v < max_repos_size}.keys.join(", ")
    else
      USERNAME_NOT_FOUND
    end
  end

  def repos_per_languages
    @resume ||= repos.inject(Hash.new(0)) do |res, repository|
      res[repository["language"]] += 1 unless not_qualify?(repository)
      res
    end
  end

  private
  attr_reader :repos, :resume

  # We use only one point to check if a repository can be counted for a language
  def not_qualify?(repository)
    !repository.is_a?(Hash) || (repository["fork"] || repository["private"] || repository["language"].nil?)
  end

 def is_valid?
    repos.is_a?(Array) || (repos[:message] == "Not Found")
  end

  def get_repos
    @repos ||= JSON.parse(Net::HTTP.get_response(URI.parse("https://api.github.com/users/#{username}/repos")).body)
  end
end