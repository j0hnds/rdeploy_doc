module RDeployDoc

  class FileSystemResource < Resource

    DIRECTORY_RESOURCE_TYPE = 'd'
    FILE_RESOURCE_TYPE = '-'
    LINK_RESOURCE_TYPE = 'l'

    attr_accessor :path, :owner, :group, :mode

    def initialize(description, name, prerequisites)
      super
    end

    def to_posix
      format("%10s %-10s %-10s %s", posix_mode, @owner, @group, targeted_name)
    end

    def posix_mode
      format_posix_mode
    end

    private

    def targeted_name
      File.basename(@path)
    end

    def format_posix_mode(resource_type=FileSystemResource::FILE_RESOURCE_TYPE)
      mode_string = resource_type.clone

      set_gid_bit = ((02 * 01000) & @mode) == 1024
      set_uid_bit = ((04 * 01000) & @mode) == 2048

      binary_mode = (0777 & @mode).to_s(2).rjust(9, '0')

      mode_chars = 'rwx'
      position = 0
      (0..8).to_a.each do |i|
        c = binary_mode[i]
        if i == 5
          mode_string << (set_gid_bit ? 's' : (c == '1' ? mode_chars[position] : '-'))
        elsif i == 2
          mode_string << (set_uid_bit ? 's' : (c == '1' ? mode_chars[position] : '-'))
        else
          mode_string << (c == '1' ? mode_chars[position] : '-')
        end
        position = position < 2 ? position + 1 : 0
      end

      mode_string
    end

  end

end
