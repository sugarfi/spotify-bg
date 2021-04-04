require "json"
require "base64"
require "http/client"

class Image
    include JSON::Serializable
    
    property width : Int32
    property height : Int32
    property url : String
end

class Album
    include JSON::Serializable

    property images : Array(Image)
end

class Track
    include JSON::Serializable

    property album : Album
end

class Item
    include JSON::Serializable

    property track : Track
end

class Tracks
    include JSON::Serializable

    property tracks : Array(Item)
end

json = Array(Tracks).from_json(File.read ARGV[0]? || "playlists.json")

WIDTH = (ENV["SPOTIFY_BG_WIDTH"]? || 1920).to_i
HEIGHT = (ENV["SPOTIFY_BG_HEIGHT"]? || 1080).to_i
IMG_WIDTH = (ENV["SPOTIFY_IMG_WIDTH"]? || 30).to_i
IMG_HEIGHT = (ENV["SPOTIFY_IMG_HEIGHT"]? || 30).to_i

o = %(<svg xmlns="http://www.w3.org/2000/svg" width="#{WIDTH}" height="#{HEIGHT}" xmlns:xlink="http://www.w3.org/1999/xlink">)

x = 0
y = 0

while y <= HEIGHT
    json[0].tracks.shuffle.each do |item|
        image = item.track.album.images[-1]
        STDERR.puts image.url
        data = HTTP::Client.get(image.url).body
        base64 = "data:image/png;base64,#{Base64.encode data}"
        o += %(<image xlink:href="#{base64}" width="#{IMG_WIDTH}" height="#{IMG_HEIGHT}" x="#{x}" y="#{y}" />)

        x += IMG_WIDTH
        if x >= WIDTH
            x = 0
            y += IMG_HEIGHT
        end
    end
end

o += "</svg>"

File.write "out.svg", o
