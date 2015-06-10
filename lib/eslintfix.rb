# Try to automatically fix eslint errors of Javascript files
class EslintFix
  def initialize(*args)
    add_files(args)
  end

  def add_files(files)
    @files = files
             .reject { |file| !File.exist?(file) }
             .map { |file| File.expand_path(file) }
  end

  def has
    'yes'
  end

  def run
    ap @files
  end
end
