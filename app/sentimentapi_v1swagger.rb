require 'rubygems'
require 'grape'
require 'json'
require "#{File.dirname(__FILE__)}/analyzer"

class SentimentApiV1 < Grape::API
  version 'v1', :using => :path, :vendor => '3scale'
  error_format :json

  @@the_logic = Analyzer.new

  ##~ sapi = source2swagger.namespace("sentiment_api_v2.1")
  ##~ sapi.basePath = "http://sentiment-forrester.3scale.net"
  ##~ sapi.apiVersion = "v1"
  ##
  ## -- Parameters
  ##~ @par_app_id = {:name => "app_id", :description => "Your access application id", :dataType => "string", :paramType => "query", :threescale_name => "app_ids"}
  ##~ @par_app_key = {:name => "app_key", :description => "Your access application key", :dataType => "string", :paramType => "query", :threescale_name => "app_keys"}
  ##
  ##~ a = sapi.apis.add
  ##~ a.set :path => "/v1/words/{word}.json"
  ##~ op = a.operations.add
  ##~ op.set :httpMethod => "GET"
  ##~ op.summary = "Returns the sentiment value of a given word"
  ##~ op.description = "<p>This operation returns the sentiment value on a scale from -5 to +5 of the given word.<p>For instance, the word \"awesome\" returns {\"word\":\"awesome\",\"sentiment\":4} with a positive connotation whereas \"damnit\" is less positive {\"word\":\"damnit\",\"sentiment\":-4}"
  ##~ op.group = "words"
  ##~ op.parameters.add :name => "word", :description => "The word whose sentiment is returned", :dataType => "string", :required => true, :paramType => "path"
  ##~ op.parameters.add @par_app_id
  ##~ op.parameters.add @par_app_key
  ##

  resource :words do
    get ':word' do
      #{:word => params[:word], :sentiment => "unkown"}.to_json
      @@the_logic.word(params[:word]).to_json
    end

    ##~ op = a.operations.add
    ##~ op.set :httpMethod => "POST"
    ##~ op.summary = "Sets the sentiment value of a given word"
    ##~ op.description = "<p>This operation allows you to set the sentiment value to a word.<p>The sentiment value needs to be on the range -5 to +5."
    ##~ op.group = "words"
    ##~ op.parameters.add :name => "word", :description => "The word whose sentiment is returned", :dataType => "string", :required => true, :paramType => "path"
    ##~ op.parameters.add :name => "value", :description => "The sentiment value of the word, must be -5 to -1 for negative or to +1 to +5 for positive connotations", :allowableValues => {:values => ["-5","-4","-3","-2","-1","1","2","3","4","5"], :valueType => "LIST"}, :dataType => "string", :required => true, :defaultValue => "1", :paramType => "query"
    ##~ op.parameters.add @par_app_id
    ##~ op.parameters.add @par_app_key
    ##

    post ':word' do
      #{:word => params[:word], :result => "thinking"}.to_json
      res =  @@the_logic.add_word(params[:word],params[:value])
      res.to_json
    end
  end

  ##~ a = sapi.apis.add
  ##~ a.set :path => "/v1/sentences/{sentence}.json"
  ##~ op = a.operations.add
  ##~ op.set :httpMethod => "GET"
  ##~ op.summary = "Returns the aggregated sentiment of a sentence"
  ##~ op.description = "<p>This operation returns the aggregated value of a sentence based on the individual sentiment values of the words of the sentence.<p>The result for \"3scale rocks\" would be {\"sentence\":\"3scale rocks\",\"count\":2,\"certainty\":0.5,\"sentiment\":4.0}, overall sentiment of 4 in a -5 to +5 scale with certainty of 50% because only one word had a defined sentiment value."
  ##~ op.group = "sentence"
  ##~ op.parameters.add :name => "sentence", :description => "The sentence to be analyzed", :dataType => "string", :required => true, :paramType => "path"
  ##~ op.parameters.add @par_app_id
  ##~ op.parameters.add @par_app_key
  ##

  resource :sentences do
    get ':sentence' do
      #{:sentence => params[:sentence], :result => "unkown"}.to_json
      @@the_logic.sentence(params[:sentence]).to_json
    end
  end

end
