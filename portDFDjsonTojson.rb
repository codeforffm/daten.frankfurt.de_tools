#!/usr/bin/env ruby

require 'json'

raise "input and output parameter required" unless ARGV.length == 2

input = ARGV[0]
output = ARGV[1]

file = File.open(input).read()
districts = JSON.parse(file)

raise 'Expected array' unless districts.instance_of?(Array)

relevant_keys = lambda {|key| key =~ /(rztedichte.+2012|rzte.+je 10.000 Einwohner.+2012)/}

puts "Relevant keys", districts.first.keys.select(&relevant_keys)
puts

key_map = {
  'Gesundheit Ärztedichte  2012': 'Ärztedichte',
  'Gesundheit Niedergelassene Kassenärztinnen und Kassenärzte, Fachgebiet Allgemeinmedizin je 10.000 Einwohner/innen  2012': 'Hausarzt',
  'Gesundheit Niedergelassene Kassenärztinnen und Kassenärzte, Fachgebiet Kinder- und Jugendmedizin je 10.000 Einwohner/innen  2012': "Kinder- und Jugendarzt",
  'Gesundheit Niedergelassene Kassenzahnärztinnen und Kassenzahnärzte je 10.000 Einwohner/innen  2012': 'Zahnarzt'
}

districts.each do |district|
  puts district['Stadtteil']
  district.keys.select(&relevant_keys).each do |key|
    value = district[key]
    puts "#{key}: #{value}"
  end
end