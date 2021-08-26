# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/pass_parser'

describe PassParser do
  let(:parser) { PassParser.new }

  describe 'full parser' do
    it 'identifies row, column, and seat id' do
      result = parser.parse('BBFFBBFRLL')

      _(result).must_equal(row: 102, column: 4, seat_id: 820)
    end

    it 'fails when input has the wrong size' do
      error = _ { parser.parse('FBFBAFF') }.must_raise PassParser::InvalidPassSizeError

      _(error.message).must_equal "Boarding pass code should be 10 characters long but it's only 7"
    end

    it 'fails when row section is invalid' do
      error = _ { parser.parse('FBFBAFFLLL') }.must_raise PassParser::InvalidCharacterError

      _(error.message).must_equal "Character 'A' should be either 'F' or 'B'"
    end

    it 'fails when column section is invalid' do
      error = _ { parser.parse('FBFBBFFLGR') }.must_raise PassParser::InvalidCharacterError

      _(error.message).must_equal "Character 'G' should be either 'L' or 'R'"
    end
  end

  describe 'rows parser' do
    it 'parses first row' do
      result = parser.parse_row('FFFFFFF')

      _(result).must_equal 0
    end

    it 'parses last row' do
      result = parser.parse_row('BBBBBBB')

      _(result).must_equal 127
    end

    it 'parses row 44' do
      result = parser.parse_row('FBFBBFF')

      _(result).must_equal 44
    end

    it 'fails when input is invalid' do
      error = _ { parser.parse_row('FBFBAFF') }.must_raise PassParser::InvalidCharacterError

      _(error.message).must_equal "Character 'A' should be either 'F' or 'B'"
    end
  end

  describe 'columns parsers' do
    it 'parsesd first column' do
      result = parser.parse_col('LLL')

      _(result).must_equal 0
    end

    it 'parses last column' do
      result = parser.parse_col('RRR')

      _(result).must_equal 7
    end

    it 'parses column 5' do
      result = parser.parse_col('RLR')

      _(result).must_equal 5
    end

    it 'fails when input is invalid' do
      error = _ { parser.parse_col('RLG') }.must_raise PassParser::InvalidCharacterError

      _(error.message).must_equal "Character 'G' should be either 'L' or 'R'"
    end
  end
end
