class TitleBracketsValidator < ActiveModel::Validator
  BRACKETS =
    {
      '(': ")",
      '{': "}",
      '[': "]"
    }.stringify_keys!

  def validate(record)
    @record = record
    @title = @record.title.split("")
    @stack = []

    check_validity

    add_error("bracket not closed") unless @stack.empty?
  end

  private

  def check_validity
    @title.each_with_index do |char, index|
      next_char = @title[index + 1]
      break if has_empty_brackets?(char, next_char)

      @stack.push(char) if opening_bracket?(char)
      add_error("wrong bracket order") if wrong_bracket_order?(char)
    end
  end

  def has_empty_brackets?(char, next_char)
    if next_char.present? && next_char == closing_bracket_for(char)
      add_error("empty brackets")
      true
    end
  end

  def wrong_bracket_order?(char)
    closing_bracket?(char) && opening_bracket_for(char) != remove_last_opening_bracket
  end

  def opening_bracket_for(char)
    return unless BRACKETS.has_value?(char)

    BRACKETS.key(char)
  end

  def closing_bracket_for(char)
    return unless BRACKETS.key?(char)

    BRACKETS[char]
  end

  def opening_bracket?(char)
    BRACKETS.key?(char)
  end

  def closing_bracket?(char)
    BRACKETS.has_value?(char)
  end

  def remove_last_opening_bracket
    @stack.pop
  end

  def add_error(message)
    @record.errors.add(:base, message)
  end
end
