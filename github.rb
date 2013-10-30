##
# This class is used to detect the favorite language for a github user.
require 'json'
require 'net/http'
require 'uri'
class Github
  USERNAME_NOT_FOUND = "Username not found"

  attr_reader :username

  ##
  # Creates a new Github to handle all process to get user's repositories and
  # get the favorite language.
  #
  # If the github user has repositories:
  #   - if the repositories has languages setted, it counts how many
  #     repositories per languages has the user and returns all the languages
  #     names that matches this number.
  #   - if the user doesn't have public respositories, it returns "None" as
  #     the favorite language.
  #   - if github doesn't find the username, it returns 'Username not found'.

  def initialize(args={})
    @username = args[:username]
    get_repos
  end

  # Gets the number of maximun respositories for all languages
  def max_repos
    repos_per_languages.values.max
  end

  # Gets the name(s) for the languages that matchs the number of {#max_repos}
  # if the repos info is not valid, it returns 'Username not found' based on
  # response of {#is_valid?}.
  def max_languages_names
    if is_valid?
      return "None" if repos_per_languages.empty?
      repos_per_languages.reject{|k,v| v < max_repos}.keys.join(", ")
    else
      USERNAME_NOT_FOUND
    end
  end

  # Gets a Hash with all languages detected and the number of repos per
  # language.
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

  # Respos values needs to be an array, if the username is not found in github,
  # the api response with a message => 'Not Found'
  def is_valid?
    repos.is_a?(Array) || (repos[:message] == "Not Found")
  end

  def get_repos
    @repos ||= JSON.parse(Net::HTTP.get_response(URI.parse("https://api.github.com/users/#{username}/repos")).body)
  end
end