# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `json_schemer` gem.
# Please instead update this file by running `bin/tapioca gem json_schemer`.

module JSONSchemer
  class << self
    def draft201909; end
    def draft202012; end
    def draft4; end
    def draft6; end
    def draft7; end
    def openapi(document, **options); end
    def openapi30; end
    def openapi30_document; end
    def openapi31; end
    def openapi31_document; end
    def schema(schema, meta_schema: T.unsafe(nil), **options); end
    def valid_schema?(schema, **options); end
    def validate_schema(schema, **options); end
  end
end

JSONSchemer::CLASSIC_ERROR_TYPES = T.let(T.unsafe(nil), Hash)
class JSONSchemer::CachedRefResolver < ::JSONSchemer::CachedResolver; end

class JSONSchemer::CachedResolver
  def initialize(&resolver); end

  def call(*args); end
end

module JSONSchemer::Draft201909; end
JSONSchemer::Draft201909::BASE_URI = T.let(T.unsafe(nil), URI::HTTPS)
module JSONSchemer::Draft201909::Meta; end
JSONSchemer::Draft201909::Meta::APPLICATOR = T.let(T.unsafe(nil), Hash)
JSONSchemer::Draft201909::Meta::CONTENT = T.let(T.unsafe(nil), Hash)
JSONSchemer::Draft201909::Meta::CORE = T.let(T.unsafe(nil), Hash)
JSONSchemer::Draft201909::Meta::FORMAT = T.let(T.unsafe(nil), Hash)
JSONSchemer::Draft201909::Meta::META_DATA = T.let(T.unsafe(nil), Hash)
JSONSchemer::Draft201909::Meta::SCHEMAS = T.let(T.unsafe(nil), Hash)
JSONSchemer::Draft201909::Meta::VALIDATION = T.let(T.unsafe(nil), Hash)
JSONSchemer::Draft201909::SCHEMA = T.let(T.unsafe(nil), Hash)
module JSONSchemer::Draft201909::Vocab; end
JSONSchemer::Draft201909::Vocab::APPLICATOR = T.let(T.unsafe(nil), Hash)
module JSONSchemer::Draft201909::Vocab::Applicator; end

class JSONSchemer::Draft201909::Vocab::Applicator::AdditionalItems < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def parse; end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::Draft201909::Vocab::Applicator::Items < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def parse; end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::Draft201909::Vocab::Applicator::UnevaluatedItems < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def parse; end
  def validate(instance, instance_location, keyword_location, context); end

  private

  def collect_unevaluated_items(result, instance_location, unevaluated_items); end
end

JSONSchemer::Draft201909::Vocab::CONTENT = T.let(T.unsafe(nil), Hash)
JSONSchemer::Draft201909::Vocab::CORE = T.let(T.unsafe(nil), Hash)
module JSONSchemer::Draft201909::Vocab::Core; end

class JSONSchemer::Draft201909::Vocab::Core::RecursiveAnchor < ::JSONSchemer::Keyword
  def parse; end
end

class JSONSchemer::Draft201909::Vocab::Core::RecursiveRef < ::JSONSchemer::Keyword
  def recursive_anchor; end
  def ref_schema; end
  def ref_uri; end
  def validate(instance, instance_location, keyword_location, context); end
end

JSONSchemer::Draft201909::Vocab::FORMAT = T.let(T.unsafe(nil), Hash)
JSONSchemer::Draft201909::Vocab::META_DATA = T.let(T.unsafe(nil), Hash)
JSONSchemer::Draft201909::Vocab::VALIDATION = T.let(T.unsafe(nil), Hash)
module JSONSchemer::Draft202012; end
JSONSchemer::Draft202012::BASE_URI = T.let(T.unsafe(nil), URI::HTTPS)
module JSONSchemer::Draft202012::Meta; end
JSONSchemer::Draft202012::Meta::APPLICATOR = T.let(T.unsafe(nil), Hash)
JSONSchemer::Draft202012::Meta::CONTENT = T.let(T.unsafe(nil), Hash)
JSONSchemer::Draft202012::Meta::CORE = T.let(T.unsafe(nil), Hash)
JSONSchemer::Draft202012::Meta::FORMAT_ANNOTATION = T.let(T.unsafe(nil), Hash)
JSONSchemer::Draft202012::Meta::FORMAT_ASSERTION = T.let(T.unsafe(nil), Hash)
JSONSchemer::Draft202012::Meta::META_DATA = T.let(T.unsafe(nil), Hash)
JSONSchemer::Draft202012::Meta::SCHEMAS = T.let(T.unsafe(nil), Hash)
JSONSchemer::Draft202012::Meta::UNEVALUATED = T.let(T.unsafe(nil), Hash)
JSONSchemer::Draft202012::Meta::VALIDATION = T.let(T.unsafe(nil), Hash)
JSONSchemer::Draft202012::SCHEMA = T.let(T.unsafe(nil), Hash)
module JSONSchemer::Draft202012::Vocab; end
JSONSchemer::Draft202012::Vocab::APPLICATOR = T.let(T.unsafe(nil), Hash)
module JSONSchemer::Draft202012::Vocab::Applicator; end

