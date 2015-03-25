require 'active_triples/elasticsearch/version'
require 'active_support/concern'
require 'elasticsearch/model'
require 'elasticsearch/model/callbacks'

module ActiveTriples
  module Elasticsearch
    extend ActiveSupport::Concern

    autoload :Background, 'active_triples/elasticsearch/background'
    autoload :Resource,   'active_triples/elasticsearch/resource'

    included do
      include Elasticsearch::Model

      if ancestors.include? ActiveTriples::Elasticsearch::Background
        include ActiveTriples::Elasticsearch::Resource
      else
        include Elasticsearch::Model::Callbacks
      end
    end
  end
end
