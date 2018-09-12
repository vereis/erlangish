# Erlangish
Erlangish is a compiler which produces ES6 JavaScript from sequential Erlang source code; bringing Erlang's terse, clear and powerful syntax to the web.

## Overview
Erlangish's implementation is based on the same simple pipeline used in [Jarlang](https://github.com/vereis/jarlang):

1) Use the standard Erlang compiler to generate a CoreErlang AST
2) Parse and translate CoreErlang AST into a JavaScript AST derived from [JSTree](https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey/Parser_API)
3) Offload code generation to tried and tested NodeJS tools such as [escodegen](https://github.com/estools/escodegen)

## Getting Started
As of the time of writing, Erlangish is still very much in its infancy and doesn't function.

## Development Environment
### Pre-requisites
- `OTP 20` or later (older/newer versions may work but development is primarily done against OTP 20.3.8.5)
- `NodeJS v8.8.0` (older/newer versions may work but development is primarily done against v8.8.0)

The easiest way to install specific versions of Erlang/OTP is to self build via [Kerl](https://github.com/kerl/kerl) or via the [asdf](https://github.com/asdf-vm/asdf) package manager; otherwise use the [Erlang Solution packages](https://www.erlang-solutions.com/resources/download.html).

Please refer to the canonical installation instructions for your operating system to install NodeJS.

### Downloading & Building
Clone the repository via:
```shell
git clone https://github.com/vereis/erlangish
```

Erlangish is implemented as a standard `rebar3` umbrella project. You can find configuration files in `$PROJECT_DIR/config/` and source code in `$PROJECT_DIR/apps/erlangish/src/`. 

You can build Erlangish as follows:
```shell
make
```

This will build both a standard OTP release and accompanying `escript` for Erlangish. The OTP release can be executed like any other, and by default can be found in `$PROJECT_DIR/_build/default/rel/erlangish/bin/erlangish`, however, the `escript` found in `$PROJECT_DIR/_build/default/bin/` is the intended way of running the application. Refer to usage instructions for more information.

### Testing
Simply do the following to execute Erlangish's test suite which consists of EUnit tests, CommonTests, Elvis (for linting) and Dialyzer checks. All must pass for a build to succeed.

```shell
make test
```

## Contributing
When intending to contribute to this project, reach out to any of the owners of the repository (via issue, email, or anything else) before making changes. This will minimise the chances of wasted time on either side.

### Pull Request Process
1) Update this README with details of changes if neccessary. This means adding usage instructions, pointing out important or useful file locations, variables, parameters etc.
2) Increase the version numbers of any files you modify according to semantic versioning rules which you can find [here](https://semver.org/). We usually implement semantic versioning via a `vsn` directive which is a 3-tuple (i.e. `-vsn({Major, Minor, Patch})`) in Erlang source files. Otherwise we do so as an ordinary string.
3) Make the pull request and once you have the sign off from a developer feel free to merge it in. Otherwise a reviewer can merge it in for you. A pre-requisite to this is that no tests fail and there aren't any linting errors or dialyzer errors.

## Acknowledgements
- [Jarlang](https://github.com/vereis/jarlang), as this is essentially a spiritual rewrite of that project. Much was learnt from this project and from experiences developing it.
- The escodegen team for making JavaScript code generation painless.
- Mozilla (?) for documenting the JavaScript AST as well as they did.