class JSONSchemer::Draft202012::Vocab::Applicator::AdditionalProperties < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def false_schema_error(formatted_instance_location:, **_arg1); end
  def parse; end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::Draft202012::Vocab::Applicator::AllOf < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def parse; end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::Draft202012::Vocab::Applicator::AnyOf < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def parse; end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::Draft202012::Vocab::Applicator::Contains < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def parse; end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::Draft202012::Vocab::Applicator::Dependencies < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def parse; end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::Draft202012::Vocab::Applicator::DependentSchemas < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def parse; end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::Draft202012::Vocab::Applicator::Else < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def parse; end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::Draft202012::Vocab::Applicator::If < ::JSONSchemer::Keyword
  def parse; end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::Draft202012::Vocab::Applicator::Items < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def parse; end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::Draft202012::Vocab::Applicator::Not < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def parse; end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::Draft202012::Vocab::Applicator::OneOf < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def parse; end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::Draft202012::Vocab::Applicator::PatternProperties < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def parse; end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::Draft202012::Vocab::Applicator::PrefixItems < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def parse; end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::Draft202012::Vocab::Applicator::Properties < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def parse; end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::Draft202012::Vocab::Applicator::PropertyNames < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def parse; end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::Draft202012::Vocab::Applicator::Then < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def parse; end
  def validate(instance, instance_location, keyword_location, context); end
end

JSONSchemer::Draft202012::Vocab::CONTENT = T.let(T.unsafe(nil), Hash)
JSONSchemer::Draft202012::Vocab::CORE = T.let(T.unsafe(nil), Hash)
module JSONSchemer::Draft202012::Vocab::Content; end

class JSONSchemer::Draft202012::Vocab::Content::ContentEncoding < ::JSONSchemer::Keyword
  def validate(instance, instance_location, keyword_location, _context); end
end

class JSONSchemer::Draft202012::Vocab::Content::ContentMediaType < ::JSONSchemer::Keyword
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::Draft202012::Vocab::Content::ContentSchema < ::JSONSchemer::Keyword
  def parse; end
  def validate(instance, instance_location, keyword_location, context); end
end

module JSONSchemer::Draft202012::Vocab::Core; end

class JSONSchemer::Draft202012::Vocab::Core::Anchor < ::JSONSchemer::Keyword
  def parse; end
end

class JSONSchemer::Draft202012::Vocab::Core::Comment < ::JSONSchemer::Keyword; end

class JSONSchemer::Draft202012::Vocab::Core::Defs < ::JSONSchemer::Keyword
  def parse; end
end

class JSONSchemer::Draft202012::Vocab::Core::DynamicAnchor < ::JSONSchemer::Keyword
  def parse; end
end

class JSONSchemer::Draft202012::Vocab::Core::DynamicRef < ::JSONSchemer::Keyword
  def dynamic_anchor; end
  def ref_schema; end
  def ref_uri; end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::Draft202012::Vocab::Core::Id < ::JSONSchemer::Keyword
  def parse; end
end

class JSONSchemer::Draft202012::Vocab::Core::Ref < ::JSONSchemer::Keyword
  def ref_schema; end
  def ref_uri; end
  def validate(instance, instance_location, keyword_location, context); end

  class << self
    def exclusive?; end
  end
end

class JSONSchemer::Draft202012::Vocab::Core::Schema < ::JSONSchemer::Keyword
  def parse; end
end

class JSONSchemer::Draft202012::Vocab::Core::UnknownKeyword < ::JSONSchemer::Keyword
  def fetch_unknown!(token); end
  def parse; end
  def unknown_schema!; end
  def validate(instance, instance_location, keyword_location, _context); end
end

class JSONSchemer::Draft202012::Vocab::Core::Vocabulary < ::JSONSchemer::Keyword
  def parse; end
end

JSONSchemer::Draft202012::Vocab::FORMAT_ANNOTATION = T.let(T.unsafe(nil), Hash)
JSONSchemer::Draft202012::Vocab::FORMAT_ASSERTION = T.let(T.unsafe(nil), Hash)
module JSONSchemer::Draft202012::Vocab::FormatAnnotation; end

