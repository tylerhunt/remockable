RSpec::Matchers.define(:validate_length_of) do |attribute, options|
  @attribute = attribute
  @options = options || {}

  match do |actual|
    valid_message = if @options[:too_long]
      too_long = validator.options[:too_long] || validator.options[:message]
      @options[:too_long] == too_long
    elsif @options[:too_short]
      too_short = validator.options[:too_short] || validator.options[:message]
      @options[:too_short] == too_short
    elsif @options[:message]
      too_long = validator.options[:too_long] || validator.options[:message]
      too_short = validator.options[:too_short] || validator.options[:message]

      @options[:message] == too_long && @options[:message] == too_short
    else
      true
    end

    valid_tokenizer = if @options[:token] && @options[:separator]
      token_count = @options[:is] || @options[:maximum]
      string = ([@options[:token]] * token_count).join(@options[:separator])
      validator.options[:tokenizer].call(string).length == token_count
    else
      true
    end

    valid_options = if validator
      message_keys = [:message, :too_long, :too_short]
      validator_keys = message_keys + [:tokenizer]
      matcher_keys = message_keys + [:token, :separator]

      validator_options = validator.options.except(*validator_keys)
      matcher_options = @options.except(*matcher_keys)

      common_keys = validator_options.keys & matcher_options.keys
      validator_options.values_at(*common_keys) == matcher_options.values_at(*common_keys)
    end

    validator && valid_message && valid_tokenizer && valid_options
  end

  def allow_blank(value=true)
    @options[:allow_blank] = value
    self
  end

  def allow_nil(value=true)
    @options[:allow_nil] = value
    self
  end

  def is(value)
    @options[:is] = value
    self
  end

  def maximum(value)
    @options[:maximum] = value
    self
  end

  def message(value)
    @options[:message] = value
    self
  end

  def minimum(value)
    @options[:minimum] = value
    self
  end

  def separator(value)
    @options[:separator] = value
    self
  end

  def token(value)
    @options[:token] = value
    self
  end

  def too_long(value)
    @options[:too_long] = value
    self
  end

  def too_short(value)
    @options[:too_short] = value
    self
  end

  def within(value)
    minimum(value.try(:first))
    maximum(value.try(:last))
    self
  end
  alias in within

  def wrong_length(value)
    @options[:wrong_length] = value
    self
  end

  def validator
    @validator ||= subject.class.validators_on(@attribute).detect do |validator|
      validator.kind == :length
    end
  end

  def failure_description
    be_invalid_when = "be invalid when #{@attribute} length is %s characters"
    be_valid_when = "be valid when #{@attribute} length is %s characters"
    allow = "allow %s values for #{@attribute}"

    message = if @options[:minimum] && @options[:minimum] != validator.options[:minimum]
      if @options[:minimum] > validator.options[:minimum]
        be_invalid_when % "less than #{@options[:minimum]}"
      elsif @options[:minimum] == validator.options[:minimum] - 1
        # TODO: remove this once done testing against remarkable's specs
        send(:less_than_min_length?) if respond_to?(:less_than_min_length?)

        be_valid_when % "#{@options[:minimum]}"
      end
    elsif @options[:maximum] && @options[:maximum] != validator.options[:maximum]
      if @options[:maximum] < validator.options[:maximum]
        be_invalid_when % "more than #{@options[:maximum]}"
      elsif @options[:maximum] == validator.options[:maximum] + 1
        # TODO: remove this once done testing against remarkable's specs
        send(:more_than_max_length?) if respond_to?(:more_than_max_length?)

        be_valid_when % "#{@options[:maximum]}"
      end
    elsif @options[:allow_blank] != validator.options[:allow_blank]
      if @options[:allow_blank]
        allow % 'blank'
      end
    elsif @options[:allow_nil] != validator.options[:allow_nil]
      if @options[:allow_nil]
        allow % 'nil'
      end
    end

    message || description
  end

  failure_message_for_should do |actual|
    "Expected #{subject.class.name} to #{failure_description}"
  end

  failure_message_for_should_not do |actual|
    "Did not expect #{subject.class.name} to #{failure_description}"
  end

  description do
    length = if is = @options[:is]
      "equal to #{is}"
    elsif @options[:maximum] && @options[:minimum]
      "within #{@options[:minimum]}..#{@options[:maximum]}"
    elsif @options[:maximum]
      "maximum #{@options[:maximum]}"
    elsif @options[:minimum]
      "minimum #{@options[:minimum]}"
    end

    parts = ["ensure length of #{@attribute} is #{length} characters"]
    parts << "not allowing nil values" if @options[:allow_nil] === false
    parts << "allowing blank values" if @options[:allow_blank]

    parts.to_sentence
  end

  within(@options.delete(:in)) if @options[:in]
  within(@options.delete(:within)) if @options[:within]
end
