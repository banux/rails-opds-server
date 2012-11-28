namespace :opds do
  desc "TODO"
  task :recreate_cover => :environment do
  	Book.all.each do |book|
		puts book.id
        if !book.cover.nil? && File.exist?(Rails.root.to_s + "/public" + book.cover.to_s)
        	begin
  				puts "recreate " + book.cover.store_path
  				book.cover.recreate_versions!
  			rescue
  				next
  			end
  		end
	end
  end

end
