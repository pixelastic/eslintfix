require 'json'
require 'fileutils'
require 'shellwords'
require 'awesome_print'

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
      'indent',
      'key-spacing',
      'no-multi-spaces',
      'no-trailing-spaces',
      'quotes',
      'space-before-blocks',
      'space-in-parens'
    ]
    rules = JSON.parse(File.open(eslintrc).read)['rules']
    rules.select! { |rule| known_config.include?(rule) }
  end

  def fix
    jscs_config = {}
    content = File.open(@file).read.chomp

    # Trailing spaces
    if @config.key?('no-trailing-spaces')
      content = fix_no_trailing_spaces(content)
    end

    # Quotes
    if @config.key?('quotes')
      content = fix_quotes(content, @config['quotes'])
    end

    # Spaces in parens
    if @config.key?('space-in-parens')
      jscs_config = get_jscs_conf_space_in_parens(jscs_config)
    end

    # Spaces before block
    if @config.key?('space-before-blocks')
      jscs_config = get_jscs_conf_space_before_blocks(jscs_config)
    end

    # Key spacing
    if @config.key?('key-spacing')
      jscs_config = get_jscs_conf_key_spacing(jscs_config)
    end

    # Indent
    if @config.key?('indent')
      jscs_config = get_jscs_conf_indent(jscs_config)
    end

    # Multi spaces
    if @config.key?('no-multi-spaces') && @config['no-multi-spaces']
      jscs_config[:disallowMultipleSpaces] = true
    end

    # Execute jscs if need be
    content = fix_jscs(content, jscs_config) if jscs_config.size > 0

    content.chomp + "\n"
  end

  def get_jscs_conf_space_in_parens(jscs_config)
    space_in_parens = @config['space-in-parens']
    if space_in_parens
      jscs_config[:requireSpacesInsideParentheses] = { 'all': true }
    else
      jscs_config[:disallowSpacesInsideParentheses] = { 'all': true }
    end
    jscs_config
  end

  def get_jscs_conf_space_before_blocks(jscs_config)
    space_before_blocks = @config['space-before-blocks']
    if space_before_blocks
      jscs_config[:requireSpaceBeforeBlockStatements] = true
    else
      jscs_config[:disallowSpaceBeforeBlockStatements] = true
    end
    jscs_config
  end

  def get_jscs_conf_key_spacing(jscs_config)
    key_spacing = @config['key-spacing'][1]

    if key_spacing.key?('beforeColon')
      if key_spacing['beforeColon']
        jscs_config[:requireSpaceAfterObjectKeys] = true
      else
        jscs_config[:disallowSpaceAfterObjectKeys] = true
      end
    end

    if key_spacing.key?('afterColon')
      if key_spacing['afterColon']
        jscs_config[:requireSpaceBeforeObjectValues] = true
      else
        jscs_config[:disallowSpaceBeforeObjectValues] = true
      end
    end

    jscs_config
  end

  def get_jscs_conf_indent(jscs_config)
    # http://eslint.org/docs/rules/indent
    # http://jscs.info/rule/validateIndentation.html
    indent = @config['indent']
    indent_value = nil

    # Default eslint indentation is 4 spaces
    indent_value = 4 if indent.is_a? Integer

    if indent.is_a? Array
      indent_value = indent[1]
      indent_value = "\t" if indent_value == 'tab'
    end

    jscs_config[:validateIndentation] = indent_value

    jscs_config
  end

  def fix_no_trailing_spaces(content)
    content.each_line.map { |line| line.chomp.rstrip }.join("\n") + "\n"
  end

  def fix_quotes(content, quotes)
    quotes = quotes[1] if quotes.is_a? Array
    converter = nil
    converter = 'to-double-quotes' if quotes == 'double'
    converter = 'to-single-quotes' if quotes == 'single'
    return content unless converter
    `echo #{content.shellescape} | #{converter}`.strip + "\n"
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

  def run
    puts fix
  end
end
