class App < Sinatra::Base
    enable :sessions
    
    def db
        if @db == nil
            @db = SQLite3::Database.new('./db/db.sqlite')
            @db.results_as_hash = true
        end
        return @db
    end
    
    get '/' do
        session[:user_id] = 1 
        erb :index
    end
    
    get '/cakes' do
        #@user_id = session[:user_id] 
        @cakes = db.execute('SELECT * FROM Cakes')
        erb :'cakes/index'
        #SELECT AVG(rating) AS average_rating, * FROM Cakes JOIN Ratings ON Ratings.cake_id = Cakes.id WHERE Cakes.id = 1
    end

    get '/cakes/:id' do |id|
        @cake = db.execute('SELECT * FROM Cakes WHERE id = ?', id).first
        @average_rating = db.execute('SELECT AVG(rating) AS average_rating, * FROM Cakes JOIN Ratings ON Ratings.cake_id = Cakes.id WHERE Cakes.id = ?', id).first
        @reviews = db.execute('SELECT Review FROM Ratings WHERE cake_id = ?', id).map { |row| row['Review'] }
        @ingredients = db.execute('SELECT Ingredients FROM Cakes WHERE id = ?', id).first
        erb :'Cakes/show'
    end

    #get '/cakes/1' do
    #    @cakes = db.execute('SELECT AVG(rating) AS average_rating, * FROM Cakes JOIN Ratings ON Ratings.cake_id = Cakes.id WHERE Cakes.id = 1')
    #    erb :'index'
    #end


    post '/cakes' do
        if session[:user_id] == nil
            redirect "/cakes"
        end
        name = params['Name'] 
        description = params['Description']
        price = params['Price']
        ingredients = params['Ingredients']
        query = 'INSERT INTO Cakes(Name, Description, Price, Ingredients) VALUES (?,?,?,?) RETURNING id'
        db.execute(query, name, description, price, ingredients)
        redirect "/cakes" 
    end

    post '/cakes/:id/update' do |id| 
        if session[:user_id] == nil
            redirect "/cakes"
        end
        name = params['Name']
        description = params['Description']
        price = params['Price']
        db.execute('UPDATE Cakes SET Name = ?, Description = ?, Price = ? WHERE id = ?', name, description, price, id)
        redirect "/cakes"
    end

    post '/cakes/:id/delete' do |id| 
        if session[:user_id] == nil
            redirect "/cakes"
        end
        db.execute('DELETE FROM Cakes WHERE id = ?', id)
        redirect "/cakes"
    end

    post '/cakes/RegisterAdmin' do  
        if session[:user_id] == nil
            redirect "/cakes"
        end
        username = params['Username']
        cleartext_password = params['Password']
        hashed_password = BCrypt::Password.create(cleartext_password)
        query = 'INSERT INTO Admins(Username, Password) VALUES (?,?) RETURNING id'
        result = db.execute(query, username, hashed_password).first
        redirect "/cakes" 
    end

    post '/cakes/Login' do  
        username = params['Username']
        cleartext_password = params['Password']
        user = db.execute('SELECT * FROM Admins WHERE Username = ?', username).first
        password_from_db = BCrypt::Password.new(user['Password'])
        if password_from_db == cleartext_password
            session[:user_id] = 1
            else
            #resultat2    
        end
        redirect "/cakes" 
    end

    post '/cakes/Logout' do
        if session[:user_id] == nil
            redirect "/cakes"
        end
        session.destroy
        redirect "/cakes"
    end
    post '/cakes/UserLogin' do  
        username = params['Username']
        cleartext_password = params['Password']
        user = db.execute('SELECT * FROM Users WHERE Username = ?', username).first
        password_from_db = BCrypt::Password.new(user['Password'])
        if password_from_db == cleartext_password
            session[:user_id] = 2
            else
            #resultat2    
        end
        redirect "/cakes" 
    end
    
    post '/cakes/RegisterUser' do  
        username = params['Username']
        cleartext_password = params['Password']
        hashed_password = BCrypt::Password.create(cleartext_password)
        query = 'INSERT INTO Users(Username, Password) VALUES (?,?) RETURNING id'
        result = db.execute(query, username, hashed_password).first
        redirect "/cakes" 
    end

    post '/cakes/:id/SubmitRating' do |cake_id|
        if session[:user_id] == nil
            redirect "/cakes"
        end
        rating = params['Rating'] 
        review = params['Review']
        query = 'INSERT INTO Ratings(rating, review, cake_id) VALUES (?,?,?) RETURNING id'
        result = db.execute(query, rating, review, cake_id).first 
        redirect "/cakes" 
    end

    post '/show/:id/order' do |cake_id|
        if session[:user_id] == nil
            redirect "/cakes"
        end
        name = params['Username']
        @user_id = db.execute('SELECT id FROM Users WHERE Username = ?', name).first
        query = 'INSERT INTO cake_order()'

 
end
