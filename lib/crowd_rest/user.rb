module CrowdRest
  class User

    def self.group_direct(username)
      options = {
        :query => {
          :username => username
        }
      }
      response = CrowdRest.get("/user/group/direct", options)
      normalize_response(response) do |successful_response|
        successful_response.groups = response['groups']
      end
    end

    def self.get_user(username)
      options = {
        :query => {
          :username => username
        }
      }
      response = CrowdRest.get('/user', options)
      normalize_response(response) do |successful_response|
        successful_response.user = response
      end
    end

    def self.add_user(user_options)
      response = CrowdRest.post('/user', body: user_options.to_json, content_type: :json, accept: :json)
      normalize_response(response, 201)
    end

    def self.update_user(username, user_options)
      response = CrowdRest.put("/user?username=#{CGI.escape(username)}", body: user_options.to_json, content_type: :json, accept: :json)
      normalize_response(response, 204)
    end


    private
    def self.normalize_response(response, success_code = 200)
      attributes = {
        :code => response.code,
        :body => response.body,
        :reason => response['error'] ? response['error']['reason'] : response['reason'] || nil,
        :message => response['error'] ? response['error']['message'] : response['message'] || nil
      }

      norm_response = OpenStruct.new(attributes)
      yield(norm_response) if block_given? && response.code == success_code
      norm_response
    end

  end
end
