# frozen_string_literal: true

require_relative 'lib/pass_parser'

##
# This is the main class for the challenge
class AOC5
  ##
  # @params input [String] file name
  def self.run_first_step(input)
    seat_id = new(input).highest_seat_id
    puts "The highest seat id is #{seat_id}"
  end

  ##
  # @params input [String] file name
  # @return [AOC5]
  def initialize(input)
    @input = input
  end

  ##
  # @return [Integer]
  def highest_seat_id
    seats_data
      .max { |seat1, seat2| seat1[:seat_id] <=> seat2[:seat_id] }
      .fetch(:seat_id)
  end

  ##
  # @return [Array<Hash>]
  def seats_data
    parser = PassParser.new

    File.open(@input)
        .each_line
        .map { |pass| parser.parse(pass.chomp) }
  end
end
