require 'active_support/concern'
require 'active_model/callbacks'
require 'active_triples'

require 'elasticsearch/model'
require 'elasticsearch/model/callbacks'

module ActiveTriples
  module Elasticsearch
    extend ActiveSupport::Concern
    extend ActiveModel::Callbacks

    autoload :Background, 'active_triples/elasticsearch/background'
    autoload :Serializable, 'active_triples/elasticsearch/serializable'

    included do
      include ::Elasticsearch::Model
      include ::Elasticsearch::Model::Callbacks unless ancestors.include? ActiveTriples::Elasticsearch::Background
      include ActiveTriples::Elasticsearch::Serializable

      define_model_callbacks :destroy
    end

    ##
    # Serialize the object as JSON for indexing
    #
    # @see Elasticsearch::Model::Serializing#as_indexed_json
    #
    # @return [Hash] a serialized version of the object
    def as_indexed_json(*)
      respond_to?(:serialized_json) ? serialized_json : as_json(except: [:id, :_id])
    end

    module ClassMethods
      ##
      # Specify type of serialization to use for indexing;
      # if a block is provided, it is expected to return a Hash
      # that will be used in lieu of {#as_indexed_json} for
      # serializing the object in the index
      #
      # @return [void]
      def index_for_search(&block)
        define_method(:serialized_json, block) if block_given?
      end
    end
  end
end
