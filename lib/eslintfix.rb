# Try to automatically fix eslint errors of Javascript files
class EslintFix
  attr_reader :file
  attr_accessor :config

  def initialize(*args)
    input = File.expand_path(args[0])
    if !File.exist?(input)
      puts "#{input} does not exist"
      exit 1
    end

    @file = input
    @content = File.open(@file).read

    @config = {}
  end

  def add_config(type, value)
    @config[type] = value
  end

  def fix
    fix_no_trailing_spaces if @config['no-trailing-spaces']
    @content
  end

  def fix_no_trailing_spaces
    @content = @content.each_line.map(&:rstrip).join("\n") + "\n"
  end

  # load_config qui prends un fichier eslintrc
  # et qui récupère la config qui nous intéresse
  # seulement certains clés sont utiles, donc on ne garde que celles-ci
  #
  # une méthode pour convertir les clés intéressantes d'eslintrc vers une config
  # jscs
  #
  # une transformation en sed pour enlever les trailing whitespaces
  # 
  # une méthode pour executer jscs sur un fichier
  # 
  # des tests finaux sur des fichiers inputs/outputs pour vérifier que tout
  # marche normalement

  def run
  end
end
