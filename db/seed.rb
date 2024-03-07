require 'sqlite3'

def db
    if @db == nil
        @db = SQLite3::Database.new('./db/db.sqlite')
        @db.results_as_hash = true
    end
    return @db
end

def drop_tables
    db.execute('DROP TABLE IF EXISTS Contacts')
end

def create_tables

    db.execute('CREATE TABLE "Contacts" (
        "id"	INTEGER,
        "Name"	TEXT,
        "Number"	TEXT,
        PRIMARY KEY("id" AUTOINCREMENT)')

end

def seed_tables

    Contacts = [
        {Name: 'Pear', Number: 'a sweet, juicy, yellow or green fruit with a round base and slightly pointed top'},
        {Name: 'Apple', Number: 'a round, edible fruit having a red, green, or yellow skin'},
        {Name: 'Banana', Number: 'a long, curved fruit with a usually yellow skin and soft, sweet flesh inside'},
        {Name: 'Orange', Number: 'a round, orange-colored fruit that is valued mainly for its sweet juice'}
    ]

    Contacts.each do |contact|
        db.execute('INSERT INTO Contacts (Name, Number) VALUES (?,?)', contact[:Name], contact[:Number])
    end

end

drop_tables
create_tables
seed_tables