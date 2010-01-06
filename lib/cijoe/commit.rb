class CIJoe
  class Commit < Struct.new(:sha, :user, :project)
    def url
      commit_url_template = Config.cijoe.commit_url_template || "http://github.com/{{user}}/{{project}}/commit/{{sha}}"
      %w(user project sha).inject(commit_url_template) {|acc, var| acc.gsub("{{#{var}}}", send(var.to_sym))  }
    end

    def author
      raw_commit_lines.grep(/Author:/).first.split(':', 2)[-1]
    end

    def committed_at
      raw_commit_lines.grep(/Date:/).first.split(':', 2)[-1]
    end

    def message
      raw_commit.split("\n\n", 3)[1].to_s.strip
    end

    def raw_commit
      @raw_commit ||= `git show #{sha}`.chomp
    end

    def raw_commit_lines
      @raw_commit_lines ||= raw_commit.split("\n")
    end
  end
end