class JSONSchemer::Draft202012::Vocab::FormatAnnotation::Format < ::JSONSchemer::Keyword
  extend ::JSONSchemer::Format::Duration
  extend ::JSONSchemer::Format::Email
  extend ::JSONSchemer::Format::Hostname
  extend ::JSONSchemer::Format::JSONPointer
  extend ::JSONSchemer::Format::URITemplate
  extend ::JSONSchemer::Format

  def error(formatted_instance_location:, **_arg1); end
  def parse; end
  def validate(instance, instance_location, keyword_location, _context); end
end

JSONSchemer::Draft202012::Vocab::FormatAnnotation::Format::DEFAULT_FORMAT = T.let(T.unsafe(nil), Proc)
module JSONSchemer::Draft202012::Vocab::FormatAssertion; end

class JSONSchemer::Draft202012::Vocab::FormatAssertion::Format < ::JSONSchemer::Keyword
  extend ::JSONSchemer::Format::Duration
  extend ::JSONSchemer::Format::Email
  extend ::JSONSchemer::Format::Hostname
  extend ::JSONSchemer::Format::JSONPointer
  extend ::JSONSchemer::Format::URITemplate
  extend ::JSONSchemer::Format

  def error(formatted_instance_location:, **_arg1); end
  def parse; end
  def validate(instance, instance_location, keyword_location, _context); end
end

JSONSchemer::Draft202012::Vocab::FormatAssertion::Format::DEFAULT_FORMAT = T.let(T.unsafe(nil), Proc)
JSONSchemer::Draft202012::Vocab::META_DATA = T.let(T.unsafe(nil), Hash)
module JSONSchemer::Draft202012::Vocab::MetaData; end

class JSONSchemer::Draft202012::Vocab::MetaData::ReadOnly < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::Draft202012::Vocab::MetaData::WriteOnly < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def validate(instance, instance_location, keyword_location, context); end
end

JSONSchemer::Draft202012::Vocab::UNEVALUATED = T.let(T.unsafe(nil), Hash)
module JSONSchemer::Draft202012::Vocab::Unevaluated; end

class JSONSchemer::Draft202012::Vocab::Unevaluated::UnevaluatedItems < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def parse; end
  def validate(instance, instance_location, keyword_location, context); end

  private

  def collect_unevaluated_items(result, instance_location, unevaluated_items); end
end

class JSONSchemer::Draft202012::Vocab::Unevaluated::UnevaluatedProperties < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def parse; end
  def validate(instance, instance_location, keyword_location, context); end

  private

  def collect_evaluated_keys(result, instance_location, evaluated_keys); end
end

JSONSchemer::Draft202012::Vocab::VALIDATION = T.let(T.unsafe(nil), Hash)
module JSONSchemer::Draft202012::Vocab::Validation; end

class JSONSchemer::Draft202012::Vocab::Validation::Const < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def validate(instance, instance_location, keyword_location, _context); end
end

class JSONSchemer::Draft202012::Vocab::Validation::DependentRequired < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def validate(instance, instance_location, keyword_location, _context); end
end

class JSONSchemer::Draft202012::Vocab::Validation::Enum < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def validate(instance, instance_location, keyword_location, _context); end
end

class JSONSchemer::Draft202012::Vocab::Validation::ExclusiveMaximum < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def validate(instance, instance_location, keyword_location, _context); end
end

class JSONSchemer::Draft202012::Vocab::Validation::ExclusiveMinimum < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def validate(instance, instance_location, keyword_location, _context); end
end

class JSONSchemer::Draft202012::Vocab::Validation::MaxContains < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::Draft202012::Vocab::Validation::MaxItems < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def validate(instance, instance_location, keyword_location, _context); end
end

class JSONSchemer::Draft202012::Vocab::Validation::MaxLength < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def validate(instance, instance_location, keyword_location, _context); end
end

class JSONSchemer::Draft202012::Vocab::Validation::MaxProperties < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def validate(instance, instance_location, keyword_location, _context); end
end

class JSONSchemer::Draft202012::Vocab::Validation::Maximum < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def validate(instance, instance_location, keyword_location, _context); end
end

class JSONSchemer::Draft202012::Vocab::Validation::MinContains < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::Draft202012::Vocab::Validation::MinItems < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def validate(instance, instance_location, keyword_location, _context); end
end

class JSONSchemer::Draft202012::Vocab::Validation::MinLength < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def validate(instance, instance_location, keyword_location, _context); end
end

class JSONSchemer::Draft202012::Vocab::Validation::MinProperties < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def validate(instance, instance_location, keyword_location, _context); end
end

class JSONSchemer::Draft202012::Vocab::Validation::Minimum < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def validate(instance, instance_location, keyword_location, _context); end
end

class JSONSchemer::Draft202012::Vocab::Validation::MultipleOf < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def validate(instance, instance_location, keyword_location, _context); end
end

