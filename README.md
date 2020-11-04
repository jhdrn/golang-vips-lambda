

# Go Libvips Lambda Layer

AWS Lambda layer with image processing library [libvips](https://github.com/libvips/libvips) for use with for example [govips](https://github.com/davidbyttow/govips). Based on [ruby-vips-lambda](https://github.com/customink/ruby-vips-lambda).


## Usage

* Clone or fork this repository.
* Make sure you have Docker or AWS CLI installed.
* Run `./bin/deploy`

From there you simply use the arn in your AWS SAM `template.yaml` file.
