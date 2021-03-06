I18n.load_path << File.join(File.dirname(__FILE__), 'files/locales.yml')

ActiveRecord::Base.send(:include, ActiveFlag)

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Base.connection.create_table :profiles, force: true do |t|
  t.integer :languages, null: false, default: 0
  t.integer :figures
  t.integer :customs
end

class Profile < ActiveRecord::Base
  flag :languages, [:english, :spanish, :chinese, :french, :japanese]
  flag :others, [:thing]
  flag :figures, [:square, false, :circle, nil, :triangle]
  flag :customs, { one: 1, four: 4, three: 3 }
end

class SubProfile < Profile
end

class Other < ActiveRecord::Base
  flag :others, [:another]
end

Profile.create(languages: [:english])
Profile.create(languages: [:japanese])
Profile.create(languages: [:english, :japanese])
