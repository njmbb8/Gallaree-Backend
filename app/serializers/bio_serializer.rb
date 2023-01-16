class BioSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :biography, :artist_statement, :photo

  def photo
    rails_blob_url(object.photo)
  end
end
