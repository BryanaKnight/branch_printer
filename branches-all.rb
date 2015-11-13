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
    @master_branch = File.read('.git/HEAD').split(" ")[-1].gsub!('refs/heads/', '')
    @remote_branches = File.open('.git/packed-refs')
    @local_branches = Dir['.git/refs/heads/*'].each {|b| b.gsub!('.git/refs/heads/', '') }
    @head = Dir['.git/refs/remotes/origin/HEAD'].first
    @head_pointer = File.read('.git/refs/remotes/origin/HEAD')
    @printer = Printer
  end

  def print_output
    local_branches.each { |lb| printer.local(branch_prefix(lb), lb) }
    printer.head(head, head_pointer)
    remote_branches.each_line { |line| printer.remote(line) }
  end

  private

  def branch_prefix(local_branch)
    local_branch == master_branch ? "* " : "  "
  end

end

b = Branches.new
b.print_output
