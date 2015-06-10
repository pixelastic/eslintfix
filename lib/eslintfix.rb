# Try to automatically fix eslint errors of Javascript files
class EslintFix
  attr_reader :files

  def initialize(*args)
    add_files(args)
  end

  def add_files(files)
    @files = files
             .reject { |file| !File.exist?(file) }
             .map { |file| File.expand_path(file) }
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
