require 'sinatra/base'
require 'sinatra/flash'
require_relative 'lib/wordguesser_game'

class WordGuesserApp < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  set :host_authorization, { permitted_hosts: [] }  

  before do
    @game = session[:game] || WordGuesserGame.new('')
  end

  after do
    session[:game] = @game
  end

  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end

  get '/new' do
    erb :new
  end

  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || WordGuesserGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = WordGuesserGame.new(word)
    redirect '/show'
  end

  post '/new/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = WordGuesserGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!
  
    @game = WordGuesserGame.new(word)
    redirect '/show'
  end
  

  post '/guess' do
    guess = params[:guess].to_s[0] 

    if !guess || guess.empty? || guess !~ /[a-zA-Z]/
      flash[:message] = "Invalid guess."
    elsif @game.guesses.include?(guess.downcase) || @game.wrong_guesses.include?(guess.downcase)
      flash[:message] = "You have already used that letter."
    else
      @game.guess(guess)
    end

    redirect '/show'
  end

  get '/show' do
    if @game.word_with_guesses == @game.word
      redirect '/win'
    elsif @game.wrong_guesses.length >= 7
      redirect '/lose'
    else
      erb :show
    end
  end

  get '/win' do
    erb :win
  end

  get '/lose' do
    erb :lose
  end
end
