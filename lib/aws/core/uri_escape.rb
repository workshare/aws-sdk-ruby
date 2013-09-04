# Copyright 2011-2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require 'cgi'

module AWS
  module Core

    # Provides helper methods for URI escaping values and paths.
    module UriEscape

      # @param [String] value
      # @return [String] Returns a URI escaped string.
      def escape value, is_path = false
        value = value.encode("UTF-8") if value.respond_to?(:encode)
        if is_path
          escape_rfc3986(value.to_s)
        else
          CGI::escape(value.to_s).gsub('+', '%20')
        end.gsub('%7E', '~')
      end
      module_function :escape

      # @param [String] value
      # @return [String] Returns a URI-escaped path without escaping the
      #   separators.
      def escape_path value
        escaped = ""
        value.scan(%r{(/*)([^/]*)(/*)}) do |(leading, part, trailing)|
          escaped << leading + escape(part, true) + trailing
        end
        escaped
      end
      module_function :escape_path

      private
      def escape_rfc3986(string)
        string.gsub(/([^ !$&'\(\)\*\+,;=a-zA-Z0-9_.-]+)/) do
          '%' + $1.unpack('H2' * $1.bytesize).join('%').upcase
        end.gsub(' ', '%20')
      end
    end
  end
end
