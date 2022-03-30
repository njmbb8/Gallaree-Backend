class BioSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :biography, :artist_statement, :photo

  def photo
    rails_blob_path(object.photo, only_path: true)
  end
end
