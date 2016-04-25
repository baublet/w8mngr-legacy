namespace :webpack do
  desc 'compile bundles using webpack'
  task :compile do
    build = File.open("./webpack-build.json", "rb")
    contents = build.read
    build.close

    stats = JSON.parse(contents)

    File.open('./public/assets/webpack-asset-manifest.json', 'w') do |f|
      f.write stats['assetsByChunkName'].to_json
    end
  end
end