# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../aoc5'

describe AOC5 do
  let(:filename) { 'specs/fixtures/sample_input.txt' }
  let(:subject) { AOC5.new(filename) }

  it 'converts each boarding pass in its row, column, and seat id info' do
    _(subject.seats_data).must_equal [
      { row: 70, column: 7, seat_id: 567 },
      { row: 14, column: 7, seat_id: 119 },
      { row: 102, column: 4, seat_id: 820 }
    ]
  end

  it 'finds the highest seat id' do
    _(subject.highest_seat_id).must_equal 820
  end

  it 'prints a message with the answer' do
    _ { AOC5.run_first_step(filename) }.must_output "The highest seat id is 820\n"
  end
end
