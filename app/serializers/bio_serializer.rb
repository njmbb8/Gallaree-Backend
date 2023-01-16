class BioSerializer < ActiveModel::Serializer
  attributes :biography, :artist_statement, :photo

  def photo
    Rails.application.routes.url_helpers.rails_blob_url(object.photo)
  end
end
