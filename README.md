favorite-language
=================

Command line application to obtain a user's favorite language.


Usage:
-----

Show options:

```
ruby favorite -h 

Usage: favorite.rb [options] -u GITHUB-USERNAME
    -u, --username GITHUB-USERNAME   Set github username to see favourite language
    -v, --[no-]verbose               Run verbosely
    -h, --help                       Show this message
        --version                    Show version
```

If the username has public respositories:

```
ruby favorite -u username
The user's favorite(s) language(s): Ruby
```

If the username doesn't exists:

```
ruby favorite -u username
The user's favorite(s) language(s): Username not found
```

Run tests:

```
ruby github_test.rb
```

I mocked the http resquests in tests and put 4 json files to represent the cases I'm testing.
All json files has the same structure as an api response, only with less data, the data I use
to get all the info.

```
tests/data/no_repos.json    The username doesn't have public repositories.
tests/data/not_found.json   Github API returns a not found username.
tests/data/repos.json       Repositories info for a username, only with 1 language as favorite.
tests/data/repos_more.json  Repositories info for a username, with 2 language as favorite. 
                            Ruby and Python have 3 repositories each one.
```