class JSONSchemer::Draft202012::Vocab::Validation::Pattern < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def parse; end
  def validate(instance, instance_location, keyword_location, _context); end
end

class JSONSchemer::Draft202012::Vocab::Validation::Required < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, details:, **_arg2); end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::Draft202012::Vocab::Validation::Type < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def validate(instance, instance_location, keyword_location, _context); end

  private

  def valid_type(type, instance); end
end

class JSONSchemer::Draft202012::Vocab::Validation::UniqueItems < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def validate(instance, instance_location, keyword_location, _context); end
end

module JSONSchemer::Draft4; end
JSONSchemer::Draft4::BASE_URI = T.let(T.unsafe(nil), URI::HTTP)
JSONSchemer::Draft4::SCHEMA = T.let(T.unsafe(nil), Hash)
module JSONSchemer::Draft4::Vocab; end
JSONSchemer::Draft4::Vocab::ALL = T.let(T.unsafe(nil), Hash)
module JSONSchemer::Draft4::Vocab::Validation; end

class JSONSchemer::Draft4::Vocab::Validation::ExclusiveMaximum < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def validate(instance, instance_location, keyword_location, _context); end
end

class JSONSchemer::Draft4::Vocab::Validation::ExclusiveMinimum < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def validate(instance, instance_location, keyword_location, _context); end
end

class JSONSchemer::Draft4::Vocab::Validation::Type < ::JSONSchemer::Draft202012::Vocab::Validation::Type
  private

  def valid_type(type, instance); end
end

module JSONSchemer::Draft6; end
JSONSchemer::Draft6::BASE_URI = T.let(T.unsafe(nil), URI::HTTP)
JSONSchemer::Draft6::SCHEMA = T.let(T.unsafe(nil), Hash)
module JSONSchemer::Draft6::Vocab; end
JSONSchemer::Draft6::Vocab::ALL = T.let(T.unsafe(nil), Hash)
module JSONSchemer::Draft7; end
JSONSchemer::Draft7::BASE_URI = T.let(T.unsafe(nil), URI::HTTP)
JSONSchemer::Draft7::SCHEMA = T.let(T.unsafe(nil), Hash)
module JSONSchemer::Draft7::Vocab; end
JSONSchemer::Draft7::Vocab::ALL = T.let(T.unsafe(nil), Hash)
module JSONSchemer::Draft7::Vocab::Validation; end

class JSONSchemer::Draft7::Vocab::Validation::AdditionalItems < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def parse; end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::Draft7::Vocab::Validation::ContentEncoding < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def validate(instance, instance_location, keyword_location, _context); end
end

class JSONSchemer::Draft7::Vocab::Validation::ContentMediaType < ::JSONSchemer::Keyword
  def error(formatted_instance_location:, **_arg1); end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::Draft7::Vocab::Validation::Ref < ::JSONSchemer::Draft202012::Vocab::Core::Ref
  class << self
    def exclusive?; end
  end
end

class JSONSchemer::EcmaRegexp
  class << self
    def ruby_equivalent(pattern); end
  end
end

JSONSchemer::EcmaRegexp::RUBY_EQUIVALENTS = T.let(T.unsafe(nil), Hash)
class JSONSchemer::EcmaRegexp::Syntax < ::Regexp::Syntax::Base; end
JSONSchemer::EcmaRegexp::Syntax::SYNTAX = JSONSchemer::EcmaRegexp::Syntax

module JSONSchemer::Errors
  class << self
    def pretty(error); end
  end
end

JSONSchemer::FILE_URI_REF_RESOLVER = T.let(T.unsafe(nil), Proc)

module JSONSchemer::Format
  include ::JSONSchemer::Format::Duration
  include ::JSONSchemer::Format::Email
  include ::JSONSchemer::Format::Hostname
  include ::JSONSchemer::Format::JSONPointer
  include ::JSONSchemer::Format::URITemplate

  def iri_escape(data); end
  def parse_uri_scheme(data); end
  def valid_date_time?(data); end
  def valid_ip?(data, family); end
  def valid_regex?(data); end
  def valid_spec_format?(data, format); end
  def valid_uri?(data); end
  def valid_uri_reference?(data); end
  def valid_uuid?(data); end

  class << self
    def decode_content_encoding(data, content_encoding); end
    def parse_content_media_type(data, content_media_type); end
    def percent_encode(data, regexp); end
  end
end

JSONSchemer::Format::ASCII_8BIT_TO_PERCENT_ENCODED = T.let(T.unsafe(nil), Hash)
JSONSchemer::Format::DATE_TIME_OFFSET_REGEX = T.let(T.unsafe(nil), Regexp)

module JSONSchemer::Format::Duration
  def valid_duration?(data); end
end

