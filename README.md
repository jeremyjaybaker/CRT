# crt

CRT, Crystal Ray Tracer, is a library for rendering 3D graphics using ray tracing based on The Ray Tracing Challenge book.

Generate docs using `crystal docs` and see docs/CRT.html.

## Project Samples

Some code from the book is "extra" and doesn't directly contribute to the ray tracer, but can be run as a demo/sample. These files exist in src/crt_samples/ and have bash scripts that can execute the given sample.

Available samples:

- projectile_sample: Renders path of a projectile with affects of wind and gravity to a PPM image.

- clock_sample: Renders the 12 points of a clock to a PPM image.

- silhouette_sample: Renders the silhouette of a sphere against a black background.

- lit_sphere_sample: Renders a red sphere with realistic shading.

- simple_scene_sample: Renders several spheres against a background made of spheres.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     crt:
       github: jeremyjaybaker/crt
   ```

2. Run `shards install`

## Usage

```crystal
require "crt"
```

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/jeremyjaybaker/crt/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Jeremy Baker](https://github.com/jeremyjaybaker) - creator and maintainer
