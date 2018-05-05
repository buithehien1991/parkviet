namespace :export do
  task :seeds_format => :environment do

    directory = "/Users/hienbt/Desktop/"
    File.open(File.join(directory, 'seed.rb'), 'w') do |f|
      Province.order(:id).all.each do |country|
        f.puts "Province.create(#{country.serializable_hash.delete_if {|key, value| ['created_at','updated_at','id'].include?(key)}.to_s.gsub(/[{}]/,'')})"
      end

      District.order(:id).all.each do |country|
        f.puts "District.create(#{country.serializable_hash.delete_if {|key, value| ['created_at','updated_at','id'].include?(key)}.to_s.gsub(/[{}]/,'')})"
      end

      Commune.order(:id).all.each do |country|
        f.puts "Commune.create(#{country.serializable_hash.delete_if {|key, value| ['created_at','updated_at','id'].include?(key)}.to_s.gsub(/[{}]/,'')})"
      end
    end
  end
end