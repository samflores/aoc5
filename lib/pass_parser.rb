# frozen_string_literal: true

##
# This class is responsible for converting boarding pass codes into the row, column and seat id
class PassParser
  class InvalidCharacterError < StandardError; end

  class InvalidPassSizeError < StandardError; end

  ROW_CHARS_SIZE = 7
  COL_CHARS_SIZE = 3

  PLANE_ROWS = (2**ROW_CHARS_SIZE) - 1
  PLANE_COLS = (2**COL_CHARS_SIZE) - 1

  ##
  # This is the class main entry point. A boarding pass must have the format
  # RRRRRRRCCC, where the R portion identifies the row where the seat is
  # located and the C portion identifies the column. In an actual pass each
  # character in the row portion can be either 'F' ou 'B', and the column
  # portion can be either 'L' or 'R'.
  #
  # @param pass [String]
  # @return [Hash] a hash containing the `:row`, `:column`, and `:seat_id` keys
  # @raise [InvalidPassSizeError] if the boarding pass has the wrong size
  # @raise [InvalidCharacterError] if the boarding pass contains an invalid character
  def parse(pass)
    ensure_valid_pass_size!(pass)

    row = parse_row(pass[0, ROW_CHARS_SIZE])
    col = parse_col(pass[ROW_CHARS_SIZE, COL_CHARS_SIZE])

    {
      row: row,
      column: col,
      seat_id: row * (ROW_CHARS_SIZE + 1) + col
    }
  end

  ##
  # @private
  def parse_row(str)
    parse_sequence(input: str, lower_ch: 'F', upper_ch: 'B')
  end

  ##
  # @private
  def parse_col(str)
    parse_sequence(input: str, lower_ch: 'L', upper_ch: 'R')
  end

  private

  ##
  # Recursively goes over the `input` boarding pass string, splitting the
  # plane seat space in the appropriate half according to the current char
  # being equal to the `lower_ch` or the `upper_ch`
  #
  # @param input [String] an slice of the boarding pass starting from the
  #   current char being evaluated.
  # @param lower_char [String] one characters string used to define which char
  #   will take the lower half of the current seat space section.
  # @param upper_char [String] one characters string used to define which char
  #   will take the upper half of the current seat space section.
  # @param start [Integer] the index from the complete seat space where the
  #   section being evaluated starts
  # @param finish [Integer] the index from the complete seat space where the
  #   section being evaluated ends
  # @raise [InvalidCharacterError]
  def parse_sequence(
    input:,
    lower_ch:, upper_ch:,
    start: 0, finish: (2**input.size) - 1
  )
    ensure_valid_char!(input[0], lower_ch, upper_ch)

    lower = lower_ch == input[0]
    return(lower ? start : finish) if input.size == 1

    mid_point = start + (finish - start) / 2
    start, finish = lower ? [start, mid_point] : [mid_point + 1, finish]

    parse_sequence(
      input: input[1..-1],
      start: start, finish: finish,
      lower_ch: lower_ch, upper_ch: upper_ch
    )
  end

  ##
  # Raises an exception if the character is not valid
  #
  # @param char [String] the character being checked
  # @param valid_chars [Array<String>] A list of the valid chars
  # @raise [InvalidCharacterError]
  def ensure_valid_char!(char, *valid_chars)
    return if valid_chars.include?(char)

    valid_chars_list = valid_chars.map { |ch| "'#{ch}'" }.join(' or ')
    raise InvalidCharacterError, "Character '#{char}' should be either #{valid_chars_list}"
  end

  ##
  # Raises an exception if the boarding pass is not the right size
  #
  # @param pass [String] the boarding pass
  # @raise [InvalidPassSizeError]
  def ensure_valid_pass_size!(pass)
    return if pass.size == ROW_CHARS_SIZE + COL_CHARS_SIZE

    raise InvalidPassSizeError,
          "Boarding pass code should be #{ROW_CHARS_SIZE + COL_CHARS_SIZE} " \
          "characters long but it's only #{pass.size}"
  end
end
