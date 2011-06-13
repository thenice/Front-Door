namespace :tokens do
  task :purge_expired => :environment do
    Token.purge_expired_tokens
    puts "Purge complete."
  end
end