JSONSchemer::Format::Duration::DURATION = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Duration::DURATION_REGEX = T.let(T.unsafe(nil), Regexp)
JSONSchemer::Format::Duration::DUR_DATE = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Duration::DUR_DAY = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Duration::DUR_HOUR = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Duration::DUR_MINUTE = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Duration::DUR_MONTH = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Duration::DUR_SECOND = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Duration::DUR_TIME = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Duration::DUR_WEEK = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Duration::DUR_YEAR = T.let(T.unsafe(nil), String)

module JSONSchemer::Format::Email
  def valid_email?(data); end
end

JSONSchemer::Format::Email::ADDRESS_LITERAL = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Email::ATOM = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Email::A_TEXT = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Email::DOT_STRING = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Email::EMAIL_REGEX = T.let(T.unsafe(nil), Regexp)
JSONSchemer::Format::Email::LOCAL_PART = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Email::MAILBOX = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Email::QUOTED_PAIR_SMTP = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Email::QUOTED_STRING = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Email::Q_CONTENT_SMTP = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Email::Q_TEXT_SMTP = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Email::UTF8_NON_ASCII = T.let(T.unsafe(nil), String)
JSONSchemer::Format::HOUR_24_REGEX = T.let(T.unsafe(nil), Regexp)

module JSONSchemer::Format::Hostname
  def valid_hostname?(data); end
end

JSONSchemer::Format::Hostname::ARABIC_EXTENDED_DIGITS_REGEX = T.let(T.unsafe(nil), Regexp)
JSONSchemer::Format::Hostname::ARABIC_INDIC_DIGITS_REGEX = T.let(T.unsafe(nil), Regexp)
JSONSchemer::Format::Hostname::CONTEXT_REGEX = T.let(T.unsafe(nil), Regexp)
JSONSchemer::Format::Hostname::EXCEPTIONS_DISALLOWED = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Hostname::EXCEPTIONS_PVALID = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Hostname::GREEK_LOWER_NUMERAL_SIGN = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Hostname::HEBREW_PUNCTUATION = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Hostname::HOSTNAME_REGEX = T.let(T.unsafe(nil), Regexp)
JSONSchemer::Format::Hostname::JOINING_TYPE_D_CHARACTER_CLASS = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Hostname::JOINING_TYPE_L_CHARACTER_CLASS = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Hostname::JOINING_TYPE_R_CHARACTER_CLASS = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Hostname::JOINING_TYPE_T_CHARACTER_CLASS = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Hostname::KATAKANA_MIDDLE_DOT_CONTEXT_REGEX = T.let(T.unsafe(nil), Regexp)
JSONSchemer::Format::Hostname::KATAKANA_MIDDLE_DOT_REGEX = T.let(T.unsafe(nil), Regexp)
JSONSchemer::Format::Hostname::LABEL_CHARACTER_CLASS = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Hostname::LABEL_REGEX_STRING = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Hostname::LEADING_CHARACTER_CLASS = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Hostname::LETTER_DIGITS = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Hostname::MARKS = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Hostname::MIDDLE_DOT = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Hostname::VIRAMA_CHARACTER_CLASS = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Hostname::ZERO_WIDTH_NON_JOINER_JOINING_TYPE = T.let(T.unsafe(nil), String)
JSONSchemer::Format::Hostname::ZERO_WIDTH_VIRAMA = T.let(T.unsafe(nil), String)
JSONSchemer::Format::INVALID_QUERY_REGEX = T.let(T.unsafe(nil), Regexp)
JSONSchemer::Format::IP_REGEX = T.let(T.unsafe(nil), Regexp)
JSONSchemer::Format::IRI_ESCAPE_REGEX = T.let(T.unsafe(nil), Regexp)

module JSONSchemer::Format::JSONPointer
  def valid_json_pointer?(data); end
  def valid_relative_json_pointer?(data); end
end

JSONSchemer::Format::JSONPointer::JSON_POINTER_REGEX = T.let(T.unsafe(nil), Regexp)
JSONSchemer::Format::JSONPointer::JSON_POINTER_REGEX_STRING = T.let(T.unsafe(nil), String)
JSONSchemer::Format::JSONPointer::RELATIVE_JSON_POINTER_REGEX = T.let(T.unsafe(nil), Regexp)
JSONSchemer::Format::LEAP_SECOND_REGEX = T.let(T.unsafe(nil), Regexp)
JSONSchemer::Format::NIL_UUID = T.let(T.unsafe(nil), String)

module JSONSchemer::Format::URITemplate
  def valid_uri_template?(data); end
end

