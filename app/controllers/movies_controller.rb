class MoviesController < ApplicationController
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
   
    @all_ratings = Movie.get_ratings_collection
    
    if(params[:ratings] != nil) # Filters movies based on :ratings given
      @movies = Movie.where(:rating => params[:ratings].keys)
      session[:ratings] = params[:ratings]
      @default_checked_ratings = session[:ratings].keys
      
    elsif(session[:ratings] != nil) # Filters movies based on :ratings from a session
      @movies = Movie.where(:rating => session[:ratings].keys)
      @default_checked_ratings = session[:ratings].keys
      redirect_needed = true
      
    else # displays all movies with all ratings
      @movies = Movie.all
      @default_checked_ratings = @all_ratings
      
    end
    
    if(params[:sort] == 'movie.title') #Sorts movies based on title
      @movies = @movies.order(:title)
      session[:sort] = params[:sort]
      
    elsif(params[:sort] == 'movie.release_date') #Sorts movies based on release date
      @movies = @movies.order(:release_date)
      session[:sort] = params[:sort]
      
    elsif(session[:sort] == 'movie.title')  #Sorts movies based on title from session
      @movies = @movies.order(:title)
      redirect_needed = true
      
    elsif(session[:sort] == 'movie.release_date')  #Sorts movies based on release date from session
      @movies = @movies.order(:release_date)
      redirect_needed = true
      
    end
    
    
    # Does a redirect only when using params from a session, keeps url intact 
    if(redirect_needed)
      redirect_to(movies_path(:ratings => session[:ratings], :sort => session[:sort]))
    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
