class Dog
    attr_accessor :name,:breed,:id
    def intialize(name:,breed:,id: nil)
        @name = name
        @breed =breed
    end
    def self.create_table
        query=<<-SQL
            CREATE TABLE  dogs(
                id INTEGER PRIMARY KEY,
                name TEXT,
                breed TEXT
            )
        SQL
        DB[:conn].execute(query)
    end
    def self.drop_table
    query=<<-SQL
        DROP TABLE IF EXISTS dogs
    SQL
    DB[:conn].execute(query)
    end

#save
   def save
    query=<<-SQL
        INSERT INTO dogs(name,breed) VALUES(?, ?)
    SQL
    DB[:conn].execute(query,self.name,self.breed)
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end
    def self.create(name,breed)
        dog=Dog.new(name:name,breed:breed)
        dog.save
    end
    def self.new_from_db
        query=<<-SQL
            SELECT * FROM dogs ORDER BY id DESC LIMIT 1;
        SQL
        DB[:conn].execute(query)
    end
    def self.all
        query=<<-SQL
            SELECT * FROM dogs
        SQL
        DB[:conn].execute(query)
    end
    def self.find_by_name(name)
        self.all.find{
            |row|
            row.name == name
        }
    end
    
end