JSONSchemer::Format::URITemplate::EXPLODE = T.let(T.unsafe(nil), String)
JSONSchemer::Format::URITemplate::EXPRESSION = T.let(T.unsafe(nil), String)
JSONSchemer::Format::URITemplate::LITERALS = T.let(T.unsafe(nil), String)
JSONSchemer::Format::URITemplate::MAX_LENGTH = T.let(T.unsafe(nil), String)
JSONSchemer::Format::URITemplate::MODIFIER_LEVEL4 = T.let(T.unsafe(nil), String)
JSONSchemer::Format::URITemplate::OPERATOR = T.let(T.unsafe(nil), String)
JSONSchemer::Format::URITemplate::PCT_ENCODED = T.let(T.unsafe(nil), String)
JSONSchemer::Format::URITemplate::PREFIX = T.let(T.unsafe(nil), String)
JSONSchemer::Format::URITemplate::URI_TEMPLATE = T.let(T.unsafe(nil), String)
JSONSchemer::Format::URITemplate::URI_TEMPLATE_REGEX = T.let(T.unsafe(nil), Regexp)
JSONSchemer::Format::URITemplate::VARCHAR = T.let(T.unsafe(nil), String)
JSONSchemer::Format::URITemplate::VARIABLE_LIST = T.let(T.unsafe(nil), String)
JSONSchemer::Format::URITemplate::VARNAME = T.let(T.unsafe(nil), String)
JSONSchemer::Format::URITemplate::VARSPEC = T.let(T.unsafe(nil), String)
JSONSchemer::Format::UUID_REGEX = T.let(T.unsafe(nil), Regexp)
class JSONSchemer::InvalidEcmaRegexp < ::StandardError; end
class JSONSchemer::InvalidFileURI < ::StandardError; end
class JSONSchemer::InvalidRefPointer < ::StandardError; end
class JSONSchemer::InvalidRefResolution < ::StandardError; end
class JSONSchemer::InvalidRegexpResolution < ::StandardError; end

class JSONSchemer::Keyword
  include ::JSONSchemer::Output

  def initialize(value, parent, keyword, schema = T.unsafe(nil)); end

  def absolute_keyword_location; end
  def parent; end
  def parsed; end
  def root; end
  def schema_pointer; end
  def validate(_instance, _instance_location, _keyword_location, _context); end
  def value; end

  private

  def parse; end
  def subschema(value, keyword = T.unsafe(nil), **options); end
end

module JSONSchemer::Location
  class << self
    def escape_json_pointer_token(token); end
    def join(location, name); end
    def resolve(location); end
    def root; end
  end
end

JSONSchemer::Location::JSON_POINTER_TOKEN_ESCAPE_CHARS = T.let(T.unsafe(nil), Hash)
JSONSchemer::Location::JSON_POINTER_TOKEN_ESCAPE_REGEX = T.let(T.unsafe(nil), Regexp)
JSONSchemer::META_SCHEMAS_BY_BASE_URI_STR = T.let(T.unsafe(nil), Hash)
JSONSchemer::META_SCHEMA_CALLABLES_BY_BASE_URI_STR = T.let(T.unsafe(nil), Hash)

class JSONSchemer::OpenAPI
  def initialize(document, **options); end

  def ref(value); end
  def schema(name); end
  def valid?; end
  def validate(**options); end
end

module JSONSchemer::OpenAPI30; end
JSONSchemer::OpenAPI30::BASE_URI = T.let(T.unsafe(nil), URI::Generic)
module JSONSchemer::OpenAPI30::Document; end
JSONSchemer::OpenAPI30::Document::SCHEMA = T.let(T.unsafe(nil), Hash)
JSONSchemer::OpenAPI30::Document::SCHEMAS = T.let(T.unsafe(nil), Hash)
module JSONSchemer::OpenAPI30::Meta; end
JSONSchemer::OpenAPI30::Meta::SCHEMAS = T.let(T.unsafe(nil), Hash)
JSONSchemer::OpenAPI30::SCHEMA = T.let(T.unsafe(nil), Hash)
module JSONSchemer::OpenAPI30::Vocab; end
JSONSchemer::OpenAPI30::Vocab::BASE = T.let(T.unsafe(nil), Hash)
module JSONSchemer::OpenAPI30::Vocab::Base; end

class JSONSchemer::OpenAPI30::Vocab::Base::Type < ::JSONSchemer::Draft4::Vocab::Validation::Type
  def parse; end
end

module JSONSchemer::OpenAPI31; end
JSONSchemer::OpenAPI31::BASE_URI = T.let(T.unsafe(nil), URI::HTTPS)

module JSONSchemer::OpenAPI31::Document
  class << self
    def dialect_schema(dialect); end
  end
end

