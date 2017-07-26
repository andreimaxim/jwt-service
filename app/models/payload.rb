module Token
  class Payload

    ISSUER          = nil
    ISSUED_AT       = 946677600
    EXPIRATION_TIME = 1577829600
    SUBJECT         = nil
    AUDIENCE        = nil

    ALGO = 'RS256'.freeze

    def initialize
      @env = ENV.dup

      @pkey = OpenSSL::PKey::RSA.new(@env['RSA_PRIVATE_KEY'])
    end

    ##
    # Reserved claims

    def iss
      ENV.fetch('ISSUER') { ISSUER }
    end

    def exp
      ENV.fetch('EXPIRATION_TIME') { EXPIRATION_TIME }
    end

    def sub
      ENV.fetch('SUBJECT') { SUBJECT }
    end

    def aud
      ENV.fetch('AUDIENCE') { AUDIENCE }
    end

    def public_claims(override_value)
      str = ENV.fetch('CLAIM') { '' }

      JSON.parse(str.gsub('__REPLACE__', override_value))
    rescue JSON::ParserError => e
      Rollbar.error(e)

      {}
    end

    def reserved_claims
      {
        iss: iss,
        exp: exp,
        sub: sub,
        aud: aud
      }
    end

    def token(override_value = nil)
      if override_value.nil?
        nil
      else
        JWT.encode(reserved_claims.merge(public_claims(override_value)), @pkey, ALGO)
      end
    end

  end
end