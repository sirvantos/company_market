class Md5HashValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || "Wrong md5 hash") unless
        value =~ /[a-z0-9]{32}/i
  end
end