#!/usr/bin/env ruby

class Shuffler
  attr_reader :songs, :positions

  def initialize
    @songs     = Dir.entries(__dir__).select {|file| file.match(/.mp3\z|.wav\z/) }
    @positions = (1..songs.size).to_a
  end

  def shuffle
    songs.each do |song|
      position = positions.delete(positions.sample)
      name     = "#{position}. #{song}"
      rename_file(song, name)
    end
  end

  def unshuffle
    songs.each do |song|
      name = song.gsub(/\A\d+. /, "")
      rename_file(song, name)
    end
  end

  private

  def rename_file(old_name, new_name)
    File.rename(__dir__ + "/#{old_name}", __dir__ + "/#{new_name}")
  end
end

loop do
  system("clear")

  puts "==========SHUFFLER========="
  puts "| What do you want to do? |"
  puts "|                         |"
  puts "| 1. shuffle              |"
  puts "| 2. reshuffle            |"
  puts "| 3. unshuffle            |"
  puts "| 4. export playlist      |"
  puts "| 0. exit                 |"
  puts "==========================="

  print "Enter operation: "
  choice = gets.chomp

  case choice
  when "1"
    puts "Working ..."
    Shuffler.new.shuffle
    puts "Done!"
    print "Press ENTER."

  when "2"
    puts "Working ..."
    Shuffler.new.unshuffle
    Shuffler.new.shuffle
    puts "Done!"
    print "Press ENTER."

  when "3"
    puts "Working ..."
    Shuffler.new.unshuffle
    puts "Done!"
    print "Press ENTER."

  when "4"
    puts "Working ..."
    File.open(__dir__ + "/Playlist.txt", "w+") do |f|
      f.puts(Shuffler.new.songs.map { |song| song.gsub(/.mp3\z|.wav\z/, "") })
    end
    puts "Done!"
    print "Press ENTER."
    system("subl #{__dir__}/Playlist.txt")

  when "0"
    puts "Bye!"
    break

  else
    print "Invalid choice. Press ENTER to restart ..."
  end

  gets
end
