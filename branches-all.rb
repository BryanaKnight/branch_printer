require_relative './printer.rb'

class Branches
  include Printer

  attr_reader :head,
              :head_pointer,
              :local_branches,
              :master_branch,
              :printer,
              :remote_branches

  def initialize
    @local_branches = Dir['.git/refs/heads/*'].each {|b| b.gsub!('.git/refs/heads/', '') }
    @master_branch = File.read('.git/HEAD').split(" ")[-1].gsub!('refs/heads/', '')
    @remote_branches = get_remote_branches
    @printer = Printer
  end

  def print_output
    local_branches.each { |lb| printer.local(branch_prefix(lb), lb) }
    printer.head(head, head_pointer) unless get_head_pointer.nil?
    remote_branches.each { |line| printer.remote(line) }
  end

  def get_head_pointer
    return unless File.exist?('.git/refs/remotes/origin/HEAD')
    @head = Dir['.git/refs/remotes/origin/HEAD'].first
    @head_pointer = File.read('.git/refs/remotes/origin/HEAD')
  end

  private

  def get_remote_branches
    if File.exist?('.git/packed-refs')
      File.open('.git/packed-refs')
    else
      Dir['.git/refs/remotes/origin/*']
    end
  end

  def branch_prefix(local_branch)
    local_branch == master_branch ? "* " : "  "
  end

end

b = Branches.new
b.print_output
