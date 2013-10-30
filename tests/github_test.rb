require 'minitest/autorun'
require 'webmock/minitest'
require_relative '../github'

describe Github do

  describe "general tests" do

    before do
      username = "usertest"
      stub_request(:get, "https://api.github.com/users/#{username}/repos").to_return(:status => 200, :body => File.read(File.expand_path("../data/repos.json", __FILE__)), :headers => {})
      @github = Github.new({username: username})
    end

    it "should return the maximun language name when runs" do
      @github.max_languages_names.must_be_kind_of String
      @github.max_languages_names.must_equal "Ruby"
    end

    it "should a list of languages and how many repos has each one" do
      @github.repos_per_languages.must_be_kind_of Hash
      @github.repos_per_languages.keys.must_equal ["Ruby","Python","JavaScript"]
    end

    it "should return the maximun number of repos" do
      @github.max_repos.must_equal 3
    end
  end

  describe "max repos count return more than one leanguage" do
    it "should return Ruby and Python as the max lenguage" do
      username = "usertest"
      stub_request(:get, "https://api.github.com/users/#{username}/repos").to_return(:status => 200, :body => File.read(File.expand_path("../data/repos_more.json", __FILE__)), :headers => {})
      github = Github.new({username: username})
      github.max_languages_names.must_equal "Ruby, Python"
    end
  end

  describe "the username doesn't have public respositories" do
    it "should return Ruby and Python as the max lenguage" do
      username = "usertest"
      stub_request(:get, "https://api.github.com/users/#{username}/repos").to_return(:status => 200, :body => File.read(File.expand_path("../data/no_repos.json", __FILE__)), :headers => {})
      github = Github.new({username: username})
      github.max_languages_names.must_equal "None"
    end
  end

  describe "username not found in github" do
    it "should return Ruby and Python as the max lenguage" do
      username = "usertest"
      stub_request(:get, "https://api.github.com/users/#{username}/repos").to_return(:status => 200, :body => File.read(File.expand_path("../data/not_found.json", __FILE__)), :headers => {})
      github = Github.new({username: username})
      github.max_languages_names.must_equal Github::USERNAME_NOT_FOUND
    end
  end
end