JSONSchemer::OpenAPI31::Document::DEFAULT_DIALECT = T.let(T.unsafe(nil), String)
JSONSchemer::OpenAPI31::Document::DIALECTS = T.let(T.unsafe(nil), Array)
JSONSchemer::OpenAPI31::Document::OTHER_DIALECTS = T.let(T.unsafe(nil), Array)
JSONSchemer::OpenAPI31::Document::SCHEMA = T.let(T.unsafe(nil), Hash)
JSONSchemer::OpenAPI31::Document::SCHEMAS = T.let(T.unsafe(nil), Hash)
JSONSchemer::OpenAPI31::Document::SCHEMA_BASE = T.let(T.unsafe(nil), Hash)
module JSONSchemer::OpenAPI31::Meta; end
JSONSchemer::OpenAPI31::Meta::BASE = T.let(T.unsafe(nil), Hash)
JSONSchemer::OpenAPI31::Meta::SCHEMAS = T.let(T.unsafe(nil), Hash)
JSONSchemer::OpenAPI31::SCHEMA = T.let(T.unsafe(nil), Hash)
module JSONSchemer::OpenAPI31::Vocab; end
JSONSchemer::OpenAPI31::Vocab::BASE = T.let(T.unsafe(nil), Hash)
module JSONSchemer::OpenAPI31::Vocab::Base; end

class JSONSchemer::OpenAPI31::Vocab::Base::AllOf < ::JSONSchemer::Draft202012::Vocab::Applicator::AllOf
  def skip_ref_once; end
  def skip_ref_once=(_arg0); end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::OpenAPI31::Vocab::Base::AnyOf < ::JSONSchemer::Draft202012::Vocab::Applicator::AnyOf
  def validate(*_arg0); end
end

class JSONSchemer::OpenAPI31::Vocab::Base::Discriminator < ::JSONSchemer::Keyword
  include ::JSONSchemer::Format::JSONPointer

  def error(formatted_instance_location:, **_arg1); end
  def skip_ref_once; end
  def skip_ref_once=(_arg0); end
  def validate(instance, instance_location, keyword_location, context); end
end

class JSONSchemer::OpenAPI31::Vocab::Base::OneOf < ::JSONSchemer::Draft202012::Vocab::Applicator::OneOf
  def validate(*_arg0); end
end

module JSONSchemer::Output
  def keyword; end
  def schema; end

  private

  def deep_stringify_keys(obj); end
  def escaped_keyword; end
  def fragment_encode(location); end
  def join_location(location, keyword); end
  def result(instance, instance_location, keyword_location, valid, nested = T.unsafe(nil), type: T.unsafe(nil), annotation: T.unsafe(nil), details: T.unsafe(nil), ignore_nested: T.unsafe(nil)); end
  def stringify(key); end
end

JSONSchemer::Output::FRAGMENT_ENCODE_REGEX = T.let(T.unsafe(nil), Regexp)

class JSONSchemer::Result < ::Struct
  def annotation; end
  def annotation=(_); end
  def basic; end
  def classic; end
  def detailed; end
  def details; end
  def details=(_); end
  def error; end
  def flag; end
  def ignore_nested; end
  def ignore_nested=(_); end
  def insert_property_defaults(context); end
  def instance; end
  def instance=(_); end
  def instance_location; end
  def instance_location=(_); end
  def keyword_location; end
  def keyword_location=(_); end
  def nested; end
  def nested=(_); end
  def nested_key; end
  def nested_key=(_); end
  def output(output_format); end
  def source; end
  def source=(_); end
  def to_classic; end
  def to_output_unit; end
  def type; end
  def type=(_); end
  def valid; end
  def valid=(_); end
  def verbose; end

  class << self
    def [](*_arg0); end
    def inspect; end
    def members; end
    def new(*_arg0); end
  end
end

class JSONSchemer::Schema
  include ::JSONSchemer::Output
  include ::JSONSchemer::Format::JSONPointer

  def initialize(value, parent = T.unsafe(nil), root = T.unsafe(nil), keyword = T.unsafe(nil), base_uri: T.unsafe(nil), meta_schema: T.unsafe(nil), vocabulary: T.unsafe(nil), format: T.unsafe(nil), formats: T.unsafe(nil), keywords: T.unsafe(nil), before_property_validation: T.unsafe(nil), after_property_validation: T.unsafe(nil), insert_property_defaults: T.unsafe(nil), property_default_resolver: T.unsafe(nil), ref_resolver: T.unsafe(nil), regexp_resolver: T.unsafe(nil), output_format: T.unsafe(nil), resolve_enumerators: T.unsafe(nil), access_mode: T.unsafe(nil)); end

  def absolute_keyword_location; end
  def after_property_validation; end
  def base_uri; end
  def base_uri=(_arg0); end
  def before_property_validation; end
  def bundle; end
  def custom_keywords; end
  def defs_keyword; end
  def error(formatted_instance_location:, **options); end
  def format; end
  def formats; end
  def id_keyword; end
  def insert_property_defaults; end
  def inspect; end
  def keyword_order; end
  def keyword_order=(_arg0); end
  def keywords; end
  def keywords=(_arg0); end
  def meta_schema; end
  def meta_schema=(_arg0); end
  def parent; end
  def parsed; end
  def property_default_resolver; end
  def ref(value); end
  def resolve_ref(uri); end
  def resolve_regexp(pattern); end
  def resources; end
  def root; end
  def schema_pointer; end
  def valid?(instance, **options); end
  def valid_schema?; end
  def validate(instance, output_format: T.unsafe(nil), resolve_enumerators: T.unsafe(nil), access_mode: T.unsafe(nil)); end
  def validate_instance(instance, instance_location, keyword_location, context); end
  def validate_schema; end
  def value; end
  def vocabulary; end

  private

  def parse; end
  def ref_resolver; end
  def regexp_resolver; end
  def resolve_enumerators!(output); end
  def root_keyword_location; end
