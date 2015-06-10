require 'json'

# Try to automatically fix eslint errors of Javascript files
class EslintFix
  attr_reader :file
  attr_accessor :config

  def initialize(*args)
    input = File.expand_path(args[0])
    fail ArgumentError, "#{input} does not exist" unless File.exist?(input)

    @file = input
    @content = File.open(@file).read

    @config = {}
    @config_jscs = {}
  end

  def add_config(type, value)
    @config[type] = value
  end

  def add_jscs_config(type, value)
    @config_jscs[type] = value
  end

  def fix
    fix_no_trailing_spaces if @config['no-trailing-spaces']

    if @config['space-in-parens'] == true
      add_jscs_config('requireSpacesInsideParentheses', 'all': true)
    end

    # Execute jscs if need be
    fix_jscs if @config_jscs.size > 0

    @content
  end

  def fix_no_trailing_spaces
    @content = @content.each_line.map(&:rstrip).join("\n") + "\n"
  end

  def fix_jscs
    # Write custom config to a tmp file
    tmp_dir = '/tmp/eslintfix'
    tmp_config = File.join(tmp_dir, 'jscs_config.json')
    FileUtils.mkdir_p(tmp_dir)
    File.open(tmp_config, 'w') do |file|
      file.write(JSON.generate(@config_jscs))
    end

    # Copy file to tmp dir as jscs modifies the file in place
    tmp_file = File.join(tmp_dir, File.basename(@file))
    FileUtils.cp(@file, tmp_file)

    # Execute jscs on it and return changed content
    `jscs --config #{tmp_config} --fix #{tmp_file}`
    @content = File.open(tmp_file).read
  end

  #   "requireSpaceBeforeBlockStatements": true,
  #     "requireSpaceAfterObjectKeys": true
  #
  # Accepter avec --config le fichier eslintrc
  # Sinon prendre celui qui est présent
  #
  # Output dans le terminal le résultat

  def run
  end
end
