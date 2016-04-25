var path = require("path");
var webpack = require("webpack");

var config = module.exports = {
  // the base path which will be used to resolve entry points
  context: __dirname,
  // the main entry point for our application's frontend JS
  entry: path.join(__dirname, "frontend", "javascripts", "entry.js"),

  // No plugins by default
  plugins: [],

  // Our Vue configuration
  module: {
    // `loaders` is an array of loaders to use
    loaders: [
      {
        test: /\.vue$/, // a regex for matching all files that end in `.vue`
        loader: 'vue'   // loader to use for matched files
      },
      // We need an HTML loader to load our Vue templates
      {
        test: /\.html$/,
        loader: "html"
      },
    ]
  }
};

config.output = {
  // this is our app/assets/javascripts directory, which is part of the Sprockets pipeline
  path: "app/assets/javascripts/",
  // the filename of the compiled bundle, e.g. app/assets/javascripts/bundle.js
  filename: "public-bundle.js",
  // if the webpack code-splitting feature is enabled, this is the path it"ll use to download bundles
  publicPath: "/assets/",
};

config.resolve = {
  // tell webpack which extensions to auto search when it resolves modules. With this,
  // you"ll be able to do `require("./utils")` instead of `require("./utils.js")`
  extensions: ["", ".js"],
  // by default, webpack will search in `web_modules` and `node_modules`
  modulesDirectories: [ "node_modules",
                        "app/frontend/javascripts"
                      ],
};