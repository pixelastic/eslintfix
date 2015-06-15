require 'json'
require 'fileutils'
require 'shellwords'

# Try to automatically fix eslint errors of Javascript files
# Dependencies:
# - jscs
# - to-single-quotes / to-double-quotes
class EslintFix
  attr_reader :file
  attr_accessor :config

  def initialize(*args)
    unless args.size > 0
      puts 'Usage:'
      puts '$ eslintfix ./input.js'
      exit 1
    end

    # Input file
    input = File.expand_path(args[0])
    fail ArgumentError, "#{input} does not exist" unless File.exist?(input)
    @file = input

    # Eslintrc config file
    cli_options = Hash[args.join(' ').scan(/--?([^=\s]+)(?:=(\S+))?/)]
    if cli_options['config']
      eslintrc = cli_options['config']
    else
      eslintrc = get_eslintrc(input) unless eslintrc
    end
    fail ArgumentError, "#{input} does not exist" unless File.exist?(eslintrc)
    @config = get_eslint_config(eslintrc)
  end

  def get_eslintrc(file)
    dirname = File.dirname(file)
    return false if dirname == file

    eslintrc = File.expand_path(File.join(dirname, '.eslintrc'))
    return eslintrc if File.exist?(eslintrc)

    get_eslintrc(dirname)
  end

  def get_eslint_config(eslintrc)
    known_config = [
      'no-trailing-spaces',
      'space-in-parens',
      'quotes'
    ]
    rules = JSON.parse(File.open(eslintrc).read)['rules']
    config = {}
    rules.each do |rule, value|
      next unless known_config.include?(rule)
      config[rule.to_sym] = value
    end
    config
  end

  def fix
    jscs_config = {}
    content = File.open(@file).read.chomp

    # Trailing spaces
    if @config.key?(:'no-trailing-spaces')
      content = fix_no_trailing_spaces(content)
    end

    # Quotes
    if @config.key?(:quotes)
      content = fix_quotes(content, @config[:quotes])
    end

    # Spaces in parens
    if @config.key?(:'space-in-parens')
      space_in_parens = @config[:'space-in-parens']
      if space_in_parens
        jscs_config[:requireSpacesInsideParentheses] = { 'all': true }
      else
        jscs_config[:disallowSpacesInsideParentheses] = { 'all': true }
      end
    end

    # Execute jscs if need be
    content = fix_jscs(content, jscs_config) if jscs_config.size > 0

    content.chomp + "\n"
  end

  def fix_no_trailing_spaces(content)
    content.each_line.map(&:rstrip).join("\n") + "\n"
  end

  def fix_quotes(content, quotes)
    quotes = quotes[1] if quotes.is_a? Array
    converter = nil
    converter = 'to-double-quotes' if quotes == 'double'
    converter = 'to-single-quotes' if quotes == 'single'
    return content unless converter
    `#{converter} #{content.shellescape}`
  end

  def fix_jscs(content, config)
    tmp_dir = '/tmp/eslintfix'
    FileUtils.mkdir_p(tmp_dir)

    # Write custom config to a tmp file
    tmp_config = File.join(tmp_dir, 'jscs_config.json')
    File.open(tmp_config, 'w') do |file|
      file.write(JSON.generate(config))
    end

    # Write input content to disk as jscs modifies the file in place
    tmp_file = File.join(tmp_dir, 'input.js')
    File.open(tmp_file, 'w') do |file|
      file.write(content)
    end

    # Execute jscs on it and return changed content
    `jscs --config #{tmp_config} --fix #{tmp_file}`
    File.open(tmp_file).read
  end

  #   "requireSpaceBeforeBlockStatements": true,
  #     "requireSpaceAfterObjectKeys": true
  #
  # Accepter avec --config le fichier eslintrc
  # Sinon prendre celui qui est présent
  #
  # Output dans le terminal le résultat

  def run
    puts fix
  end
end
