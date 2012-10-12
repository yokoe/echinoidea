# Echinoidea

A command line unity project build helper.

## Installation

Install it yourself as:

    $ gem install echinoidea

## Usage

Create `echinoidea.yml` in root directory of your unity project.

```
scenes:
  - Assets/Scenes/Foo.unity
  - Assets/Scenes/Bar.unity
```

Learn more about configuration? see here: https://github.com/yokoe/echinoidea/wiki/Configuration

Then run `echinoidea`.

```
echinoidea -o [OUTPUT_DIRECTORY]
```

`-t Android` for Android project

```
echinoidea -o [OUTPUT_DIRECTORY] -t Android
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
