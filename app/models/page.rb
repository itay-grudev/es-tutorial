class Page < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  index_name Rails.application.class.parent_name.underscore
  document_type self.new.class.name.downcase

  settings index: { number_of_shards: 1 } do
    mapping dynamic: false do
      indexes :title, analyzer: 'english'
      indexes :body, analyzer: 'english'
    end
  end

  def self.search(query)
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query: query,
            fields: ['title^5', 'body']
          }
        },
        highlight: {
          pre_tags: ['<mark>'],
          post_tags: ['</mark>'],
          fields: {
            title: {},
            body: {},
          }
        },
        suggest: {
          text: query,
          title: {
            term: {
              size: 1,
              field: :title
            }
          },
          body: {
            term: {
              size: 1,
              field: :body
            }
          }
        }
      }
    )
  end

  def as_indexed_json(options = nil)
    self.as_json( only: [ :title, :body ] )
  end

end
