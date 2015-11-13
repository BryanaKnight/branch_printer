module Printer
  extend self

  def remote(line)
    puts "  #{path_after(line)}" if line.include?('remotes')
  end

  def head(head, head_pointer)
    puts "  #{path_after(head)} -> #{path_after(head_pointer, 'origin')}"
  end

  def local(branch_prefix, local_branch)
    puts "#{branch_prefix}#{local_branch}"
  end

  private

  def path_after(full_path, word='remotes')
    full_path[(/#{word}+(.+)/)]
  end

end