end

class JSONSchemer::Schema::Context < ::Struct
  def access_mode; end
  def access_mode=(_); end
  def adjacent_results; end
  def adjacent_results=(_); end
  def dynamic_scope; end
  def dynamic_scope=(_); end
  def instance; end
  def instance=(_); end
  def original_instance(instance_location); end
  def short_circuit; end
  def short_circuit=(_); end

  class << self
    def [](*_arg0); end
    def inspect; end
    def members; end
    def new(*_arg0); end
  end
end

JSONSchemer::Schema::DEFAULT_AFTER_PROPERTY_VALIDATION = T.let(T.unsafe(nil), Array)
JSONSchemer::Schema::DEFAULT_BASE_URI = T.let(T.unsafe(nil), URI::Generic)
JSONSchemer::Schema::DEFAULT_BEFORE_PROPERTY_VALIDATION = T.let(T.unsafe(nil), Array)
JSONSchemer::Schema::DEFAULT_FORMATS = T.let(T.unsafe(nil), Hash)
JSONSchemer::Schema::DEFAULT_KEYWORDS = T.let(T.unsafe(nil), Hash)
JSONSchemer::Schema::DEFAULT_PROPERTY_DEFAULT_RESOLVER = T.let(T.unsafe(nil), Proc)
JSONSchemer::Schema::DEFAULT_REF_RESOLVER = T.let(T.unsafe(nil), Proc)
JSONSchemer::Schema::DEFAULT_SCHEMA = T.let(T.unsafe(nil), String)
JSONSchemer::Schema::ECMA_REGEXP_RESOLVER = T.let(T.unsafe(nil), Proc)
JSONSchemer::Schema::ID_KEYWORD_CLASS = JSONSchemer::Draft202012::Vocab::Core::Id
JSONSchemer::Schema::NET_HTTP_REF_RESOLVER = T.let(T.unsafe(nil), Proc)
JSONSchemer::Schema::NOT_KEYWORD_CLASS = JSONSchemer::Draft202012::Vocab::Applicator::Not
JSONSchemer::Schema::PROPERTIES_KEYWORD_CLASS = JSONSchemer::Draft202012::Vocab::Applicator::Properties
JSONSchemer::Schema::RUBY_REGEXP_RESOLVER = T.let(T.unsafe(nil), Proc)
JSONSchemer::Schema::SCHEMA_KEYWORD_CLASS = JSONSchemer::Draft202012::Vocab::Core::Schema
JSONSchemer::Schema::UNKNOWN_KEYWORD_CLASS = JSONSchemer::Draft202012::Vocab::Core::UnknownKeyword
JSONSchemer::Schema::VOCABULARY_KEYWORD_CLASS = JSONSchemer::Draft202012::Vocab::Core::Vocabulary
class JSONSchemer::UnknownContentEncoding < ::StandardError; end
class JSONSchemer::UnknownContentMediaType < ::StandardError; end
class JSONSchemer::UnknownFormat < ::StandardError; end
class JSONSchemer::UnknownOutputFormat < ::StandardError; end
class JSONSchemer::UnknownRef < ::StandardError; end
class JSONSchemer::UnknownVocabulary < ::StandardError; end
class JSONSchemer::UnsupportedMetaSchema < ::StandardError; end
class JSONSchemer::UnsupportedOpenAPIVersion < ::StandardError; end
JSONSchemer::VERSION = T.let(T.unsafe(nil), String)
JSONSchemer::VOCABULARIES = T.let(T.unsafe(nil), Hash)
JSONSchemer::VOCABULARY_ORDER = T.let(T.unsafe(nil), Hash)
JSONSchemer::WINDOWS_URI_PATH_REGEX = T.let(T.unsafe(nil), Regexp)
