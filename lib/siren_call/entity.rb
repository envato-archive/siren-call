module SirenCall
  class Entity
    attr_reader :classes, :properties, :entities, :links

    def entities_by_class(class_name)
      (class_map[class_name] || []).freeze
    end

    def self.parse(document)
      e = Entity.new

      e.instance_eval do
        self.classes = document["class"].freeze
        self.properties = document['properties'].freeze

        self.entities = Array(document['entities']).collect do |doc_entity|
          Entity.parse(doc_entity)
        end

        self.class_map = Hash.new

        self.entities.each do |entity|
          entity.classes.each do |clz|
            self.class_map[clz] ||= []
            self.class_map[clz] << entity
          end
        end
      end

      e
    end

    protected

    attr_writer :classes, :properties, :entities, :links
    attr_accessor :class_map
  end
end