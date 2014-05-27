require "siren_call/version"
require "siren_call/entity"

module SirenCall
  def self.parse(hash_document)
    Entity.parse(hash_document)
  end
end
