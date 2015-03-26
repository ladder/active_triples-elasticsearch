require 'spec_helper'

describe ActiveTriples::Elasticsearch::Background do

  before do
    class Thing
      include ActiveTriples::RDFSource
      include ActiveTriples::Elasticsearch#::Background

      # FIXME: DRY out this block
      configure type: RDF::DC.BibliographicResource

      property :title,      predicate: RDF::DC.title,          # localized String
                            localize: true
      property :alt,        predicate: RDF::DC.alternative,    # non-localized String
                            localize: false
      property :references, predicate: RDF::DC.references      # URI
      property :referenced, predicate: RDF::DC.isReferencedBy  # Array
      property :is_valid,   predicate: RDF::DC.valid           # Boolean
      property :date,       predicate: RDF::DC.date            # Date
      property :issued,     predicate: RDF::DC.issued          # DateTime
      property :spatial,    predicate: RDF::DC.spatial         # Float
      # property :conformsTo, predicate: RDF::DC.conformsTo      # Hash
      property :identifier, predicate: RDF::DC.identifier      # Integer
      # property :license,    predicate: RDF::DC.license         # Range
      property :source,     predicate: RDF::DC.source          # Symbol
      property :created,    predicate: RDF::DC.created         # Time
      ###
    end
  end

  after do
    Object.send(:remove_const, 'Thing') if Object
  end

  shared_context 'with data' do
    before do
      # FIXME: DRY out this block
#      subject.title_translations = { 'en' => 'Comet in Moominland', # localized String
#                                     'sv' => 'Kometen kommer' }
      subject.title      = 'Comet in Moominland'
      subject.alt        = 'Mumintrollet pa kometjakt'  # non-localized String
      subject.references = 'http://foo.com'             # URI
      subject.referenced = %w(something another)        # Array
      subject.is_valid   = true                         # Boolean -> xsd:boolean
      subject.date       = Date.new(1946)               # Date -> xsd:date
      subject.issued     = DateTime.new(1951)           # DateTime -> xsd:date
      subject.spatial    = 12.345                       # Float -> xsd:double
      # subject.conformsTo = { 'key' => 'value' }         # Hash
      subject.identifier = 16_589_991                   # Integer -> xsd:integer
      # subject.license    = 1..10                        # Range
      subject.source     = :something                   # Symbol -> xsd:token
      subject.created    = Time.new.beginning_of_hour   # Time
    end
  end

  shared_context 'with relations' do
    let(:person) { Person.new }

    before do
      class Person
        include ActiveTriples::RDFSource
        include ActiveTriples::Elasticsearch#::Background

        configure type: RDF::FOAF.Person

        property :foaf_name, predicate: RDF::FOAF.name
        property :things, predicate: RDF::DC.relation, class_name: 'Thing'
      end
    end

    after do
      Object.send(:remove_const, 'Person') if Object
    end
  end

  context 'with data' do
    let(:subject) { Thing.new }

    include_context 'with data'

    it 'should do something' do
      binding.pry
    end
#    it_behaves_like 'a Searchable'
  end
=begin
  context 'with relations' do
    let(:subject) { Thing.new }

    include_context 'with data'
    include_context 'with relations'

    before do
      # many-to-many relation
      Thing.property :people, predicate: RDF::DC.creator, class_name: 'Person'

      # related object
      person.foaf_name = 'Tove Jansson'
      subject.people << person
    end

    it_behaves_like 'a Searchable'
    it_behaves_like 'a Searchable with related'
  end

  context 'with data from file' do
    TEST_FILE ||= './spec/shared/moomin.pdf'

    let(:subject) { Datastream.new file: open(TEST_FILE) }
    let(:source) { open(TEST_FILE).read } # ASCII-8BIT (binary)

    it_behaves_like 'a Searchable File'
  end

  context 'with data from string after creation' do
    data = 'And so Moomintroll was helplessly thrown out into a strange and dangerous world and dropped
            up to his ears in the first snowdrift of his experience. It felt unpleasantly prickly to his
            velvet skin, but at the same time his nose caught a new smell. It was a more serious smell
            than any he had met before, and slightly frightening. But it made him wide awake and greatly
            interested.'

    let(:subject) { Datastream.new }
    let(:source) { data } # UTF-8 (string)

    before do
      subject.file = StringIO.new(source)
    end

    it_behaves_like 'a Searchable File'
  end
=end
end
