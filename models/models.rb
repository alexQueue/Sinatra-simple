require 'data_mapper'
require 'digest/md5'


class User
  include DataMapper::Resource
  property :id,         Serial
  property :name,       Text
  property :name_lower, Text #, :format => /^\s$/
  property :password,   String, :length => 64
  property :salt,       Text #, :default => lambda {|r, p| Time.now }
  property :timestamp,  DateTime, :default => lambda {|r, p| Time.now }

  validates_with_method :downcase_name

  validates_uniqueness_of :name_lower, :message => 'Username is already taken'

  def downcase_name
    self.name_lower = self.name.downcase
  end

  def raw_password=(raw_pass_string)
    new_salt = SecureRandom.hex(8)
    self.salt = new_salt
    self.password = auth_hash(raw_pass_string)
  end

  def admin?
    self.id == 1
  end

  def self.search(query)
    query = query.downcase
    p 'Searching users for ' + query
    User.all(:name_lower.like => "%#{query}%")
  end

  def verify_pass(possible_password)
    password == auth_hash(possible_password)
  end

  private
    def auth_hash(password)
      bonus_salt = "6ae26361064bca05"
      Digest::SHA2.hexdigest(salt + password + bonus_salt).to_s
    end

end

## Initialization
db_url = "postgres://localhost/local_db"

DataMapper.setup(:default, ENV['DATABASE_URL'] || db_url)
DataMapper.finalize
if development?
  DataMapper.auto_migrate!
else
  DataMapper.auto_upgrade!
end

puts "db set up on " + (ENV['DATABASE_URL'] || db_url)

User.create(:name => 'a', raw_password: 'q')
