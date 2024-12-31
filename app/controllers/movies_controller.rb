class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]

    ALLOWED_COLUMNS = %w[title release_date rating]
    ALLOWED_DIRECTIONS = %w[asc desc]
  
    def index
      # Retrieve or set default sorting parameters
      sort_by = validate_column(params[:column]) || session[:sort_by] || 'title'
      direction = validate_direction(params[:column] ? toggle_direction(sort_by) : session[:direction]) || 'asc'
  
      # Update session if sorting parameters are passed
      if params[:column].present?
        session[:sort_by] = sort_by
        session[:direction] = direction
      end
  
      # Fetch movies sorted according to validated values
      @movies = Movie.order(sort_by => direction)
  
      # Pass the current sort and direction to the view
      @sort_by = sort_by
      @direction = direction
    end
  

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: "Movie was successfully updated." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy!

    respond_to do |format|
      format.html { redirect_to movies_path, status: :see_other, notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.expect(movie: [ :title, :rating, :description, :release_date ])
    end

    def validate_column(column)
      ALLOWED_COLUMNS.include?(column) ? column : nil
    end
  
    def validate_direction(direction)
      ALLOWED_DIRECTIONS.include?(direction) ? direction : nil
    end
  
    def toggle_direction(current_column)
      session[:sort_by] == current_column && session[:direction] == 'asc' ? 'desc' : 'asc'
    end
end
