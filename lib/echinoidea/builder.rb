
class Echinoidea::Builder
  def self.unique_builder_class_name
  	"ECBuilder#{Time.now.strftime('%y%m%d%H%M%S')}"
  end
end